//
//  OptionGroupHeaderView.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "OptionGroupHeaderView.h"

@implementation OptionGroupHeaderView

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _optionGroup = object;
    
    _nameLabel.text = _optionGroup.name;
    _requiredLabel.alpha = _optionGroup.required.boolValue;
}

@end
