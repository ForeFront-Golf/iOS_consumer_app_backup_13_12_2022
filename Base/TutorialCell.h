//
//  TutorialCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-02-08.
//  Copyright © 2016 Matt Michels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
