//
//  Facebook_User+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Facebook_User+CoreDataProperties.h"

@implementation Facebook_User (CoreDataProperties)

+ (NSFetchRequest<Facebook_User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Facebook_User"];
}

@dynamic created_at;
@dynamic email;
@dynamic facebook_user_id;
@dynamic modified_at;
@dynamic name;
@dynamic user_name;
@dynamic photos;
@dynamic user;

@end
