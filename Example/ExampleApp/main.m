/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the LICENSE file in
 * the root directory of this source tree.
 */

#import <UIKit/UIKit.h>
#import <FBMemoryProfiler/FBAllocationTracker.h>
#import <FBMemoryProfiler/FBAssociationManager.h>
#import "AppDelegate.h"


int main(int argc, char * argv[]) {
  [FBAssociationManager hook];
  [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
  [[FBAllocationTrackerManager sharedManager] enableGenerations];

  @autoreleasepool {
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
