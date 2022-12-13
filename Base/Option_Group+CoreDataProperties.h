//
//  Option_Group+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Option_Group+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Option_Group (CoreDataProperties)

+ (NSFetchRequest<Option_Group *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *option_group_id;
@property (nullable, nonatomic, copy) NSString *option_type;
@property (nullable, nonatomic, copy) NSNumber *valid;
@property (nullable, nonatomic, copy) NSNumber *required;
@property (nullable, nonatomic, retain) NSSet<Option_Item *> *items;
@property (nullable, nonatomic, retain) NSSet<Menu_Item *> *menu_items;

@end

@interface Option_Group (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Option_Item *)value;
- (void)removeItemsObject:(Option_Item *)value;
- (void)addItems:(NSSet<Option_Item *> *)values;
- (void)removeItems:(NSSet<Option_Item *> *)values;

- (void)addMenu_itemsObject:(Menu_Item *)value;
- (void)removeMenu_itemsObject:(Menu_Item *)value;
- (void)addMenu_items:(NSSet<Menu_Item *> *)values;
- (void)removeMenu_items:(NSSet<Menu_Item *> *)values;

@end

NS_ASSUME_NONNULL_END
