//
//  MenuItemViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-06.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "MenuItemViewController.h"

@interface MenuItemViewController ()

@end

@implementation MenuItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(_orderItem)
    {
        _orderItemCopy = [Order_Item getObjectWithId:@(kCurrentObjectId)];
        [_orderItemCopy copyOrderItem:_orderItem];
    }
    else
    {
        _orderItem = [Order_Item getObjectWithId:@(kCurrentObjectId)];
        _orderItem.quantity = @1;
        [_orderItem removeOrder_options:_orderItem.order_options];
        _orderItem.menu_item = _menuItem;
    }
    
    _titleLabel.text = _menuItem.name;
    _nameLabel.text = _menuItem.name;
    _descriptionLabel.text = _menuItem.desc;
    _textVIew.text = _orderItem.special_request;
    _quantityLabel.text = _orderItem.quantity.stringValue;
    [_menuItem.photo fetchDataForKey:kMedia];
    
    CGSize descriptionSize = [_menuItem.desc sizeForWidth:_descriptionLabel.bounds.size.width andFont:_descriptionLabel.font];
    CGFloat headerHeight = _descriptionLabel.frame.origin.y + descriptionSize.height + 20;
    _tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, headerHeight);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Option_Item"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"valid = true && available = true && option_group.valid = true && ANY option_group.menu_items = %@",_menuItem];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"option_group.name" ascending:YES selector:@selector(caseInsensitiveCompare:)], [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    _resultsController = [[TableViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:@"option_group.name" forTableView:_tableView andCellIdentifiers:@[@"OptionItemCell"]];
    
    [_tableView registerNib:[UINib nibWithNibName:@"OptionGroupHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"OptionGroupHeaderView"];
    
    _orderItemResultsController = [DDMResultsController controllerForDelegate:self forObject:_orderItem];
    _menuItemResultsController = [DDMResultsController controllerForDelegate:self forObject:_menuItem];

    [self updateTextView];
    [self updateOrderView];
    
    //add gradient on top
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect f = _gradientView.frame;
    f.size.width = [[UIScreen mainScreen] bounds].size.width;
    gradient.frame = f;
    gradient.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor,
                       (id)[UIColor clearColor].CGColor];
    [_gradientView.layer addSublayer:gradient];
    
    //Add shadow to List/Map button group
    [_nameLabel.layer setBorderWidth:0.0f];
    [_nameLabel.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
    [_nameLabel.layer setShadowOpacity:0.12];
    [_nameLabel.layer setShadowRadius:4.0];
    [_nameLabel.layer setShadowOffset:CGSizeMake(0.0f, 2.0f)];
    
    //Add shadow to Quantity view
    [_quantityView.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
    [_quantityView.layer setShadowOpacity:0.12];
    [_quantityView.layer setShadowRadius:2.0];
    [_quantityView.layer setShadowOffset:CGSizeMake(0.0f, 2.0f)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Close];
    [MainView setNavBarButton:NBT_EmptyRight];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _orderItem.price = @([_orderItem calculateTotal]);
}

- (bool)navButtonPressed:(NavButtonType)type
{
    if(type == NBT_Back)
    {
        if(_orderItem.order)
        {
            [_orderItem copyOrderItem:_orderItemCopy];
        }
        else
        {
            [_orderItem deleteObject];
        }
    }
    return NO;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateOrderView];
}

- (void)updateTextView
{
    _textViewDefaultLabel.hidden = [_textVIew.text trimWhitespace].length > 0;
    
    CGSize size = [_textVIew.text sizeForWidth:_textVIew.bounds.size.width andFont:_textVIew.font];
    CGFloat newHeight = _textVIew.frame.origin.y + size.height + 340;
    CGRect frame = _tableView.tableFooterView.frame;
    frame.size.height = newHeight;
    _tableView.tableFooterView.frame = frame;
    [_tableView beginUpdates];
    [_tableView endUpdates];
}

- (void)updateOrderView
{
    UIImage *image = [_menuItem getBestImage];
    if(image != nil){
        _imageView.image = [_menuItem getBestImage];
    }
    
    
    NSString *orderString;
    if(_orderItem.order)
    {
        orderString = _orderItem.quantity.integerValue ? @"Update cart" : @"Remove from cart";
    }
    else
    {
        orderString = [NSString stringWithFormat:@"Add %@ to cart",_orderItem.quantity];
    }
    [_orderButton setTitle:orderString forState:UIControlStateNormal];
    
    _priceLabel.text = @([_orderItem calculateTotal]).toPriceString;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGFloat alpha = offset.y / 166;
    alpha = MIN(1, MAX(0, alpha));
    _titleView.alpha = alpha;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OptionGroupHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OptionGroupHeaderView"];
    Option_Item *optionItem = [_resultsController objectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    [view setupTableView:_tableView withObject:optionItem.option_group forOwner:self];
    return view;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateTextView];
    [_tableView scrollRectToVisible:_tableView.tableFooterView.frame animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _orderItem.special_request = textView.text;
}

- (IBAction)minusButtonPressed
{
    NSInteger quantity = _orderItem.quantity.integerValue;
    quantity = MAX(_orderItem.order ? 0 : 1 ,--quantity);
    _orderItem.quantity = @(quantity);
    _quantityLabel.text = @(quantity).stringValue;
}

- (IBAction)plusButtonPressed
{
    NSInteger quantity = _orderItem.quantity.integerValue + 1;
    _orderItem.quantity = @(quantity);
    _quantityLabel.text = @(quantity).stringValue;
}

- (IBAction)orderButtonPressed
{
    NSSet *selectedOptionGroups = [_orderItem.order_options valueForKey:@"option_group"];
    for(Option_Group *optionGroup in _orderItem.menu_item.option_groups)
    {
        if(optionGroup.required.boolValue && optionGroup.valid.boolValue && ![selectedOptionGroups containsObject:optionGroup])
        {
            [UIAlertController showWithTitle:[NSString stringWithFormat:@"Please select a %@ option",optionGroup.name] message:nil actions:nil];
            return;
        }
    }
    
    if(_orderItem.quantity.integerValue)
    {
        _orderItem.order_item_id = nil;
        [[Order currentOrder] addItemsObject:_orderItem];
    }
    else
    {
        [_orderItem deleteObject];
        if(_orderItem.order.items.count <= 1)
        {
            [self backButtonPressed];
        }
    }
    [self backButtonPressed];
}


@end
