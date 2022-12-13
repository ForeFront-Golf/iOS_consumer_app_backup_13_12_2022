//
//  CoreData.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface CoreData : NSObject <NSFetchedResultsControllerDelegate>

+ (CoreData*)coreData;
+ (NSManagedObjectContext*)context;
+ (void)save;
+ (void)deleteAllObjects;
+ (void)deleteObjectsForClass:(Class)objectClass;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext; 
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL*)applicationDocumentsDirectory;

@end
