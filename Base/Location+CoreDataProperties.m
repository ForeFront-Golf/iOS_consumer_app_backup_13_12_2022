//
//  Location+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-08-22.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Location+CoreDataProperties.h"

@implementation Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Location"];
}

@dynamic created_at;
@dynamic latitude;
@dynamic location_id;
@dynamic longitude;
@dynamic v_accuracy;
@dynamic h_accuracy;
@dynamic user;

@end
