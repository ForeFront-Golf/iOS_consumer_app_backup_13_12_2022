//
//  DDMResultsController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DDMResultsController : NSFetchedResultsController

+ (DDMResultsController*)controllerForDelegate:(id< NSFetchedResultsControllerDelegate >)delegate entityName:(NSString*)name predicate:(NSPredicate*)predicate sortDescriptors:(NSArray*)sortDescriptors;
+ (DDMResultsController*)controllerForDelegate:(id< NSFetchedResultsControllerDelegate >)delegate entityName:(NSString*)name predicate:(NSPredicate*)predicate;
+ (DDMResultsController*)controllerForDelegate:(id<NSFetchedResultsControllerDelegate>)delegate forObject:(NSManagedObject*)object;

@end
