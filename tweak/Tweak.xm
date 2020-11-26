#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <dlfcn.h>
#import "FBMemoryProfiler.h"

@interface FBMemoryProfile

+ (instancetype)sharedManager;
- (void)showExplorer;

@end


@interface FBMemoryProfileManager: NSObject

@property (nonatomic, strong) FBMemoryProfiler *memoryProfiler;

@end

@implementation FBMemoryProfileManager

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static FBMemoryProfileManager *loader;
	dispatch_once(&onceToken, ^{
		loader = [[FBMemoryProfileManager alloc] init];
	});	

	return loader;
}

- (void)show {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FBMemoryProfiler *profile = [[objc_getClass("FBMemoryProfileManager") sharedInstance] memoryProfiler];
        if (!profile.isEnabled) {
            [profile enable];
        }
    });
	
}

@end

%ctor {
	@autoreleasepool {
		NSDictionary *pref = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.bomo.memoryprofile.plist"];
		
		NSString *profileFrameworkPath = @"/usr/lib/FBMemoryProfiler/FBMemoryProfiler.framework/FBMemoryProfiler";
		if (![[NSFileManager defaultManager] fileExistsAtPath:profileFrameworkPath]) {
			NSLog(@"FBMemoryProfiler.framework file not found: %@", profileFrameworkPath);
			return;
		}

		NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
		NSString *keyPath = [NSString stringWithFormat:@"FBMemoryProfilerEnabled-%@", bundleId];
		if ([[pref objectForKey:keyPath] boolValue]) {
			void *handle = dlopen([profileFrameworkPath UTF8String], RTLD_NOW);
			if (handle == NULL) {
				char *error = dlerror();
				NSLog(@"Load FBMemoryProfiler.framework fail: %s", error);
				return;
			} 

			FBMemoryProfileManager *manager = [FBMemoryProfileManager sharedInstance];
			[[NSNotificationCenter defaultCenter] addObserver:manager
											selector:@selector(show)
												name:UIApplicationDidBecomeActiveNotification
												object:nil];

			[objc_getClass("FBAssociationManager") hook];
			FBAllocationTrackerManager *trackerManager = [objc_getClass("FBAllocationTrackerManager") sharedManager];
			[trackerManager startTrackingAllocations];
			[trackerManager enableGenerations];
		
			manager.memoryProfiler = [[objc_getClass("FBMemoryProfiler") alloc] initWithPlugins:@[] retainCycleDetectorConfiguration:nil];
		}
	}
}
