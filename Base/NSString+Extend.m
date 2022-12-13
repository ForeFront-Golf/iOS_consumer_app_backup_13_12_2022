//
//  NSString+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)

- (NSString*)trimWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isValidEmailAddress
{
    static const NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:self];
}

- (CGSize)sizeForWidth:(CGFloat)width andFont:(UIFont*)font
{
    static const int padding = 16;
    width -= padding;
    CGRect frame = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
    CGSize size = CGSizeMake(frame.size.width, frame.size.height);
    return size;
}

- (NSDate *)toDateWithFormat:(NSString*)format //TODO: account for timezones
{
    NSDate *date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    
    date = [formatter dateFromString:self];
    
    return date;
}

@end
