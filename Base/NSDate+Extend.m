//
//  NSDate+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

+ (NSDate*)localUTCDate
{
    NSInteger interval = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:interval];
    return date;
}

- (long)unixSeconds
{
    long seconds = [self timeIntervalSince1970];
    return seconds;
}

- (long long)unixMilliseconds
{
    long long milliseconds = (long long)([self timeIntervalSince1970] * 1000.0);
    return milliseconds;
}

- (NSString*)toStringWithFormat:(NSString*)format
{
    NSString *suffix;
    NSInteger day = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
    if(day >= 11 && day <= 13)
    {
        suffix = @"th";
    }
    else if(day % 10 == 1)
    {
        suffix = @"st";
    }
    else if(day % 10 == 2)
    {
        suffix = @"nd";
    }
    else if(day % 10 == 3)
    {
        suffix = @"rd";
    }
    else
    {
        suffix = @"th";
    }
    
    format = [format stringByReplacingOccurrencesOfString:@"ds" withString:@"d*"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *string = [formatter stringFromDate:self];
    string = [string stringByReplacingOccurrencesOfString:@"*" withString:suffix];
    return string;
}

- (NSDate*)startDateForUnit:(NSCalendarUnit)unit
{
    NSDate *unitStartDate;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    [calendar rangeOfUnit:unit startDate:&unitStartDate interval:NULL forDate:self];
    return unitStartDate;
}

- (NSDate*)endDateForUnit:(NSCalendarUnit)unit
{
    NSDate *unitStartDate = [self startDateForUnit:unit];
    NSDate *unitEndDate = [unitStartDate dateByAdding:1 ofUnit:unit];
    return unitEndDate;
}

- (NSDate*)dateByAdding:(NSInteger)value ofUnit:(NSCalendarUnit)unit
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *components = [calendar components:unit fromDate:self];
    if(unit == NSCalendarUnitMinute)
    {
        components.minute = value;
    }
    else if(unit == NSCalendarUnitHour)
    {
        components.hour = value;
    }
    else if(unit == NSCalendarUnitDay)
    {
        components.day = value;
    }
    else if(unit == NSCalendarUnitWeekOfYear)
    {
        components.weekOfYear = value;
    }
    else if(unit == NSCalendarUnitMonth)
    {
        components.month = value;
    }
    else if(unit == NSCalendarUnitYear)
    {
        components.year = value;
    }
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    return date;
}

@end
