//
//  OptionItemCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-10.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "OptionItemCell.h"

@implementation OptionItemCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    MenuItemViewController *controller = owner;
    _orderItem = controller.orderItem;
    _optionItem = object;
    _button.selected = [_orderItem hasOption:_optionItem];
    _nameLabel.text = _optionItem.name;
    if(!_optionItem.price.doubleValue)
    {
        _priceLabel.text = nil;
    }
    else
    {
        _priceLabel.text = [NSString stringWithFormat:@"+%@",[_optionItem.price toPriceString]];
    }
    
    if([_optionItem.option_group isSingleOption])
    {
        [_button setImage:[UIImage imageNamed:@"input_radio_0.png"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"input_radio_1.png"] forState:UIControlStateSelected];
        [_button setImage:[UIImage imageNamed:@"input_radio_1.png"] forState:UIControlStateHighlighted];

    }
    else
    {
        [_button setImage:[UIImage imageNamed:@"input_checkbox_0.png"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"input_checkbox_1.png"] forState:UIControlStateSelected];
        [_button setImage:[UIImage imageNamed:@"input_checkbox_1.png"] forState:UIControlStateHighlighted];
    }
    
}

- (IBAction)buttonPressed
{
    if([_optionItem.option_group isSingleOption])
    {
        [_orderItem clearOptionsForGroup:(_optionItem.option_group)];
    }
    
    _button.selected = !_button.selected;
    if(_button.selected)
    {
        [_orderItem addOrder_optionsObject:_optionItem];
    }
    else
    {
        [_orderItem removeOrder_optionsObject:_optionItem];
    }
}

@end
