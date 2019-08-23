//
//  PXBlockingParameters.m
//  pxsdk-lib-ios
//
//  Created by Pixalate on 8/13/19.
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#import "PXBlockingParameters.h"

@implementation PXBlockingParametersBuilder

@end

@interface PXBlockingParameters ()

@property(nonatomic,copy) NSString* _Nullable deviceId;
@property(nonatomic,copy) NSString* _Nullable userAgent;
@property(nonatomic,copy) NSString* _Nullable ip;

@end

@implementation PXBlockingParameters

- (instancetype _Nonnull) initWithBuilder:(PXBlockingParametersBuilder*) builder {
    self.deviceId = builder.deviceId;
    self.userAgent = builder.userAgent;
    self.ip = builder.ip;
    
    return self;
}

+ (instancetype _Nonnull) makeWithBuilder:(void (^ _Nonnull)(PXBlockingParametersBuilder* _Nonnull))updateBlock {
    PXBlockingParametersBuilder* builder = [[PXBlockingParametersBuilder alloc] init];
    updateBlock( builder );
    return [[PXBlockingParameters alloc] initWithBuilder:builder];
}

@end
