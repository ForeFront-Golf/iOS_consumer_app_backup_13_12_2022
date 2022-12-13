//
//  DDMResultsController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "DDMResultsController.h"

@implementation DDMResultsController

+ (DDMResultsController*)controllerForDelegate:(id<NSFetchedResultsControllerDelegate>)delegate entityName:(NSString *)name predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    DDMResultsController *resultsController = [[DDMResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreData context] sectionNameKeyPath:nil cacheName:nil];
    resultsController.delegate = delegate;
    [resultsController performFetch:&error];
    
    if(error)
    {
        return nil;
    }
    
    return resultsController;
}

+ (DDMResultsController*)controllerForDelegate:(id<NSFetchedResultsControllerDelegate>)delegate entityName:(NSString *)name predicate:(NSPredicate *)predicate
{
    return [self controllerForDelegate:delegate entityName:name predicate:predicate sortDescriptors:@[]];
}

+ (DDMResultsController*)controllerForDelegate:(id<NSFetchedResultsControllerDelegate>)delegate forObject:(NSManagedObject*)object
{
    NSString *className = NSStringFromClass([object class]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self = %@", object];
    return [self controllerForDelegate:delegate entityName:className predicate:predicate sortDescriptors:@[]];
}

@end
