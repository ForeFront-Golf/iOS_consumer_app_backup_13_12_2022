//
//  SettingsViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _deleteUserButton.hidden = !kIsSimulator;
    _deleteDatabaseButton.hidden = !kIsSimulator;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _resultsController = [DDMResultsController controllerForDelegate:self forObject:[User currentUser]];
    
    [self updateView];
    
    [[User currentUser].photo fetchDataForKey:kMedia withBlock:^{}];
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateView];
}

- (void)updateView
{
    User *user = [User currentUser];
    _nameLabel.text = [user fullName];
    UIImage *profileImage = [user getBestImage];
    [_profileButton setImage:profileImage forState:UIControlStateNormal];

    _membershipButton.hidden = !user.phone_valid.boolValue;
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"v%@",version];
}

- (IBAction)profileButtonPressed
{
    UIAlertAction *action1 = [UIAlertAction initWithTitle:@"Take a Photo" forTarget:[UIImagePickerController class] andSelector:@selector(createImagePickerWithSourceType:andDelegate:) withObject1:@(UIImagePickerControllerSourceTypeCamera) withObject2:self];
    UIAlertAction *action2 = [UIAlertAction initWithTitle:@"Photo Library" forTarget:[UIImagePickerController class] andSelector:@selector(createImagePickerWithSourceType:andDelegate:)withObject1:@(UIImagePickerControllerSourceTypeSavedPhotosAlbum) withObject2:self];
//    UIAlertAction *action3 = [UIAlertAction initWithTitle:@"Facebook Library" forTarget:[FacebookViewController class] andSelector:@selector(createFacebookViewControllerWithDelegate:) withObject:self];
    UIAlertAction *action4 = [UIAlertAction initWithTitle:@"Cancel" forTarget:nil andSelector:nil withObject:self];
//    if([Facebook_User facebookToken])
//    {
//        [UIAlertController showWithTitle:nil message:nil actions:@[action1,action2,action3,action4]];
//    }
//    else
//    {
        [UIAlertController showWithTitle:nil message:nil actions:@[action1,action2,action4]];
//    }
}

- (void)facebookController:(FacebookViewController *)facebookController didFinishPickingPhoto:(Photo *)photo
{
    [photo fetchDataForKey:kMedia withBlock:^
     {
         [[User currentUser] sycnProfileImage:[photo getBestImage]];
         [self updateView];
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    [[User currentUser] sycnProfileImage:info[UIImagePickerControllerOriginalImage]];
    [self updateView];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editButtonPressed
{
    [self profileButtonPressed];
}

- (IBAction)membershipButtonPressed
{
    [[UINavigationController getController] pushViewController:[MembershipViewController new]];
    [PKRevealController showRightViewController];
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

- (IBAction)deleteDatabaseButtonPressed
{
    [CoreData deleteAllObjects];
    [Globals logout];
    [PKRevealController showRightViewController];
}

- (IBAction)deleteUser
{
    NSError * error = nil;
    NSURLResponse * response = nil;
    User *user = [User currentUser];
    NSString *url = [NSString stringWithFormat:@"%@/delete_user/%@", kServerURL, user.user_id];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(!error)
    {
        [Globals logout];
        [user deleteObject];
        [PKRevealController showRightViewController];
    }
}

- (IBAction)logoutButtonPressed
{
    [Globals logout];
}

@end
