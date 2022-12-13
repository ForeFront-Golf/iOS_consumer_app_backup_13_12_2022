//
//  ImageViewCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-01-13.
//  Copyright © 2016 DDMAppDesign. All rights reserved.
//

#import "ImageViewCell.h"

@implementation ImageViewCell

- (void)setupCollectionView:(UICollectionView *)collectionView withObject:(id)object forOwner:(id)owner
{
    _object = object;
    [_object fetchDataForKey:kThumbnail];
    _imageView.image = [_object getBestImage];
}

@end
