//
//  SettingsViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *membershipButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteUserButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteDatabaseButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property DDMResultsController *resultsController;

@end
