//
//  UIView+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

- (id)initFromNib;
- (UICollectionView*)collectionView;
- (UITableView*)tableView;
- (UITableView*)tableViewCell;
- (id)viewController;
//- (id)subviewOfClass:(Class)class;
//- (id)superViewOfClass:(Class)class;

- (void)animateAlphaTo:(CGFloat)alpha withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay;
- (void)animateFrameTo:(CGRect)frame withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay;
- (void)animateConstraint:(NSLayoutConstraint*)constraint toConstant:(NSInteger)constant withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay;
- (void)animateConstraint:(NSLayoutConstraint*)constraint toConstant:(NSInteger)constant withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andCompletionBlock:(void (^)(void))block;
- (void)animateToColor:(UIColor *)color withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay;

- (CGPoint)getPositionInView:(UIView*)view;
- (CGRect)getFrameInView:(UIView*)view;

- (UIImage*)getScreenshotAfterUpdate:(BOOL)afterUpdate;

- (void)constrainToSuperview;
- (void)constrainToView:(UIView*)view;

- (UIColor*)colorOfPoint:(CGPoint)point;

- (void)setupTableView:(UITableView*)tableView withObject:(id)object forOwner:(id)owner;
- (void)setupCollectionView:(UICollectionView*)collectionView withObject:(id)object forOwner:(id)owner;

@end
