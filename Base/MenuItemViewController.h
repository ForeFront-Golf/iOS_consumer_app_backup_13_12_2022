//
//  MenuItemViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-06.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemViewController : UIViewController <NSFetchedResultsControllerDelegate, TableViewResultsDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *textVIew;
@property (weak, nonatomic) IBOutlet UILabel *textViewDefaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *quantityView;

@property Menu_Item *menuItem;
@property Order_Item *orderItem;
@property Order_Item *orderItemCopy;
@property TableViewResultsController *resultsController;
@property DDMResultsController *orderItemResultsController;
@property DDMResultsController *menuItemResultsController;

@end

