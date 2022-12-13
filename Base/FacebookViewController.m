//
//  FacebookViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2015-06-18.
//  Copyright (c) 2015 DDMAppDesign. All rights reserved.
//

#import "FacebookViewController.h"

@implementation FacebookViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (FacebookViewController*)createFacebookViewControllerWithDelegate:(id<FacebookControllerDelegate>)delegate
{
    FacebookViewController *controller = [FacebookViewController new];
    controller.delegate = delegate;
    [[UINavigationController getController] presentViewController:controller animated:YES completion:nil];
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"facebook_user = %@",[User currentUser].facebook_user];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO selector:nil]];
    _resultsController = [[CollectionViewResultsController alloc] initWithFetchRequest:fetchRequest sectionNameKeyPath:nil forCollectionView:_collectionView andCellIdentifiers:@[@"ImageViewCell"]];
    
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 0, 0)];
    [_collectionView addSubview:refreshView];
    _refreshControl = [UIRefreshControl new];
    _refreshControl.tintColor = [UIColor redColor];
    [_refreshControl addTarget:[DDMFacebookManager manager] action:@selector(fetchFacebookPhotos) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:_refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookPhotosSynced) name:kFacebookPhotosSynced object:nil];
}

- (IBAction)cancelButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [_resultsController objectAtIndexPath:indexPath];
    [_delegate facebookController:self didFinishPickingPhoto:photo];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSIndexPath*)getStartingIndexPath
{
    return _selectedIndexPath;
}

- (void)facebookPhotosSynced
{
    [_refreshControl endRefreshing];
}

@end
