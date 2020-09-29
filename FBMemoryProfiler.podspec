#
#  Be sure to run `pod spec lint FBMemoryProfiler.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "FBMemoryProfiler"
  s.version      = "0.1.3"
  s.summary      = "iOS tool that helps with profiling iOS Memory usage"
  s.homepage     = "https://github.com/facebook/FBMemoryProfiler"
  s.license      = "BSD"
  s.author       = { "Grzegorz Pstrucha" => "gricha@fb.com" }
  s.platform     = :ios, "7.0"
  s.source       = {
    :git => "https://github.com/facebook/FBMemoryProfiler.git",
    :tag => "0.1.3"
  }
  s.source_files  = [
    "FBMemoryProfiler", "FBMemoryProfiler/**/*.{h,m,mm,c}", 
    "FBRetainCycleDetector", "{FBRetainCycleDetector,rcd_fishhook}/**/*.{h,m,mm,c}",
    "FBAllocationTracker", "FBAllocationTracker/**/*.{h,m,mm}"
  ]

  mrr_files = [
    'FBRetainCycleDetector/Associations/FBAssociationManager.h',
    'FBRetainCycleDetector/Associations/FBAssociationManager.mm',
    'FBRetainCycleDetector/Layout/Blocks/FBBlockStrongLayout.h',
    'FBRetainCycleDetector/Layout/Blocks/FBBlockStrongLayout.m',
    'FBRetainCycleDetector/Layout/Blocks/FBBlockStrongRelationDetector.h',
    'FBRetainCycleDetector/Layout/Blocks/FBBlockStrongRelationDetector.m',
    'FBRetainCycleDetector/Layout/Classes/FBClassStrongLayoutHelpers.h',
    'FBRetainCycleDetector/Layout/Classes/FBClassStrongLayoutHelpers.m',

    'FBAllocationTracker/NSObject+FBAllocationTracker.h',
    'FBAllocationTracker/NSObject+FBAllocationTracker.mm',
    'FBAllocationTracker/Generations/FBAllocationTrackerNSZombieSupport.h',
    'FBAllocationTracker/Generations/FBAllocationTrackerNSZombieSupport.mm'
  ]

  files = Pathname.glob("**/*.{h,m,mm,c}")
  files = files.map {|file| file.to_path}
  files = files.reject {|file| mrr_files.include?(file)}

  s.requires_arc = files

  s.public_header_files = [
    'FBRetainCycleDetector/Detector/FBRetainCycleDetector.h',
    'FBRetainCycleDetector/Associations/FBAssociationManager.h',
    'FBRetainCycleDetector/Graph/FBObjectiveCBlock.h',
    'FBRetainCycleDetector/Graph/FBObjectiveCGraphElement.h',
    'FBRetainCycleDetector/Graph/Specialization/FBObjectiveCNSCFTimer.h',
    'FBRetainCycleDetector/Graph/FBObjectiveCObject.h',
    'FBRetainCycleDetector/Graph/FBObjectGraphConfiguration.h',
    'FBRetainCycleDetector/Filtering/FBStandardGraphEdgeFilters.h',

    'FBAllocationTracker/FBAllocationTracker.h',
    'FBAllocationTracker/FBAllocationTrackerManager.h',
    'FBAllocationTracker/FBAllocationTrackerSummary.h',
    'FBAllocationTracker/FBAllocationTrackerDefines.h',

    'FBMemoryProfiler/Options/FBMemoryProfilerPluggable.h',
    'FBMemoryProfiler/Controllers/FBMemoryProfilerPresenting.h',
    
    'FBMemoryProfiler/FBMemoryProfiler.h',
    'FBMemoryProfiler/FBMemoryProfilerPresentationModeDelegate.h',
    
  ]
  
  s.framework = "Foundation", "CoreGraphics", "UIKit"
  s.library = 'c++'
end
