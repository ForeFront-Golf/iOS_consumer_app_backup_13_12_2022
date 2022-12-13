//
//  Menu+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-10-02.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//
//

#import "Menu+CoreDataProperties.h"

@implementation Menu (CoreDataProperties)

+ (NSFetchRequest<Menu *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Menu"];
}

@dynamic created_at;
@dynamic desc;
@dynamic menu_id;
@dynamic modified_at;
@dynamic name;
@dynamic valid;
@dynamic club;
@dynamic menu_items;
@dynamic orders;

@end
