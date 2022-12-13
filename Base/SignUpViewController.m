//
//  SignUpViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-03-22.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    User *user = [User currentUser];
    if(user)
    {
        [self informationDialog];
        _passwordTextField.hidden = true;
        _passwordView.hidden = true;
        _forgetButton.hidden = true;
        _firstNameTextField.text = user.first_name;
        _lastNameTextField.text = user.last_name;
        _phoneNumberTextField.text = user.phone_number;
        _profileImage = [user getBestImage];
        [_profileButton setImage:_profileImage forState:UIControlStateNormal];
        [_phoneNumberTextField textField:_phoneNumberTextField shouldChangeCharactersInRange:NSMakeRange(0, _phoneNumberTextField.text.length)  replacementString:_phoneNumberTextField.text];
        _emailTextField.text = user.email;
        NSDate *dobDate = [user.dob toDateWithFormat:kDOBFormat];
        _dobTextField.text = [dobDate toStringWithFormat:_dobTextField.dateFormat];
    }
    if (@available(iOS 11.0, *)) {
        [_scrollView setContentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentNever];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Close];
    [MainView setNavBarButton:NBT_EmptyRight];
    [MainView setTitleButtonVisibility:true];
}

- (bool)navButtonPressed:(NavButtonType)type
{
    if(type == NBT_Close)
    {
        [Globals logout];
    }
    return false;
}

- (IBAction)profileButtonPressed
{
    UIAlertAction *action1 = [UIAlertAction initWithTitle:@"Take a Photo" forTarget:[UIImagePickerController class] andSelector:@selector(createImagePickerWithSourceType:andDelegate:) withObject1:@(UIImagePickerControllerSourceTypeCamera) withObject2:self];
    UIAlertAction *action2 = [UIAlertAction initWithTitle:@"Photo Library" forTarget:[UIImagePickerController class] andSelector:@selector(createImagePickerWithSourceType:andDelegate:)withObject1:@(UIImagePickerControllerSourceTypeSavedPhotosAlbum) withObject2:self];
    UIAlertAction *action4 = [UIAlertAction initWithTitle:@"Cancel" forTarget:nil andSelector:nil withObject:self];
    [UIAlertController showWithTitle:nil message:nil actions:@[action1,action2,action4]];
}

- (void)facebookController:(FacebookViewController *)facebookController didFinishPickingPhoto:(Photo *)photo
{
    [photo fetchDataForKey:kMedia withBlock:^
     {
         _profileImage = [photo getBestImage];
         [_profileButton setImage:_profileImage forState:UIControlStateNormal];
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    _profileImage = info[UIImagePickerControllerOriginalImage];
    [_profileButton setImage:_profileImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showPasswordButtonPressed
{
    _passwordTextField.secureTextEntry = false;
}

- (IBAction)showPasswordButtonReleased
{
    _passwordTextField.secureTextEntry = true;
}

- (IBAction)validateSignUp
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
    
    _firstNameTextField.text = [_firstNameTextField.text trimWhitespace];
    _lastNameTextField.text = [_lastNameTextField.text trimWhitespace];
    [_phoneNumberTextField textField:_phoneNumberTextField shouldChangeCharactersInRange:NSMakeRange(0, _phoneNumberTextField.text.length)  replacementString:_phoneNumberTextField.text];
    _emailTextField.text = [[_emailTextField.text trimWhitespace] lowercaseString];
    _passwordTextField.text = [_passwordTextField.text trimWhitespace];
    
    NSString *errorTitle = nil;
    NSString *errorMessage = nil;
    _invalidTextField = nil;
    if(_firstNameTextField.text.length == 0)
    {
        _invalidTextField = _firstNameTextField;
        errorTitle = @"Invalid First Name";
        errorMessage = @"Please enter a valid first name";
        
    }
    else if(_lastNameTextField.text.length == 0)
    {
        _invalidTextField = _lastNameTextField;
        errorTitle = @"Invalid Last Name";
        errorMessage = @"Please enter a valid last name";
        
    }
    else if(_phoneNumberTextField.text.length != 14)
    {
        _invalidTextField = _phoneNumberTextField;
        errorTitle = @"Invalid Phone Number";
        errorMessage = @"Please enter a valid phone number";
        
    }
    else if(_emailTextField.text.length == 0 || ![_emailTextField.text isValidEmailAddress])
    {
        _invalidTextField = _emailTextField;
        errorTitle = @"Invalid Email Address";
        errorMessage = @"Please enter a valid email address";
    }
    else if(!_passwordTextField.hidden && _passwordTextField.text.length == 0)
    {
        _invalidTextField = _passwordTextField;
        errorTitle = @"Invalid Password";
        errorMessage = @"Please enter a password";
    }
    else if(_dobTextField.text.length == 0)
    {
        _invalidTextField = _dobTextField;
        errorTitle = @"Invalid Date of Birth";
        errorMessage = @"Please enter a Date of Birth";
    }
    
    if(_invalidTextField)
    {
        UIAlertAction *action1 = [UIAlertAction initWithTitle:@"OK" forTarget:_invalidTextField andSelector:@selector(becomeFirstResponder) withObject:nil];
        [UIAlertController showWithTitle:errorTitle message:errorMessage actions:@[action1]];
    }
    else
    {
        [self attemptSignUp];
    }
}

- (void)attemptSignUp
{
    [MainView setActivityIndicatorVisibility:true];
    NSString *url = [NSString stringWithFormat:@"%@/user", kServerURL];
    NSDate *dobDate = [_dobTextField.text toDateWithFormat:_dobTextField.dateFormat];
    NSString *dobString = [dobDate toStringWithFormat:kDOBFormat];
    if(!dobString)
    {
        dobString = @"";
    }
    
    NSMutableDictionary *parameters = @{@"email":_emailTextField.text, @"first_name": _firstNameTextField.text, @"last_name": _lastNameTextField.text, @"phone_number": _phoneNumberTextField.text, @"password": _passwordTextField.text,@"dob":dobString, @"signup_complete":@YES}.mutableCopy;
    
    User *user = [User currentUser];
    if(user)
    {
        parameters[@"password"] = nil;
        url = [NSString stringWithFormat:@"%@/%@", url, user.user_id];
        [ServerClient put:url withParameters:parameters withBlock:^(NSDictionary *results, NSError *error)
         {
             if(results)
             {
//                 User *user = [User serializeFrom:results];
//                 [User setCurrentUser:user withSessionId:results[@"Session"][@"session_id"]];
//                 [user sycnProfileImage:_profileImage];
                 User *updatedUser = [User serializeFrom:results];
                 [User setCurrentUser:updatedUser withSessionId:user.session_id];
                 [updatedUser sycnProfileImage:_profileImage];
                 
                 
                 [Globals loggingInCompleted];
             }
             else
             {
                 [UIAlertController showWithTitle:@"Create Account Error" message:[error localizedDescription] actions:nil];
             }
             [MainView setActivityIndicatorVisibility:false];
         }];
    }
    else
    {
        [ServerClient post:url withParameters:parameters withBlock:^(NSDictionary *results, NSError *error)
         {
             if(results)
             {
                 User *user = [User serializeFrom:results];
                 [User setCurrentUser:user withSessionId:results[@"Session"][@"session_id"]];
                 [user sycnProfileImage:_profileImage];
                 [Globals loggingInCompleted];
             }
             else
             {
                 [UIAlertController showWithTitle:@"Create Account Error" message:[error localizedDescription] actions:nil];
             }
             [MainView setActivityIndicatorVisibility:false];
         }];
    }
}

- (IBAction)privacyButtonPressed
{
    DocumentViewController *controller = [DocumentViewController new];
    controller.fileName = @"https://s3.amazonaws.com/forefront-userfiles-mobilehub-1269340312/public/legal/ForeOrderPrivacy.pdf";
    [[UINavigationController getController] pushViewController:controller];
    [PKRevealController showRightViewController];
}

- (IBAction)termsButtonPressed
{
    DocumentViewController *controller = [DocumentViewController new];
    controller.fileName = @"https://s3.amazonaws.com/forefront-userfiles-mobilehub-1269340312/public/legal/ForeOrderTerms.pdf";
    [[UINavigationController getController] pushViewController:controller];
    [PKRevealController showRightViewController];
}

- (void)informationDialog
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Almost there! Please fill in the remaining information needed to create an account."
                               message:NULL
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okayButton = [UIAlertAction
                                 actionWithTitle:@"Okay"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
    [alert addAction:okayButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
