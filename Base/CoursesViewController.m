//
//  CoursesViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-03-27.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "CoursesViewController.h"

@interface CoursesViewController ()

@end

@implementation CoursesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Club"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"valid = true"];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES selector:nil]];
    _resultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forTableView:_tableView andCellIdentifiers:@[@"CourseCell"]];
    if (@available(iOS 11.0, *)) {
        [_tableView setContentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentNever];
    }
    
    _userResultsController = [DDMResultsController controllerForDelegate:self forObject:[User currentUser]];

    [Course downloadCourses];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Settings];
    [MainView setNavBarButton:NBT_Reload];
    [MainView setTitleButtonVisibility:true];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self showNotLocationEnableView];
        [self showNotLocationEnableViewDetail];
    }
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertAction *action1 = [UIAlertAction initWithTitle:@"Settings" forTarget:[Globals class] andSelector:@selector(openSettings)];
        UIAlertAction *action2 = [UIAlertAction
         actionWithTitle:@"Cancel"
         style:UIAlertActionStyleCancel
         handler:^(UIAlertAction * action) {
             [self showNotLocationEnableViewDetail];
             [self showNotLocationEnableView];
         }];
        [UIAlertController showWithTitle:@"Location Permission Denied" message:@"To track your location, please go to Settings and enable Location Service for this app." actions:@[action1,action2]];
    } else {
        [self hideNotLocationEnableView];
        [LocationsManager requestLocation];
    }
    
}

- (bool)navButtonPressed:(NavButtonType)type
{
    if(type == NBT_Reload)
    {
        [Course downloadCourses];
        [LocationsManager requestLocation];
    }
    return false;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Club *club = [_resultsController objectAtIndexPath:indexPath];
    if(kIsSimulator)
    {
        CourseViewController *controller = [CourseViewController new];
        controller.club = club;
        [self.navigationController pushViewController:controller];
    }
    
    User *user = [User currentUser];
    if(!user.club && club.club_id.integerValue == 1)
    {
        CourseViewController *controller = [CourseViewController new];
        controller.club = club;
        [self.navigationController pushViewController:controller];
    }
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self hideNotLocationEnableViewDetail];
    [MainView setActivityIndicatorVisibility:true];
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self showNotLocationEnableViewDetail];
    } else {
        [self hideNotLocationEnableView];
    }
    [MainView setActivityIndicatorVisibility:false];
}

- (void)showNotLocationEnableView
{
    [MainView setNavBarVisibility:NO];
    _locationNotEnableView.hidden = false;
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.locationNotEnableView.alpha = 0.9;
    }];
    
}

- (void)hideNotLocationEnableView
{
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Settings];
    [MainView setNavBarButton:NBT_Reload];
    [MainView setTitleButtonVisibility:true];
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.locationNotEnableView.alpha = 0.0;
    }];
    _locationNotEnableView.hidden = true;
}

- (void)showNotLocationEnableViewDetail
{
    _locationNotEnableView.hidden = false;
    [UIView animateWithDuration:1.5 animations:^(void) {
        self.oopsLabel.alpha = 1.0;
        self.noLocationInfo.alpha = 1.0;
        self.refreshButton.alpha = 1.0;
    }];
}

- (void)hideNotLocationEnableViewDetail
{
    [UIView animateWithDuration:1.5 animations:^(void) {
        self.oopsLabel.alpha = 0.0;
        self.noLocationInfo.alpha = 0.0;
        self.refreshButton.alpha = 0.0;
    }];
    _locationNotEnableView.hidden = true;
}

@end
