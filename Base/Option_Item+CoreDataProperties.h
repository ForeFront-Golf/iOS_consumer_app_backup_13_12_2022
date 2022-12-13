//
//  Option_Item+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-16.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Option_Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Option_Item (CoreDataProperties)

+ (NSFetchRequest<Option_Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *available;
@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *option_item_id;
@property (nullable, nonatomic, copy) NSNumber *price;
@property (nullable, nonatomic, copy) NSNumber *valid;
@property (nonatomic) float added_tax_rate;
@property (nullable, nonatomic, retain) Option_Group *option_group;
@property (nullable, nonatomic, retain) NSSet<Order_Item *> *order_items;

@end

@interface Option_Item (CoreDataGeneratedAccessors)

- (void)addOrder_itemsObject:(Order_Item *)value;
- (void)removeOrder_itemsObject:(Order_Item *)value;
- (void)addOrder_items:(NSSet<Order_Item *> *)values;
- (void)removeOrder_items:(NSSet<Order_Item *> *)values;

@end

NS_ASSUME_NONNULL_END
