//
//  OrderItemCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-12.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "OrderItemCell.h"

@implementation OrderItemCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _orderItem = object;
    _nameLabel.text = _orderItem.menu_item.name;
    _quantityLabel.text = _orderItem.quantity.stringValue;
    _priceLabel.text = [_orderItem.price toPriceString];
    
    _detailsLabel.text = @"";
    
    
    NSArray *sortedOptions = [_orderItem.order_options sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    for(int i = 0; i < sortedOptions.count; i++)
    {
        Option_Item *option = sortedOptions[i];
        NSString *detail;
        if(option.price.doubleValue){
            detail = [NSString stringWithFormat:@"%@(%@)",option.name,[option.price toPriceString]];
        } else {
            detail = [NSString stringWithFormat:@"%@",option.name];
        }
        _detailsLabel.text = [_detailsLabel.text stringByAppendingString:detail];
        
        if(i < sortedOptions.count - 1)
        {
            _detailsLabel.text =  [_detailsLabel.text stringByAppendingString:@"\n"];
        }
    }
    NSString *request = _orderItem.special_request;
    if(request.length)
    {
        _detailsLabel.text = [_detailsLabel.text stringByAppendingString:@"\nNotes: "];
        _detailsLabel.text = [_detailsLabel.text stringByAppendingString:request];
        if(_orderItem.order_options.count)
        {
            _detailsLabel.text =  [_detailsLabel.text stringByAppendingString:@"\n"];
        }
    }
}

@end
