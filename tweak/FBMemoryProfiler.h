
@interface FBObjectGraphConfiguration

@end

@interface FBMemoryProfiler : NSObject

- (instancetype)initWithPlugins:(NSArray *)plugins retainCycleDetectorConfiguration:(FBObjectGraphConfiguration *)retainCycleDetectorConfiguration;
- (void)enable;
- (void)disable;
- (BOOL)isEnabled;
@end


@interface FBAssociationManager

+ (void)hook;

@end

@interface FBAllocationTrackerManager

+ (FBAllocationTrackerManager *)sharedManager;
- (void)startTrackingAllocations;
- (void)enableGenerations;

@end