//
//  CourseCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-03-27.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property Club *club;

@end
