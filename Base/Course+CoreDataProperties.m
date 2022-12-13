//
//  Course+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-03-24.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Course+CoreDataProperties.h"

@implementation Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Course"];
}

@dynamic course_id;
@dynamic created_at;
@dynamic desc;
@dynamic modified_at;
@dynamic name;
@dynamic photo_url;
@dynamic photo_url_thumb;
@dynamic club;

@end
