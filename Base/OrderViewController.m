//
//  OrderViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-12.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"mapView.myLocation"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _order = [Order currentOrder];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Order_Item"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"order = %@",_order];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"menu_item.name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _resultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forTableView:_tableView andCellIdentifiers:@[@"OrderItemCell"]];
    
    _mapView.mapType = kGMSTypeHybrid;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_order.user.location.latitude.doubleValue longitude:_order.user.location.longitude.doubleValue zoom:17];
    [_mapView setCamera:camera];
    _mapView.myLocationEnabled = true;
    
    [self addObserver:self forKeyPath:@"mapView.myLocation" options:NSKeyValueObservingOptionNew context:nil];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(swiperight:)];
    [gesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [_tableView addGestureRecognizer:gesture];
    
    [self updateView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Back];
    [MainView setNavBarButton:NBT_EmptyRight];
    
    //add gradient on top
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect f = _gradientView.frame;
    f.size.width = [[UIScreen mainScreen] bounds].size.width;
    gradient.frame = f;
    gradient.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor,
                        (id)[UIColor clearColor].CGColor];
    [_gradientView.layer addSublayer:gradient];
    
    [self updateView];
}

- (void)updateView
{
    CGFloat subtotal = [_order calculateSubtotal];
    CGFloat hst = [_order calculateHST];
    if(_order.club.show_tax){
        _subtotalLabel.text = @(subtotal).toPriceString;
        _hstLabel.text = @(hst).toPriceString;
        
    } else { //!show_tax
        _subtotalLabel.text = @"";
        _subtotalTextLabel.text = @"";
        _HSTTextLabel.text = @"";
        _hstLabel.text = @"";
    }
    _totalLabel.text = @(subtotal + hst).toPriceString;
    _priceLabel.text = _totalLabel.text;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"mapView.myLocation"])
    {
        [_mapView animateToLocation:_mapView.myLocation.coordinate];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        Order_Item *orderItem = [_resultsController objectAtIndexPath:indexPath];
        [_order removeItemsObject:orderItem];
        [self updateView];
        [orderItem deleteObject];
        if(_order.items.count < 1)
        {
            [self backButtonPressed];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemViewController *controller = [MenuItemViewController new];
    controller.orderItem = [_resultsController objectAtIndexPath:indexPath];
    controller.menuItem = controller.orderItem.menu_item;
    [self.navigationController pushViewController:controller];
}

- (IBAction)orderButtonPressed
{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {//check location enable
        UIAlertAction *action1 = [UIAlertAction initWithTitle:@"Settings" forTarget:[Globals class] andSelector:@selector(openSettings)];
        UIAlertAction *action2 = [UIAlertAction initWithTitle:@"Cancel"];
        [UIAlertController showWithTitle:@"Location Permission Denied" message:@"To place an order please enable location services for this device." actions:@[action1,action2]];
    }
    else
    {
        [MainView setActivityIndicatorVisibility:true];
        
        Order_Item *orderItem = _order.items.allObjects.firstObject;
        Menu_Item *menuItem = orderItem.menu_item;
        Menu *menu = menuItem.menu;
        NSString *url = [NSString stringWithFormat:@"%@/user/%@/club/%@/menu/%@/order", kServerURL,_order.user.user_id,menu.club.club_id,menu.menu_id];
        NSMutableArray *order = @[].mutableCopy;
        for(Order_Item *item in _order.items)
        {
            NSArray *orderItemIds = [[item.order_options valueForKey:@"option_item_id"] allObjects];;
            NSString *specialRequest = item.special_request ? item.special_request : @"";
            [order addObject:@{@"menu_item_id":item.menu_item.menu_item_id,@"quantity":item.quantity, @"special_request":specialRequest,@"order_option_ids":orderItemIds}];
        }
        
        NSDictionary *parameters = @{@"lat":_order.user.location.latitude, @"lon":_order.user.location.longitude, @"order":order};
        [ServerClient post:url withParameters:parameters withBlock:^(NSDictionary *results, NSError *error)
         {
             [MainView setActivityIndicatorVisibility:false];
             if(results)
             {
                 for(NSDictionary *orderData in results[@"Order"])
                 {
                     [Order serializeFrom:orderData];
                     [_order deleteObject];
                 }
                 
                 [LocationsManager requestLocation];
                 [_containerView animateAlphaTo:0 withDuration:0.3 andDelay:0];
                 [_successView animateAlphaTo:1 withDuration:0.3 andDelay:0.3];
             }
         }];
    }
}

- (IBAction)menuButtonPressed
{
    [_order deleteObject];
    [self backButtonPressed];
}

//For swipe back the cell deletion
-(void)swiperight:(UISwipeGestureRecognizer*)recognizer
{
    [_tableView setEditing:NO animated:YES];
}

@end
