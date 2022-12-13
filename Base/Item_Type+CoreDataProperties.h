//
//  Item_Type+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Item_Type+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item_Type (CoreDataProperties)

+ (NSFetchRequest<Item_Type *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSNumber *item_type_id;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Menu_Item *> *items;
@property (nullable, nonatomic, retain) NSSet<Menu_Item_Type *> *menu_item_types;

@end

@interface Item_Type (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Menu_Item *)value;
- (void)removeItemsObject:(Menu_Item *)value;
- (void)addItems:(NSSet<Menu_Item *> *)values;
- (void)removeItems:(NSSet<Menu_Item *> *)values;

- (void)addMenu_item_typesObject:(Menu_Item_Type *)value;
- (void)removeMenu_item_typesObject:(Menu_Item_Type *)value;
- (void)addMenu_item_types:(NSSet<Menu_Item_Type *> *)values;
- (void)removeMenu_item_types:(NSSet<Menu_Item_Type *> *)values;

@end

NS_ASSUME_NONNULL_END
