//
//  DocumentViewController.m
//  Union
//
//  Created by Eddy Douridas on 2014-08-27.
//  Copyright (c) 2014 Matt Michels. All rights reserved.
//

@implementation DocumentViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Back];
    [MainView setNavBarButton:NBT_EmptyRight];
    [MainView setTitleButtonVisibility:true];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    [self updateView];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateView];
}

- (void)updateView
{
    if(_fileName)
    {
        NSURL *targetURL = [NSURL URLWithString:_fileName];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        [_webView loadRequest:request];
    }
}

@end
