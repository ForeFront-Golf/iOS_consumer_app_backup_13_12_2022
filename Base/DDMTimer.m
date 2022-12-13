//
//  DDMTimer.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "DDMTimer.h"

@implementation DDMTimer

+ (NSTimer*)scheduledAutoReleaseTimerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)value
{
    DDMTimer *timer = [DDMTimer new];
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timer selector:@selector(timerFired:) userInfo:nil repeats:value];
    timer.target = target;
    timer.selector = selector;
    [[NSRunLoop mainRunLoop] addTimer:timer.timer forMode:NSRunLoopCommonModes];
    return timer.timer;
}

- (void)timerFired:(NSTimer*)timer
{
    if(_target)
    {
        IMP imp = [_target methodForSelector:_selector];
        void (*func)(id, SEL) = (void *)imp;
        func(_target, _selector);
    }
    else
    {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
