//
//  Menu+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-10-02.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//
//

#import "Menu+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Menu (CoreDataProperties)

+ (NSFetchRequest<Menu *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSNumber *menu_id;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *valid;
@property (nullable, nonatomic, retain) Club *club;
@property (nullable, nonatomic, retain) NSSet<Menu_Item *> *menu_items;
@property (nullable, nonatomic, retain) NSSet<Order *> *orders;

@end

@interface Menu (CoreDataGeneratedAccessors)

- (void)addMenu_itemsObject:(Menu_Item *)value;
- (void)removeMenu_itemsObject:(Menu_Item *)value;
- (void)addMenu_items:(NSSet<Menu_Item *> *)values;
- (void)removeMenu_items:(NSSet<Menu_Item *> *)values;

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet<Order *> *)values;
- (void)removeOrders:(NSSet<Order *> *)values;

@end

NS_ASSUME_NONNULL_END
