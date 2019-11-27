//
//  PXLogger.h
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXLogger_h
#define PXLogger_h

#import <Foundation/Foundation.h>

#import "PXLogLevel.h"

@interface PXLogger : NSObject

+ (void)setLogLevel:(PXLogLevel)level;
+ (void)logWithFormat:(PXLogLevel)level message:(NSString* _Nullable)message, ...;
+ (void)log:(PXLogLevel)level message:(NSString* _Nullable)message;

@end

@implementation PXLogger

static PXLogLevel logLevel;

+ (void)setLogLevel:(PXLogLevel)level {
    logLevel = level;
}

+ (void)logWithFormat:(PXLogLevel)level message:(NSString* _Nullable)message, ... {
    if( level > 0 && level <= logLevel ) {
        va_list args;
        va_start( args, message );
        
        NSString* str = [[NSString alloc] initWithFormat:message arguments:args];
        NSLog( @"Pixalate: %@", str );
        
        va_end( args );
    }
}

+ (void)log:(PXLogLevel)level message:(NSString* _Nullable)message {
    if( level > 0 && level <= logLevel ) {
        NSLog(@"Pixalate: %@", message);
    }
}

@end

#endif /* PXLogger_h */
