//
//  Club+CoreDataClass.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Menu;

NS_ASSUME_NONNULL_BEGIN

@interface Club : NSManagedObject

- (void)changeDistance;
- (void)downloadMenus;
+ (void)downloadClubsWithBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END

#import "Club+CoreDataProperties.h"
