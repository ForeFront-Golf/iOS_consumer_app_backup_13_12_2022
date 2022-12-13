//
//  MenuItemCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "MenuItemCell.h"

@implementation MenuItemCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _menuItemType = object;
    _nameLabel.text = _menuItemType.menu_item.name;
    _priceLabel.text = [_menuItemType.menu_item.price toPriceString];
    
    [_menuItemType.menu_item.photo fetchDataForKey:kThumbnail];
    _itemImageView.image = [_menuItemType.menu_item getBestImage];
}

@end
