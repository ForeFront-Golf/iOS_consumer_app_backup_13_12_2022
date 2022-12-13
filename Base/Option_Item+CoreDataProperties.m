//
//  Option_Item+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-16.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Option_Item+CoreDataProperties.h"

@implementation Option_Item (CoreDataProperties)

+ (NSFetchRequest<Option_Item *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Option_Item"];
}

@dynamic available;
@dynamic created_at;
@dynamic desc;
@dynamic modified_at;
@dynamic name;
@dynamic option_item_id;
@dynamic price;
@dynamic valid;
@dynamic added_tax_rate;
@dynamic option_group;
@dynamic order_items;

@end
