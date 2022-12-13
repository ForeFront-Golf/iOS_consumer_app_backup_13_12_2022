//
//  Item_Type+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Item_Type+CoreDataProperties.h"

@implementation Item_Type (CoreDataProperties)

+ (NSFetchRequest<Item_Type *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item_Type"];
}

@dynamic created_at;
@dynamic desc;
@dynamic item_type_id;
@dynamic modified_at;
@dynamic name;
@dynamic items;
@dynamic menu_item_types;

@end
