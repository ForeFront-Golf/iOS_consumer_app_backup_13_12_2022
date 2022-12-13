//
//  UIView+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (id)initFromNib
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    for(id object in objects)
    {
        if([object isKindOfClass:[self class]])
        {
            self = object;
        }
    }
    return self;
}
#pragma clang diagnostic pop

- (UITableView*)collectionView
{
    return [self superViewOfClass:[UICollectionView class]];
}

- (UITableView*)tableView
{
    return [self superViewOfClass:[UITableView class]];
}

- (UITableView*)tableViewCell
{
    return [self superViewOfClass:[UITableViewCell class]];
}

- (id)subviewOfClass:(Class)class
{
    for(UIView *subview in self.subviews)
    {
        if([subview isKindOfClass:class])
        {
            return subview;
        }
    }
    return nil;
}

- (id)superViewOfClass:(Class)class
{
    id view = self.superview;
    while(view && [view isKindOfClass:class] == NO)
    {
        view = [view superview];
    }
    
    return view;
}

- (id)viewController
{
    Class viewControllerClass = [UIViewController class];
    UIResponder *responder = self;
    while((responder = [responder nextResponder]))
    {
        if([responder isKindOfClass: viewControllerClass])
        {
            return responder;
        }
    }
    return nil;
}

- (void)animateAlphaTo:(CGFloat)alpha withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    NSArray *data = @[@(alpha), @(duration)];
    if(!delay)
    {
        [self animateAlphaWithDelay:data];
    }
    else
    {
        [self performSelector:@selector(animateAlphaWithDelay:) withObject:data afterDelay:delay];
    }
}

- (void)animateAlphaWithDelay:(NSArray*)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:[data[1] floatValue]
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionShowHideTransitionViews
                         animations:^{[self setAlpha:[data[0] floatValue]];}
                         completion:NULL];
    });
}

- (void)animateFrameTo:(CGRect)frame withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration
                              delay:delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{self.frame = frame;}
                         completion:NULL];
    });
}

- (void)animateConstraint:(NSLayoutConstraint*)constraint toConstant:(NSInteger)constant withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        constraint.constant = constant;
        [UIView animateWithDuration:duration
                              delay:delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{[self layoutIfNeeded];}
                         completion:NULL];
    });
}

- (void)animateConstraint:(NSLayoutConstraint*)constraint toConstant:(NSInteger)constant withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andCompletionBlock:(void (^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        constraint.constant = constant;
        [UIView animateWithDuration:duration
                              delay:delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{[self layoutIfNeeded];}
                         completion:^ (BOOL completed) {
                             block();
                         }];
    });
}

- (void)animateToColor:(UIColor *)color withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:duration
                              delay:delay
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{self.backgroundColor = color;}
                         completion:NULL];
    });
}

- (CGPoint)getPositionInView:(UIView*)view
{
    UIView *superView = self;
    CGPoint rootPosition = self.frame.origin;
    while(superView)
    {
        superView = superView.superview;
        if(superView.superview)
        {
            rootPosition = [superView convertPoint:rootPosition toView:superView.superview];
            if(superView.superview == view)
            {
                return rootPosition;
            }
        }
    }
    
    return CGPointZero;
}

- (CGRect)getFrameInView:(UIView*)view
{
    UIView *superView = self;
    CGRect rootFrame = self.frame;
    while(superView)
    {
        superView = superView.superview;
        if(superView.superview)
        {
            rootFrame = [superView convertRect:rootFrame toView:superView.superview];
            if(superView == view)
            {
                return rootFrame;
            }
        }
    }
    
    return CGRectZero;
}

- (UIImage*)getScreenshotAfterUpdate:(BOOL)afterUpdate
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdate];
    UIImage *imageSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  imageSnapshot;
}

- (void)constrainToSuperview
{
    [self constrainToView:self.superview];
}

- (void)constrainToView:(UIView*)view
{
    if(!view)
    {
        return;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (void)setupTableView:(UITableView*)tableView withObject:(id)object forOwner:(id)owner
{
}

- (void)setupCollectionView:(UICollectionView*)collectionView withObject:(id)object forOwner:(id)owner
{
}

@end
