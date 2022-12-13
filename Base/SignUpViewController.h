//
//  SignUpViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-03-22.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet DDMTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *dobTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *emailTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@property UITextField *invalidTextField;
@property UIImage *profileImage;

@end
