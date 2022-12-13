//
//  User+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-04-06.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic banned;
@dynamic created_at;
@dynamic current;
@dynamic dob;
@dynamic email;
@dynamic first_name;
@dynamic knownClubStatus;
@dynamic last_name;
@dynamic modified_at;
@dynamic phone_number;
@dynamic phone_valid;
@dynamic profile_photo_url;
@dynamic rating;
@dynamic session_id;
@dynamic signup_complete;
@dynamic user_id;
@dynamic valid;
@dynamic membership_complete;
@dynamic club;
@dynamic facebook_user;
@dynamic location;
@dynamic orders;
@dynamic photo;
@dynamic memberships;

@end
