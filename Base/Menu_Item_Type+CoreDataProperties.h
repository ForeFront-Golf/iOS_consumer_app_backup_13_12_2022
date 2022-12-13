//
//  Menu_Item_Type+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Menu_Item_Type+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Menu_Item_Type (CoreDataProperties)

+ (NSFetchRequest<Menu_Item_Type *> *)fetchRequest;

@property (nullable, nonatomic, retain) Item_Type *item_type;
@property (nullable, nonatomic, retain) Menu_Item *menu_item;

@end

NS_ASSUME_NONNULL_END
