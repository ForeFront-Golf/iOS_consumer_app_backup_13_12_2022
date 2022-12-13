//
//  Membership+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-02.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Membership+CoreDataProperties.h"

@implementation Membership (CoreDataProperties)

+ (NSFetchRequest<Membership *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Membership"];
}

@dynamic created_at;
@dynamic email;
@dynamic first_name;
@dynamic last_name;
@dynamic member_code;
@dynamic membership_id;
@dynamic modified_at;
@dynamic notes;
@dynamic phone_number;
@dynamic valid;
@dynamic club;
@dynamic user;

@end
