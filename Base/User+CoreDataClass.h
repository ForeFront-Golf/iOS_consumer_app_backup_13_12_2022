//
//  User+CoreDataClass.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-01-17.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

+ (void)setCurrentUser:(nullable User*)user withSessionId:(nullable NSString*)sessionId;
+ (User*)currentUser;
+ (BOOL)isLoggedIn;
+ (void)logout;
- (void)loggingInCompleted;
- (NSString*)fullName;
- (void)leaveClub;

- (void)sycnProfileImage:(UIImage*)image;
- (void)syncUserLocationData:(NSDictionary*)locationData;
- (void)syncUserLocationData:(NSDictionary*)locationData withBlock:(void (^)(void))block;
- (void)syncOrdersWithBlock:(void (^)(void))block;
- (void)requestPin;
- (bool)hasOrderAtCurrentClub;

- (void)downloadMemberships;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
