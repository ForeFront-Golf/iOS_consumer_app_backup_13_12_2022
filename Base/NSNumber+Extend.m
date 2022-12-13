//
//  NSNumber+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "NSNumber+Extend.h"

@implementation NSNumber (Extend)

- (NSString*)toTimeString
{
    NSInteger totalSeconds = self.integerValue;
    int seconds = (totalSeconds % 60);
    int minutes = (totalSeconds % 3600) / 60;
    int hours = (totalSeconds % 86400) / 3600;
    long days = totalSeconds / 86400;
        
    if(days > 0)
    {
        return [NSString stringWithFormat:@"%ld days %ld:%.2ld:%.2ld", days, (long)hours, (long)minutes, (long)seconds];
    }
    else if(hours > 0)
    {
        return [NSString stringWithFormat:@"%ld:%.2ld:%.2ld", (long)hours, (long)minutes, (long)seconds];
    }
    else if(minutes > 0)
    {
        return [NSString stringWithFormat:@"%ld:%.2ld", (long)minutes, (long)seconds];
    }
    else
    {
        return [NSString stringWithFormat:@"0:%.2ld", (long)seconds];
    }
}

- (NSString*)toPriceString
{
    NSString* price = [NSString stringWithFormat:@"$%.02f",self.floatValue];
    return price;
}

@end
