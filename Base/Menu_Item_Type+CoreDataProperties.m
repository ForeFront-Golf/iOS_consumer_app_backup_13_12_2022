//
//  Menu_Item_Type+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Menu_Item_Type+CoreDataProperties.h"

@implementation Menu_Item_Type (CoreDataProperties)

+ (NSFetchRequest<Menu_Item_Type *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Menu_Item_Type"];
}

@dynamic item_type;
@dynamic menu_item;

@end
