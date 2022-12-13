//
//  Order_Item+CoreDataClass.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-11.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Menu_Item, Order, Order_Option_Group;

NS_ASSUME_NONNULL_BEGIN

@interface Order_Item : NSManagedObject

- (bool)hasOption:(Option_Item*)optionItem;
- (void)clearOptionsForGroup:(Option_Group*)optionGroup;
- (void)copyOrderItem:(Order_Item*)orderItem;
- (CGFloat)calculateTotal;

@end

NS_ASSUME_NONNULL_END

#import "Order_Item+CoreDataProperties.h"
