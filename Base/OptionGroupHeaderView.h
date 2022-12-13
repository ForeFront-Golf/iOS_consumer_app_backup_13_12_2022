//
//  OptionGroupHeaderView.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-24.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionGroupHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *requiredLabel;

@property Option_Group *optionGroup;

@end
