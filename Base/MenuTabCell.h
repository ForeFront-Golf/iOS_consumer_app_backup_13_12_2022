//
//  MenuTabCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-05-15.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTabCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property Menu *menu;

@end
