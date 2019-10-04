//
//  PXBlockingResult.h
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXBlockingResult_h
#define PXBlockingResult_h

@interface PXBlockingResult : NSObject

@property(nonatomic,copy) NSError* _Nullable error;
@property(nonatomic) double probability;
@property(nonatomic) double time;
@property(nonatomic,readonly) BOOL valid;

+(instancetype _Nonnull)makeWithError:(NSError* _Nonnull)err;
+(instancetype _Nonnull)makeWithProbability:(double)probability;

-(BOOL)getValid;

@end
@implementation PXBlockingResult

+(_Nonnull instancetype)makeWithError:(NSError * _Nonnull)err {
    PXBlockingResult *res = [[PXBlockingResult alloc] init];
    res.error = err;
    res.time = [[NSDate date] timeIntervalSince1970] + Pixalate.globalConfig.cacheAge;
    res.probability = 0;
    
    return res;
}

+(_Nonnull instancetype)makeWithProbability:(double)probability {
    PXBlockingResult *res = [[PXBlockingResult alloc] init];
    res.error = nil;
    res.probability = probability;
    res.time = [[NSDate date] timeIntervalSince1970] + Pixalate.globalConfig.cacheAge;
    
    return res;
}

-(BOOL)getValid {
    return self.time > [[NSDate date] timeIntervalSince1970];
}

@end

#endif /* PXBlockingResult_h */
