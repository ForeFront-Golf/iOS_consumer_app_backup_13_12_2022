//
//  ItemTypeCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-06.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "ItemTypeCell.h"

@implementation ItemTypeCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _itemType = object;
    _nameLabel.text = _itemType.name;
}

@end
