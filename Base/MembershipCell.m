//
//  MembershipCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-04-05.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//

#import "MembershipCell.h"

@implementation MembershipCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _membership = object;
    _nameLabel.text = _membership.club.name;
}

@end
