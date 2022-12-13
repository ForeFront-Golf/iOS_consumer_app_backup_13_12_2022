//
//  Option_Group+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Option_Group+CoreDataProperties.h"

@implementation Option_Group (CoreDataProperties)

+ (NSFetchRequest<Option_Group *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Option_Group"];
}

@dynamic created_at;
@dynamic desc;
@dynamic modified_at;
@dynamic name;
@dynamic option_group_id;
@dynamic option_type;
@dynamic valid;
@dynamic required;
@dynamic items;
@dynamic menu_items;

@end
