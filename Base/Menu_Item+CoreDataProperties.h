//
//  Menu_Item+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-16.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Menu_Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Menu_Item (CoreDataProperties)

+ (NSFetchRequest<Menu_Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *available;
@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSNumber *menu_item_id;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *photo_url;
@property (nullable, nonatomic, copy) NSString *photo_url_thumb;
@property (nullable, nonatomic, copy) NSNumber *price;
@property (nullable, nonatomic, copy) NSNumber *valid;
@property (nonatomic) float added_tax_rate;
@property (nullable, nonatomic, retain) NSSet<Item_Type *> *item_types;
@property (nullable, nonatomic, retain) Menu *menu;
@property (nullable, nonatomic, retain) NSSet<Menu_Item_Type *> *menu_item_types;
@property (nullable, nonatomic, retain) NSSet<Option_Group *> *option_groups;
@property (nullable, nonatomic, retain) NSSet<Order_Item *> *order_items;
@property (nullable, nonatomic, retain) Photo *photo;

@end

@interface Menu_Item (CoreDataGeneratedAccessors)

- (void)addItem_typesObject:(Item_Type *)value;
- (void)removeItem_typesObject:(Item_Type *)value;
- (void)addItem_types:(NSSet<Item_Type *> *)values;
- (void)removeItem_types:(NSSet<Item_Type *> *)values;

- (void)addMenu_item_typesObject:(Menu_Item_Type *)value;
- (void)removeMenu_item_typesObject:(Menu_Item_Type *)value;
- (void)addMenu_item_types:(NSSet<Menu_Item_Type *> *)values;
- (void)removeMenu_item_types:(NSSet<Menu_Item_Type *> *)values;

- (void)addOption_groupsObject:(Option_Group *)value;
- (void)removeOption_groupsObject:(Option_Group *)value;
- (void)addOption_groups:(NSSet<Option_Group *> *)values;
- (void)removeOption_groups:(NSSet<Option_Group *> *)values;

- (void)addOrder_itemsObject:(Order_Item *)value;
- (void)removeOrder_itemsObject:(Order_Item *)value;
- (void)addOrder_items:(NSSet<Order_Item *> *)values;
- (void)removeOrder_items:(NSSet<Order_Item *> *)values;

@end

NS_ASSUME_NONNULL_END
