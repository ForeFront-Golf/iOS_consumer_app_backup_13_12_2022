//
//  Order+CoreDataProperties.m
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-17.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Order+CoreDataProperties.h"

@implementation Order (CoreDataProperties)

+ (NSFetchRequest<Order *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Order"];
}

@dynamic created_at;
@dynamic delivery;
@dynamic fulfilled;
@dynamic modified_at;
@dynamic order_id;
@dynamic order_num;
@dynamic price;
@dynamic price_total;
@dynamic price_total_with_tax;
@dynamic quantity;
@dynamic tax_amount;
@dynamic club_id;
@dynamic club;
@dynamic items;
@dynamic menu;
@dynamic user;

@end
