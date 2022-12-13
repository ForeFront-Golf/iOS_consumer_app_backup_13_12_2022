//
//  OptionItemCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-10.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property Option_Item *optionItem;
@property Order_Item *orderItem;

@end
