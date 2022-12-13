//
//  Order_Item+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-16.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Order_Item+CoreDataProperties.h"

@implementation Order_Item (CoreDataProperties)

+ (NSFetchRequest<Order_Item *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Order_Item"];
}

@dynamic created_at;
@dynamic modified_at;
@dynamic order_item_id;
@dynamic price;
@dynamic quantity;
@dynamic special_request;
@dynamic tax_price;
@dynamic menu_item;
@dynamic order;
@dynamic order_options;

@end
