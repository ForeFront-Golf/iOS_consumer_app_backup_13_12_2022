//
//  Menu_Item+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-16.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Menu_Item+CoreDataProperties.h"

@implementation Menu_Item (CoreDataProperties)

+ (NSFetchRequest<Menu_Item *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Menu_Item"];
}

@dynamic available;
@dynamic created_at;
@dynamic desc;
@dynamic menu_item_id;
@dynamic modified_at;
@dynamic name;
@dynamic photo_url;
@dynamic photo_url_thumb;
@dynamic price;
@dynamic valid;
@dynamic added_tax_rate;
@dynamic item_types;
@dynamic menu;
@dynamic menu_item_types;
@dynamic option_groups;
@dynamic order_items;
@dynamic photo;

@end
