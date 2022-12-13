//
//  ContainerView.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-21.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "ContainerView.h"

@implementation ContainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
    {
        return nil;
    }
    return hitView;
}

@end
