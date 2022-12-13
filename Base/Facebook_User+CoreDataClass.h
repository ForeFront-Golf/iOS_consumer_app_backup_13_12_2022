//
//  Facebook_User+CoreDataClass.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-01-18.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;
@class Photo;

NS_ASSUME_NONNULL_BEGIN

@interface Facebook_User : NSManagedObject

+ (NSString*)facebookToken;

@end

NS_ASSUME_NONNULL_END

#import "Facebook_User+CoreDataProperties.h"
