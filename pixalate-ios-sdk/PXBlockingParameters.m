//
//  PXBlockingParameters.m
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#import "PXBlockingParameters.h"

#define IsEqual(x,y) (x != nil ? [x isEqualToString:y] : y == nil )

@implementation PXBlockingParametersBuilder

@end

@interface PXBlockingParameters ()

@property(nonatomic,copy) NSString* _Nullable deviceId;
@property(nonatomic,copy) NSString* _Nullable userAgent;
@property(nonatomic,copy) NSString* _Nullable ip;

@end

@implementation PXBlockingParameters

- (instancetype _Nonnull) init NS_SWIFT_UNAVAILABLE("use initWithBuilder:") {
    return self;
}

- (instancetype) initWithBuilder:(PXBlockingParametersBuilder*) builder {
    self.deviceId = builder.deviceId;
    self.userAgent = builder.userAgent;
    self.ip = builder.ip;
    
    return self;
}

+ (instancetype) makeWithBuilder:(void (^)(PXBlockingParametersBuilder*))updateBlock {
    PXBlockingParametersBuilder* builder = [[PXBlockingParametersBuilder alloc] init];
    updateBlock( builder );
    return [[PXBlockingParameters alloc] initWithBuilder:builder];
}

- (id)copyWithZone:(NSZone *)zone {
    PXBlockingParameters *copy = [[PXBlockingParameters alloc] init];
    copy.deviceId = self.deviceId;
    copy.userAgent = self.userAgent;
    copy.ip = self.ip;
    
    return copy;
}

- (BOOL)isEqual:(id)object {
    if( self == object ) return YES;
    if( ![object isKindOfClass:[PXBlockingParameters class] ] ) return NO;
    
    PXBlockingParameters *other = (PXBlockingParameters*)object;
    
    if( !IsEqual( self.deviceId, other.deviceId ) ) return NO;
    if( !IsEqual( self.ip, other.ip ) ) return NO;
    if( !IsEqual( self.userAgent, other.userAgent ) ) return NO;
    
    return YES;
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    if( self.deviceId != nil ) result = prime * result + [self.deviceId hash];
    else result = prime * result;
    if( self.userAgent != nil ) result = prime * result + [self.userAgent hash];
    else result = prime * result;
    if( self.ip != nil ) result = prime * result + [self.ip hash];
    else result = prime * result;
    
    return result;
}

@end
