//
//  MenuTabCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-05-15.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "MenuTabCell.h"

@implementation MenuTabCell

- (void)setupCollectionView:(UICollectionView *)collectionView withObject:(id)object forOwner:(id)owner
{
    _menu = object;
    
    _nameLabel.text = _menu.name;
    
    
}

@end
