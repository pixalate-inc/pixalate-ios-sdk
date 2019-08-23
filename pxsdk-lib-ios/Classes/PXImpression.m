//
//  PXImpression.m
//  pxsdk-lib-ios
//
//  Created by Pixalate on 8/13/19.
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#import "PXImpression.h"
#import "Pixalate.h"

NSString *const PXDeviceOS = @"kv26";
NSString *const PXClientId = @"clid";
NSString *const PXSupplyType = @"kv24";
NSString *const PXCacheBuster = @"cb";
NSString *const PXS8Flag = @"dvid";

// internal keys

@interface PXImpressionBuilder ()

@property(nonatomic,copy,readwrite) NSString* _Nonnull clientId;
@property(nonatomic,readwrite) NSMutableDictionary<NSString*,NSString*> *_Nonnull urlParameters;

@end

@implementation PXImpressionBuilder

-(instancetype)initWithClientId: (NSString *)clientId {
    self.clientId = clientId;
    self.urlParameters = [[NSMutableDictionary<NSString*,NSString*> alloc] init];
    
    return self;
}

-(void)setParameter:(NSString *)key withValue:(NSString *)value {
    self.urlParameters[ key ] = value;
}

- (NSString *)objectForKeyedSubscript:(NSString *)key {
    return self.urlParameters[ key ];
}

- (void)setObject:(NSString *)anObject forKeyedSubscript:(NSString *)key {
    NSLog( @"%@", self.urlParameters );
    self.urlParameters[ key ] = anObject;
}

@end




@interface PXImpression ()

@property(nonatomic, readwrite) NSDictionary<NSString*,NSString*> *urlParameters;

@end

@implementation PXImpression

-(void) setParameter:(NSString*)key withValue:(NSString *)value {
    
}

- (instancetype) initWithParameters:(NSDictionary<NSString*,NSString*>*)urlParameters {
    
    return self;
}

-(instancetype) initWithBuilder:(PXImpressionBuilder *)builder {
    NSMutableDictionary* dict = builder.urlParameters;
    
    NSMutableArray<NSString*>* keys = [[NSMutableArray<NSString*> alloc] initWithArray:dict.allKeys];
    
    NSMutableArray<NSString*>* values = [[NSMutableArray<NSString*> alloc] initWithArray:dict.allValues];
    
    [keys addObject:PXClientId];
    [values addObject:builder.clientId];
    
    [keys addObject:PXDeviceOS];
    [values addObject:@"iOS"]; // @todo: get official name for ios
    
    [keys addObject:PXSupplyType];
    if( builder.isVideo ) {
        [values addObject:@"InApp_Video"];
        
        [keys addObject:PXS8Flag];
        [values addObject:@"dvid"];
    } else {
        [values addObject:@"InApp"];
    }
    
    self.urlParameters = [[NSDictionary<NSString*,NSString*> alloc] initWithObjects:values forKeys:keys];
    
    return self;
}

+(instancetype) makeWithClientId:(NSString *)clientId builder:(void (^)(PXImpressionBuilder * _Nonnull))updateBlock {
    PXImpressionBuilder* builder = [[PXImpressionBuilder alloc] initWithClientId: clientId];
    updateBlock( builder );
    PXImpression* imp = [[PXImpression alloc] initWithBuilder:builder];
    
    return imp;
}

@end
