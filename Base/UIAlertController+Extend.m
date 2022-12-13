//
//  UIAlertController+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UIAlertController+Extend.h"

@implementation UIAlertController (Extend)

+ (UIAlertController*)showWithTitle:(NSString*)title
{
    UIAlertController *alertController = [self showWithTitle:title message:nil actions:nil preferredStyle:UIAlertControllerStyleActionSheet];
    return alertController;
}

+ (UIAlertController*)showWithTitle:(NSString*)title message:(NSString*)message actions:(NSArray*)actions
{
    UIAlertController *alertController = [self showWithTitle:title message:message actions:actions preferredStyle:UIAlertControllerStyleActionSheet];
    return alertController;
}

+ (UIAlertController*)showWithTitle:(NSString*)title message:(NSString*)message actions:(NSArray*)actions preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    UIAlertController *alertController = [self createWithTitle:title message:message actions:actions preferredStyle:preferredStyle];
    [[UINavigationController getController] presentViewController:alertController animated:YES completion:nil];;
    return alertController;
}

+ (UIAlertController*)createWithTitle:(NSString*)title message:(NSString*)message actions:(NSArray*)actions preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    if(!actions.count)
    {
        actions = @[[UIAlertAction initWithTitle:@"OK"]];
    }
    
    for(UIAlertAction *action in actions)
    {
        [alertController addAction:action];
    }

    alertController.popoverPresentationController.sourceView = [UINavigationController getController].view;
    
    return alertController;
}

@end
