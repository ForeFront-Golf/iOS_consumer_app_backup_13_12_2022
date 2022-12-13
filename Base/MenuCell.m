//
//  MenuCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-05.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (void)setupCollectionView:(UICollectionView *)collectionView withObject:(id)object forOwner:(id)owner
{
    _menu = object;
    _nameLabel.text = _menu.name;
    _descriptionLabel.text = _menu.desc;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Menu_Item_Type"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"menu_item.valid = true && menu_item.available = true && menu_item.menu = %@",_menu];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"item_type.name" ascending:YES selector:@selector(caseInsensitiveCompare:)], [[NSSortDescriptor alloc] initWithKey:@"menu_item.name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _resultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:@"item_type.name" forTableView:_tableView andCellIdentifiers:@[@"MenuItemCell"]];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MenuTypeHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MenuTypeHeaderView"];
    
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MenuTypeHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MenuTypeHeaderView"];
    Menu_Item_Type *menuItemType = [_resultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    [view setupTableView:tableView withObject:menuItemType forOwner:self];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemViewController *controller = [MenuItemViewController new];
    Menu_Item_Type *menuItemType = [_resultsController objectAtIndexPath:indexPath];
//    //Add this to check if item already in the cart.
//    for(Order_Item *item in [[Order currentOrder] items]){
//        if(item.menu_item.name == menuItemType.menu_item.name){
//            controller.orderItem = item;
//            break;
//        }
//    }
    controller.menuItem = menuItemType.menu_item;
    [[UINavigationController getController] pushViewController:controller];
}

@end
