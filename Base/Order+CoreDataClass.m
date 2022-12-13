//
//  Order+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-11.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Order+CoreDataClass.h"
#import "Order_Item+CoreDataClass.h"

#import "User+CoreDataClass.h"

@implementation Order

+ (Order*)currentOrder
{
    Order *order = [Order getObjectWithId:@(kCurrentObjectId)];
    order.user = [User currentUser];
    order.club = [[User currentUser] club];
    order.club_id = order.club.club_id.intValue;
    return order;
}

- (void)setClub_id:(int32_t)club_id
{
    if(club_id != self.club_id)
    {
        //delete order when move to new club
        for(Order_Item *orderItem in self.items)
        {
            [orderItem deleteObject];
        }
    }
    
    [self willChangeValueForKey:@"club_id"];
    [self setPrimitiveValue:[NSNumber numberWithInt:club_id] forKey:@"club_id"];
    [self didChangeValueForKey:@"club_id"];
}


- (void)clearOrder
{
    self.order_id = @(kCurrentObjectId);
    self.price = nil;
    [self.items performSelector:@selector(deleteObject)];
}

- (CGFloat)calculateSubtotal
{
    CGFloat subtotal = 0;
    for(Order_Item *orderItem in self.items)
    {
        subtotal += orderItem.price.floatValue;
    }
    return subtotal;
}

- (CGFloat)calculateHST
{
    CGFloat subtotal = [self calculateSubtotal];
    CGFloat additionHstSubtotal = 0;
    //Get option additional tax
    for(Order_Item *orderItem in self.items)
    {
        additionHstSubtotal += orderItem.tax_price * orderItem.quantity.floatValue;
    }
    CGFloat hst = (subtotal * self.club.tax_rate * 0.01f) + additionHstSubtotal;
    return ceilf(hst*100)/100;//round up
}

- (CGFloat)calculateTotal
{
    CGFloat subtotal = [self calculateSubtotal];
    CGFloat hst = [self calculateHST];
    return subtotal + hst;
}

@end
