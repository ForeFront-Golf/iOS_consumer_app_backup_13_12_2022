//
//  CoursesViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-03-27.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoursesViewController : UIViewController <NSFetchedResultsControllerDelegate, TableViewResultsDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *locationNotEnableView;
@property (weak, nonatomic) IBOutlet UILabel *oopsLabel;
@property (weak, nonatomic) IBOutlet UITextView *noLocationInfo;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property TableViewResultsController *resultsController;
@property DDMResultsController *userResultsController;

@end
