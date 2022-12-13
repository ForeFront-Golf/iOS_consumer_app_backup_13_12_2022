//
//  Course+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Course+CoreDataClass.h"

@implementation Course

+ (void)downloadCourses
{
    [self downloadCoursesWithBlock:^{}];
}

+ (void)downloadCoursesWithBlock:(void (^)(void))block
{
    NSString *url = [NSString stringWithFormat:@"%@/course?full=true", kServerURL];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         for(NSDictionary *course in results[@"Course"])
         {
             [self serializeFrom:course];
         }
         
         block();
     }];
}

@end
