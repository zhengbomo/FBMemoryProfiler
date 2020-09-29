/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBAllocationTrackerSummary.h"

@implementation FBAllocationTrackerSummary {
    BOOL _hasCheckFilterBundle;
    BOOL _isFromApp;
}

- (instancetype)initWithAllocations:(NSUInteger)allocations
                      deallocations:(NSUInteger)deallocations
                       aliveObjects:(NSInteger)aliveObjects
                          className:(NSString *)className
                       instanceSize:(NSUInteger)instanceSize
{
  if ((self = [super init])) {
    _allocations = allocations;
    _deallocations = deallocations;
    _aliveObjects = aliveObjects;
    _className = className;
    _instanceSize = instanceSize;
  }

  return self;
}

-(NSString *)description
{
  return [NSString stringWithFormat:@"%@: allocations=%@ deallocations=%@ alive=%@ size=%@", _className, @(_allocations), @(_deallocations), @(_aliveObjects), @(_instanceSize)];
}


- (BOOL)isFromApp {
    if (!_hasCheckFilterBundle) {
        // find all bundle from
        static NSArray *bundleIds;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableArray *_bundleIds = [NSMutableArray arrayWithObject:NSBundle.mainBundle.bundleIdentifier];
            NSString *mainBundlePath = NSBundle.mainBundle.bundlePath;
            for (NSBundle *bundle in NSBundle.allFrameworks) {
                if ([bundle.bundlePath hasPrefix:mainBundlePath]) {
                    [_bundleIds addObject:bundle.bundleIdentifier];
                }
            }
            bundleIds = [_bundleIds copy];
        });
        
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(self.className)];
        if ([bundleIds containsObject:bundle.bundleIdentifier]) {
            _isFromApp = YES;
        } else {
            _isFromApp = NO;
        }
        _hasCheckFilterBundle = YES;
    }
    return _isFromApp;
}

@end
