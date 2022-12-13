//
//  MenuTypeHeaderView.h
//  GolfEmployee
//
//  Created by Eddy Douridas on 2017-05-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTypeHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property Menu_Item_Type *menuItemType;

@end
