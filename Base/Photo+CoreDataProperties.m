//
//  Photo+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-03-24.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Photo+CoreDataProperties.h"

@implementation Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
}

@dynamic created_at;
@dynamic mediaUpdatedAt;
@dynamic mediaURL;
@dynamic photo_id;
@dynamic readyForDisplay;
@dynamic sort_order;
@dynamic thumbUpdatedAt;
@dynamic thumbURL;
@dynamic club;
@dynamic clubLogo;
@dynamic facebook_user;
@dynamic menuItem;
@dynamic user;

@end
