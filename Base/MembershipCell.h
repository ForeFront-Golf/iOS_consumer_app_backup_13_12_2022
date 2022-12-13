//
//  MembershipCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-04-05.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MembershipCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property Membership *membership;

@end
