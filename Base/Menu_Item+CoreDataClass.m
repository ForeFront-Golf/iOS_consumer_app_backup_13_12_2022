//
//  Menu_Item+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Menu_Item+CoreDataClass.h"

@implementation Menu_Item

- (void)setMenu_item_id:(NSNumber *)menu_item_id
{
    [self willChangeValueForKey:@"menu_item_id"];
    [self setPrimitiveValue:menu_item_id forKey:@"menu_item_id"];
    [self didChangeValueForKey:@"menu_item_id"];
    
    if(!self.photo)
    {
        self.photo = [Photo createObject];
        self.photo.photo_id = [NSString stringWithFormat:@"item_%@",menu_item_id];
    }
}

- (void)setItem_types:(NSSet<Item_Type *> *)item_types
{
    [self willChangeValueForKey:@"item_types"];
    [self setPrimitiveValue:item_types forKey:@"item_types"];
    [self didChangeValueForKey:@"item_types"];
    
    for(Item_Type *itemType in item_types)
    {
        Menu_Item_Type *menuItemType = [Menu_Item_Type fetchObjectForPredicate:[NSPredicate predicateWithFormat:@"menu_item = %@ && item_type = %@",self, itemType]];
        if(!menuItemType)
        {
            menuItemType = [Menu_Item_Type createObject];
            menuItemType.menu_item = self;
            menuItemType.item_type = itemType;
        }
    }
}

- (void)prepareForDeletion
{
    [super prepareForDeletion];
    
    [[NSFileManager defaultManager] removeItemAtPath:[self.photo getPathForKey:kThumbnail] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self.photo getPathForKey:kMedia] error:nil];
}

@end
