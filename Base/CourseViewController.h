//
//  CourseViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseViewController : UIViewController <CollectionViewResultsDataSource, NSFetchedResultsControllerDelegate, TableViewResultsDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UITextView *contactTextView;
@property (weak, nonatomic) IBOutlet UIView *selectedMenuView;
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cartViewConstraint;

@property Club *club;
@property Menu *currentMenu;
@property Order *order;
@property CollectionViewResultsController *menuResultsController;
@property CollectionViewResultsController *resultsController;
@property TableViewResultsController *tableViewResultsController;
@property DDMResultsController *clubResultsController;

@end
