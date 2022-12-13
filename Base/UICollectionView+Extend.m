//
//  UICollectionView+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UICollectionView+Extend.h"

@implementation UICollectionView (Extend)

//only works for full screen cells.
- (NSIndexPath*)getCurrentIndexPath
{
    CGPoint center = {self.bounds.size.width * 0.5f + self.contentOffset.x, self.bounds.size.height * 0.5f + self.contentOffset.y};
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:center];
    return indexPath;
}

- (id)getCurrentCell
{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:[self getCurrentIndexPath]];
    return cell;
}

@end
