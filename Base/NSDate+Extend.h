//
//  NSDate+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)

+ (NSDate*)localUTCDate;

- (long)unixSeconds;
- (long long)unixMilliseconds;
- (NSString*)toStringWithFormat:(NSString*)format;
- (NSDate*)startDateForUnit:(NSCalendarUnit)unit;
- (NSDate*)endDateForUnit:(NSCalendarUnit)unit;
- (NSDate*)dateByAdding:(NSInteger)value ofUnit:(NSCalendarUnit)unit;

@end
