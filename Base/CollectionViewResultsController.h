//
//  CollectionViewResultsController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DDMBlockOperation;

@protocol CollectionViewResultsDataSource;

@interface CollectionViewResultsController : NSFetchedResultsController <NSFetchedResultsControllerDelegate, UICollectionViewDataSource>

@property UICollectionView *collectionView;
@property NSString *cellIdentifier;
@property DDMBlockOperation *blockOperation;
@property (weak) IBOutlet id<CollectionViewResultsDataSource> dataSource;

- (id)initWithFetchRequest:(NSFetchRequest*)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath forCollectionView:(UICollectionView*)collectionView andCellIdentifiers:(NSArray*)identifiers;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol CollectionViewResultsDataSource <NSObject>

@optional
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)collectionView:(UICollectionView *)collectionView cellIdentifierForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)collectionView:(UICollectionView *)collectionView wasChangedByController:(CollectionViewResultsController*)controller;

@end
