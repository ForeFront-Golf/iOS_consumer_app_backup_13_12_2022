//
//  DDMBlockOperation.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "DDMBlockOperation.h"

@implementation DDMBlockOperation

- (BOOL)isAsynchronous
{
    return NO;
}

- (void)start
{
    for (void (^executionBlock)(void) in [self executionBlocks])
    {
        executionBlock();
    }
}

@end
