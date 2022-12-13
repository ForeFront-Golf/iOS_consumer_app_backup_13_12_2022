//
//  NSIndexPath+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation NSIndexPath (Extend)

+ (NSIndexPath*)indexPathForRow:(NSInteger)row
{
    return [NSIndexPath indexPathForRow:row inSection:0];
}

@end
