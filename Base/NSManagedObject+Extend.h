//
//  NSManagedObject+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2015-01-14.
//  Copyright (c) 2015 DDMAppDesign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class User;

@interface NSManagedObject (Extend)

+ (instancetype)createObject;
+ (instancetype)getObjectWithId:(id)objectId;                           //Find or create object, also sets objectId value
+ (instancetype)getObjectWithDictionary:(NSDictionary*)dictionary;      //Find or create object, also sets dictionary values

+ (NSString*)objectIdKey;
- (NSString*)objectIdKey;
- (id)objectId;
- (BOOL)hasKey:(NSString*)key;
- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)object forKey:(NSString*)key;
- (NSMutableDictionary*)toDictionary;
- (void)makeDirty;

+ (NSInteger)fetchObjectCountForPredicate:(NSPredicate*)predicate;
+ (instancetype)fetchObjectWithId:(id)objectId;                         //Find object with matching objectId, otherwise nil
+ (instancetype)fetchObjectForPredicate:(NSPredicate*)predicate;
+ (NSArray*)fetchObjectsForPredicate:(NSPredicate*)predicate;
+ (NSArray*)fetchObjectsForPredicate:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors;
+ (NSFetchRequest*)createFetchRequestForPredicate:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors;

- (void)deleteObject;

+ (NSString*)getURLForObjectId:(NSNumber*)objectId;
+ (NSString*)postURLForObjectId:(NSNumber*)objectId;
+ (NSDictionary*)processResponse:(NSDictionary *)response;
+ (bool)processError:(NSInteger)statusCode;

+ (NSDate*)getLastUpdatedAt;
+ (id)serializeFrom:(NSDictionary*)data;
- (void)serializeFrom:(NSDictionary*)data;

- (NSString*)getNameForKey:(NSString*)key;
- (NSString*)getPathForKey:(NSString*)key;
- (NSURL*)getURLForKey:(NSString*)key;
- (NSString*)getAWSPathForKey:(NSString*)key;
- (BOOL)hasDataForKey:(NSString*)key;

- (void)fetchDataForKey:(NSString *)key;            //get image from facebook
- (void)fetchDataForKey:(NSString *)key withBlock:(void (^)(void))block;
- (void)saveData:(NSData*)data forKey:(NSString*)fileKey;

- (UIImage*)getImageForKey:(NSString*)key;
- (UIImage*)getBestImage;

@end
