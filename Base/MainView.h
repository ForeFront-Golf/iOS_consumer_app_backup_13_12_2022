//
//  MainView.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIView

+ (MainView*)view;
+ (void)resignFirstResponder;
+ (void)setTitleLabel:(NSString*)text;
+ (void)setProfileName:(NSString*)name andImage:(UIImage*)image;
+ (void)setTitleButtonVisibility:(BOOL)visibility;
+ (void)setPickerAtRow:(NSInteger)row forObject:(id)object withTitle:(NSString*)title;
+ (void)setActivityIndicatorVisibility:(BOOL)visibility;
+ (void)setActivityIndicatorVisibilityGreyBackground:(BOOL)visibility;
+ (void)setNavBarVisibility:(BOOL)visibility;
+ (void)setNavBarColor:(UIColor*)color;
+ (void)setNavBarButton:(NavButtonType)type;

@property (weak, nonatomic) IBOutlet UIView *rootTransitionView;
@property (weak, nonatomic) IBOutlet UITextField *rootTextField;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *activityIndicatorLabel;

@property (weak, nonatomic) IBOutlet UIToolbar *navBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarViewTopConstraint;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSMutableArray *navButtonsConstraints;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSMutableArray *navButtons;

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *pickerLabel;

@property UINavigationController *navigationController;
@property UITapGestureRecognizer *backgroundTapped;

@end
