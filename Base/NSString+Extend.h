//
//  NSString+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extend)

- (NSString*)trimWhitespace;
- (BOOL)isValidEmailAddress;
- (CGSize)sizeForWidth:(CGFloat)width andFont:(UIFont*)font;
- (NSDate*)toDateWithFormat:(NSString*)format;

@end
