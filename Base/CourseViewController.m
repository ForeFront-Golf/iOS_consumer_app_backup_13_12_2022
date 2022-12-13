//
//  CourseViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "CourseViewController.h"
#import "MenuCell.h"

static const CGFloat kMenuTabCellWidth = 120;

@interface CourseViewController ()

@end

@implementation CourseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nameLabel.text = _club.name;
    _menuCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [_club.photo fetchDataForKey:kMedia];
    [_club.logoPhoto fetchDataForKey:kMedia];
    [_club downloadMenus];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Menu"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"valid = true && club = %@",_club];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _resultsController = [[CollectionViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forCollectionView:_collectionView andCellIdentifiers:@[@"MenuCell"]];
    
    _menuResultsController = [[CollectionViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forCollectionView:_menuCollectionView andCellIdentifiers:@[@"MenuTabCell"]];
    CGFloat menuTabCellSectionOffset = [UIScreen mainScreen].bounds.size.width * 0.5f - kMenuTabCellWidth * 0.5;
    ((UICollectionViewFlowLayout*)_menuCollectionView.collectionViewLayout).sectionInset = UIEdgeInsetsMake(20, menuTabCellSectionOffset, 0, menuTabCellSectionOffset);
    
    _clubResultsController = [DDMResultsController controllerForDelegate:self forObject:_club];
    
    [self updateSortMenu];
    
    //Add fade out effect to menu bar
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[UIScreen mainScreen] bounds];
    gradient.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor,(id)[UIColor clearColor].CGColor];
    gradient.locations = @[@0.0, @0.1, @0.3, @0.9, @1.0];
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);
    _menuCollectionView.superview.layer.mask = gradient;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [LocationsManager requestLocation];
    
    [super viewWillAppear:animated];
    
    _order = [Order currentOrder];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:[UINavigationController backViewController] ? NBT_Back : NBT_Settings];
    [MainView setNavBarButton:NBT_EmptyRight];
    [MainView setTitleButtonVisibility:false];
    
    _sortButton.selected = false;
    _containerView.alpha = false;
    
    //Add shadow to List/Map button group
    [_sortButton.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0].CGColor];
    [_sortButton.layer setShadowOpacity:0.39];
    [_sortButton.layer setShadowRadius:3.0];
    [_sortButton.layer setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [self updateView];
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [Globals setupViewControllers];
        UIAlertAction *action1 = [UIAlertAction initWithTitle:@"Settings" forTarget:[Globals class] andSelector:@selector(openSettings)];
        UIAlertAction *action2 = [UIAlertAction initWithTitle:@"Cancel"];
        [UIAlertController showWithTitle:@"Location Permission Denied" message:@"To track your location, please go to Settings and enable Location Service for this app." actions:@[action1,action2]];
    }

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateView];
}

- (void)updateView
{
    _contactTextView.text = [NSString stringWithFormat:@"Course contact: %@",_club.phone_number];
    [_contactView animateAlphaTo:!_menuResultsController.fetchedObjects.count withDuration:0.3 andDelay:1];
    _selectedMenuView.hidden = !_menuResultsController.fetchedObjects.count;
    _sortButton.hidden = !_menuResultsController.fetchedObjects.count;
    _imageView.image = [_club.photo getBestImage];
    _logoImageView.image = [_club.logoPhoto getBestImage];
    _priceLabel.text = @([_order calculateTotal]).toPriceString;
    
    
    NSInteger quantity = 0;
    for(Order_Item *orderItem in _order.items)
    {
        quantity += orderItem.quantity.integerValue;
        [self moveToRightMenuType:orderItem];
    }
    _quantityLabel.text = @(quantity).stringValue;
    NSInteger cartViewConstant = quantity ? 0 : -_priceLabel.bounds.size.height;
    [self.view animateConstraint:_cartViewConstraint toConstant:cartViewConstant withDuration:0 andDelay:0];
    
}

- (void)moveToRightMenuType:(Order_Item*)orderItem
{
    for (MenuCell *cell in [self.menuCollectionView visibleCells]) {
        if(cell.nameLabel.text == orderItem.menu_item.menu.name){
            NSIndexPath *indexPath = [self.menuCollectionView indexPathForCell:cell];
            [self scrollCollectionViewsToIndexPath:indexPath animation:NO];
            break;
        }
    }
}

- (void)updateSortMenu
{
    _currentMenu = [_resultsController objectAtIndexPath:[_collectionView getCurrentIndexPath]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Item_Type"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"ANY items.menu = %@",_currentMenu];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _tableViewResultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forTableView:_tableView andCellIdentifiers:@[@"ItemTypeCell"]];
    [_tableView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = collectionView.bounds.size;
    if(collectionView == _menuCollectionView)
    {
        size.width = kMenuTabCellWidth;
    }
    return size;
}

- (void)disableScrollAlert
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Sorry, you can’t switch to a different menu while there are items in your cart from this one."
                               message:NULL
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okayButton = [UIAlertAction
                                actionWithTitle:@"Okay"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                }];
    [alert addAction:okayButton];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == _menuCollectionView)
    {
        NSInteger quantity = 0;
        for(Order_Item *orderItem in _order.items)
        {
            quantity += orderItem.quantity.integerValue;
            break;
        }
        if(quantity > 0){ // should disable scrolling
            [self disableScrollAlert];
            [self scrollCollectionViewsToIndexPath:[_collectionView getCurrentIndexPath]];
        } else {
            [self scrollCollectionViewsToIndexPath:[_menuCollectionView getCurrentIndexPath]];
        }
        
    }
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _menuCollectionView)
    {
        NSInteger quantity = 0;
        for(Order_Item *orderItem in _order.items)
        {
            quantity += orderItem.quantity.integerValue;
            break;
        }
        if(quantity > 0){ // should disable scrolling
            [self disableScrollAlert];
            [self scrollCollectionViewsToIndexPath:[_collectionView getCurrentIndexPath]];
        } else {
            [self scrollCollectionViewsToIndexPath:[_menuCollectionView getCurrentIndexPath]];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _collectionView)
    {
        NSInteger quantity = 0;
        for(Order_Item *orderItem in _order.items)
        {
            quantity += orderItem.quantity.integerValue;
            break;
        }
        if(quantity > 0){ // should disable scrolling
            [self disableScrollAlert];
            [self scrollCollectionViewsToIndexPath:[_menuCollectionView getCurrentIndexPath]];
        } else {
            [self scrollCollectionViewsToIndexPath:[_collectionView getCurrentIndexPath]];
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger quantity = 0;
    for(Order_Item *orderItem in _order.items)
    {
        quantity += orderItem.quantity.integerValue;
        break;
    }
    if(quantity > 0 && indexPath != [_menuCollectionView getCurrentIndexPath]){ // should disable scrolling
        [self disableScrollAlert];
        [self scrollCollectionViewsToIndexPath:[_collectionView getCurrentIndexPath]];
    } else {
        [self scrollCollectionViewsToIndexPath:indexPath];
    }
}

- (void)scrollCollectionViewsToIndexPath:(NSIndexPath*)indexPath animation:(BOOL)animation
{
    [_menuCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animation];
    [_collectionView  scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animation];
}

- (void)scrollCollectionViewsToIndexPath:(NSIndexPath*)indexPath
{
    [self scrollCollectionViewsToIndexPath:indexPath animation:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sortButtonPressed];
    MenuCell *menuCell = [_collectionView getCurrentCell];
    NSIndexPath *path = [NSIndexPath indexPathForItem:indexPath.section inSection:indexPath.row];
    [menuCell.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)sortButtonPressed
{
    _sortButton.selected = !_sortButton.selected;
    [_containerView animateAlphaTo:_sortButton.selected withDuration:0.3 andDelay:0];
    [self updateSortMenu];
}

- (IBAction)viewOrderButtonPressed
{
    [self.navigationController pushViewController:[OrderViewController new]];
}

@end
