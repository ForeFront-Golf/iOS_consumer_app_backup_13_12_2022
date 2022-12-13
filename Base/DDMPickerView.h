//
//  DDMPickerView.h
//  Union
//
//  Created by Eddy Douridas on 2017-05-27.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerView.h"

@interface DDMPickerView : ContainerView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
