//
//  Option_Group+CoreDataClass.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-10.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Menu_Item, Option_Item;

NS_ASSUME_NONNULL_BEGIN

@interface Option_Group : NSManagedObject

- (bool)isSingleOption;

@end

NS_ASSUME_NONNULL_END

#import "Option_Group+CoreDataProperties.h"
