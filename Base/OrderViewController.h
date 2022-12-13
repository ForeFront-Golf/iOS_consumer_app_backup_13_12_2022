//
//  OrderViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-12.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController <GMSMapViewDelegate, TableViewResultsDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *hstLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *HSTTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalTextLabel;

@property TableViewResultsController *resultsController;
@property Order *order;

@end
