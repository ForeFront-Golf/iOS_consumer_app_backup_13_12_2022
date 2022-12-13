//
//  MembershipViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-04-04.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//

#import "MembershipViewController.h"

@interface MembershipViewController ()

@end

@implementation MembershipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _user = [User currentUser];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Membership"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"valid = true && user = %@",_user];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"club.name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _resultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forTableView:_tableView andCellIdentifiers:@[@"MembershipCell"]];
    [_user downloadMemberships];
    [Club downloadClubsWithBlock:^
     {
         _clubs = [Club fetchObjectsForPredicate:[NSPredicate predicateWithFormat:@"valid = true && private = true"] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
     }];
    
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(swiperight:)];
    [gesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [_tableView addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:_user.membership_complete ? NBT_Back : NBT_EmptyLeft];
    [MainView setNavBarButton:_user.membership_complete ? NBT_EmptyRight : NBT_Next];
    [MainView setTitleButtonVisibility:false];
}

- (bool)navButtonPressed:(NavButtonType)type
{
    if(type == NBT_Next)
    {
        _user.membership_complete = true;
        [Globals loggingInCompleted];
    }
    return false;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _clubs.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Club *club = _clubs[row];
    return club.name;
}

- (void)pickerView:(DDMPickerView*)picker completedForTextFIeld:(DDMTextField*)textField
{
    NSInteger row = [picker.picker selectedRowInComponent:0];
    _selectedClub = _clubs[row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self attemptToDeleteMembership:indexPath];
    }
}

- (IBAction)addMembershipButtonPressed
{
    if(!_selectedClub)
    {
        [UIAlertController showWithTitle:@"Please select a Club" message:nil actions:nil];
    }
    else if(!_memberIDTextField.text.length)
    {
        [UIAlertController showWithTitle:@"Please enter your Member ID." message:nil actions:nil];
    }
    else
    {
        [MainView setActivityIndicatorVisibility:YES];
        NSString *url = [NSString stringWithFormat:@"%@/user/%@/membership", kServerURL, _user.user_id];
        NSDictionary *parameters = @{@"club_id":_selectedClub.club_id,@"member_code":_memberIDTextField.text};
        [ServerClient post:url withParameters:parameters withBlock:^(NSDictionary *results, NSError *error)
         {
             if(results)
             {
                 if(results[@"Membership"][@"valid"] == [NSNumber numberWithBool:YES]){
                     [Membership serializeFrom:results[@"Membership"]];
                     [LocationsManager requestLocation];
                 } else {
                     [UIAlertController showWithTitle:@"Membership not valid" message:nil actions:nil];
                 }
                 
             }
             else
             {
                 [UIAlertController showWithTitle:@"Membership not found" message:nil actions:nil];
             }
             [MainView setActivityIndicatorVisibility:false];
         }];
    }
}

- (void)attemptToDeleteMembership:(NSIndexPath *)indexPath
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Remove Membership"
                               message:@"Are you sure you want to remove the membership?"
                               preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* removeButton = [UIAlertAction
                                 actionWithTitle:@"REMOVE"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     Membership *membership = [_resultsController objectAtIndexPath:indexPath];
                                     NSString *url = [NSString stringWithFormat:@"%@/user/%@/membership/%@", kServerURL, _user.user_id, membership.membership_id];
                                     [ServerClient put:url withParameters:@{@"valid":[NSNumber numberWithBool:NO]} withBlock:^(NSDictionary *results, NSError *error)
                                      {
                                          if(results)
                                          {
                                              [membership serializeFrom:results[@"Membership"]];
                                              [LocationsManager requestLocation];
                                          }
                                      }];
                                 }];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"CANCEL"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {}];
    [alert addAction:removeButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}

//For swipe back the cell deletion
-(void)swiperight:(UISwipeGestureRecognizer*)recognizer
{
    [_tableView setEditing:NO animated:YES];
}

@end
