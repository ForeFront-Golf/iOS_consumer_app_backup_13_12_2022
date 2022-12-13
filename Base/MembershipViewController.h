//
//  MembershipViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-04-04.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MembershipViewController : UIViewController <TableViewResultsDataSource>

@property (weak, nonatomic) IBOutlet DDMTextField *clubTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *memberIDTextField;
@property (weak, nonatomic) IBOutlet DDMTextField *accessNumberTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property User *user;
@property NSArray *clubs;
@property Club *selectedClub;
@property TableViewResultsController *resultsController;

@end
