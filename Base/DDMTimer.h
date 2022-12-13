//
//  DDMTimer.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMTimer : NSObject

+ (NSTimer*)scheduledAutoReleaseTimerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)value;

@property NSTimer *timer;
@property (weak, nonatomic) id target;
@property SEL selector;

@end
