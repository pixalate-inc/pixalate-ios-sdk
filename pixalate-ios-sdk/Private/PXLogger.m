//
//  PXLogger.m
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#import "PXLogger.h"

@implementation PXLogger

static PXLogLevel logLevel;

+ (void)setLogLevel:(PXLogLevel)level {
    logLevel = level;
}

+ (void)log:(PXLogLevel)level message:(NSString* _Nullable)message {
    if( level > 0 && level <= logLevel ) {
        NSLog(@"Pixalate: %@", message);
    }
}

@end
