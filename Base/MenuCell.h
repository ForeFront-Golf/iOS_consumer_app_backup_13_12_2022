//
//  MenuCell.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-05.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UICollectionViewCell <TableViewResultsDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property Menu *menu;
@property TableViewResultsController *resultsController;

@end
