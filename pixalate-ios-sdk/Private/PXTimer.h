//
//  PXTimer.h
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXTimer_h
#define PXTimer_h

typedef void (^PXTimerBlock)(void);

@interface PXTimer : NSObject

@property(nonatomic,copy) PXTimerBlock block;

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(PXTimerBlock)block;
-(void)timerHandler:(NSTimer*)timer;
-(instancetype)initWithBlock:(PXTimerBlock)block;

@end
@implementation PXTimer

- (instancetype)initWithBlock:(PXTimerBlock)block {
    self.block = block;
    return self;
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(PXTimerBlock)block {
    PXTimer* timer = [[PXTimer alloc] initWithBlock:block];
    [NSTimer scheduledTimerWithTimeInterval:interval target:timer selector:@selector(timerHandler:) userInfo:nil repeats:false];
    
    return timer;
}

- (void)timerHandler:(NSTimer *)timer {
    self.block();
}

@end

#endif /* PXTimer_h */
