//
//  TutorialViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-21.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "TutorialViewController.h"

@implementation TutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MainView setNavBarButton:NBT_Back];
    [MainView setNavBarButton:NBT_EmptyRight];
    [MainView setTitleLabel:@"Tutorial"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"TutorialCell" bundle:nil] forCellWithReuseIdentifier:@"TutorialCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 13;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TutorialCell" forIndexPath:indexPath];
    [cell setupCollectionView:collectionView withObject:indexPath forOwner:self];
    return cell;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePageControl];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self updatePageControl];
}

- (void)updatePageControl
{
    NSInteger index = roundf(_collectionView.contentOffset.x / _collectionView.frame.size.width);
    _pageControl.currentPage = index;
}

@end
