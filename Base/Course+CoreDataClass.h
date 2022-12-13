//
//  Course+CoreDataClass.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSManagedObject

+ (void)downloadCourses;
+ (void)downloadCoursesWithBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END

#import "Course+CoreDataProperties.h"
