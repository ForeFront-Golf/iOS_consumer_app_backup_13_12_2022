//
//  Order+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-17.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Order+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Order (CoreDataProperties)

+ (NSFetchRequest<Order *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSNumber *delivery;
@property (nullable, nonatomic, copy) NSNumber *fulfilled;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSNumber *order_id;
@property (nullable, nonatomic, copy) NSNumber *order_num;
@property (nullable, nonatomic, copy) NSNumber *price;
@property (nullable, nonatomic, copy) NSNumber *price_total;
@property (nullable, nonatomic, copy) NSNumber *price_total_with_tax;
@property (nullable, nonatomic, copy) NSNumber *quantity;
@property (nullable, nonatomic, copy) NSNumber *tax_amount;
@property (nonatomic) int32_t club_id;
@property (nullable, nonatomic, retain) Club *club;
@property (nullable, nonatomic, retain) NSSet<Order_Item *> *items;
@property (nullable, nonatomic, retain) Menu *menu;
@property (nullable, nonatomic, retain) User *user;

@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Order_Item *)value;
- (void)removeItemsObject:(Order_Item *)value;
- (void)addItems:(NSSet<Order_Item *> *)values;
- (void)removeItems:(NSSet<Order_Item *> *)values;

@end

NS_ASSUME_NONNULL_END
