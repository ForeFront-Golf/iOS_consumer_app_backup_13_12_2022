//
//  OrderItemCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-12.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property Order_Item *orderItem;

@end
