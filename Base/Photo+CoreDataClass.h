//
//  Photo+CoreDataClass.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-01-26.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Facebook_User, User;

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSManagedObject

- (NSString*)getAmazonURLForKey:(NSString*)key;
- (void)deleteFromS3ForKey:(NSString *)key;
- (void)uploadToS3ForKey:(NSString*)key;
- (void)uploadToS3ForKey:(NSString*)key withBlock:(void (^)(BOOL succeeded))block;
- (void)downloadPhotoWithBlock:(void (^)(BOOL succeeded))block;
- (CGSize)getSizeForKey:(NSString*)key;
    
@end

NS_ASSUME_NONNULL_END

#import "Photo+CoreDataProperties.h"
