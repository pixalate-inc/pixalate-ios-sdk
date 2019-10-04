//
//  PXLogger.h
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXLogger_h
#define PXLogger_h

#import "PXLogLevel.h"

@interface PXLogger : NSObject

+ (void)setLogLevel:(PXLogLevel)level;
+ (void)log:(PXLogLevel)level message:(NSString* _Nullable)message;

@end

#endif /* PXLogger_h */
