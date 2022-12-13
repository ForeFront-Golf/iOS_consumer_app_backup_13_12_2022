//
//  UIScrollView+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const kScrollToViewHeightOffset = 100;
static NSInteger const kKeyboardHeight = 216;

@interface UIScrollView (Extend)

- (void)scrollToView:(UIView*)view;
- (void)scrollToView:(UIView*)view withHeightOffset:(CGFloat)offset;
- (void)scrollToViewsBottom:(UIView*)view withHeightOffset:(CGFloat)offset;

@end
