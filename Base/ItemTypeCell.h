//
//  ItemTypeCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-06.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property Item_Type *itemType;

@end
