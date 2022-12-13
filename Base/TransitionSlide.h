//
//  TransitionSlide.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "Transition.h"

enum
{
    TD_Right = 0,
    TD_BottomRight,
    TD_Bottom,
    TD_BottomLeft,
    TD_Left,
    TD_TopLeft,
    TD_Top,
    TD_TopRight,
    TD_Max
};
typedef NSInteger TransitionDirection;

@interface TransitionSlide : Transition

+ (instancetype)transitionWithDirection:(TransitionDirection)direction;

@property TransitionDirection direction;

- (CGRect)rectOffsetFromRect:(CGRect)rect forDirection:(TransitionDirection)direction;

@end
