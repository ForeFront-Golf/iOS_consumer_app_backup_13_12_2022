//
//  LoginViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-03-22.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet DDMTextField *emailTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *passwordTextField;

@end
