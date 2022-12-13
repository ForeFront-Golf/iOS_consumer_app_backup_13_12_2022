//
//  CollectionViewResultsController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "CollectionViewResultsController.h"

@implementation CollectionViewResultsController

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath forCollectionView:(UICollectionView *)collectionView andCellIdentifiers:(NSArray *)identifiers
{
    if(self = [self initWithFetchRequest:fetchRequest managedObjectContext:[CoreData context] sectionNameKeyPath:sectionNameKeyPath cacheName:nil])
    {
        self.delegate = self;
        _collectionView = collectionView;
        _cellIdentifier = identifiers[0];
        id previousResultsController = _collectionView.dataSource;
        if(previousResultsController && [previousResultsController isKindOfClass:[CollectionViewResultsController class]])
        {
            _dataSource = (id<CollectionViewResultsDataSource>)[previousResultsController dataSource];
        }
        else
        {
            _dataSource = (id<CollectionViewResultsDataSource>)_collectionView.dataSource;
        }
        _collectionView.dataSource = self;
        
        for(NSString *identifier in identifiers)
        {
            if([identifier isEqualToString:kUICollectionViewCell])
            {
                [_collectionView registerClass:[UICollectionViewCell class]  forCellWithReuseIdentifier:identifier];
            }
            else
            {
                [_collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
            }
        }
        
        NSError *error = nil;
        [self performFetch:&error];
        if(error)
        {
            NSLog(@"Unable to perform fetch.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
    return self;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.blockOperation = [DDMBlockOperation new];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch (type)
    {
        case NSFetchedResultsChangeUpdate:
        {
            [self.blockOperation addExecutionBlock:^{[collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];}];
            break;
        }
            
        case NSFetchedResultsChangeInsert:
        {
            [self.blockOperation addExecutionBlock:^{[collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];}];
            break;
        }
            
        case NSFetchedResultsChangeDelete:
        {
            [self.blockOperation addExecutionBlock:^{[collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];}];
            break;
        }
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch (type)
    {
        case NSFetchedResultsChangeUpdate:
        {
            [self.blockOperation addExecutionBlock:^{[collectionView reloadItemsAtIndexPaths:@[indexPath]];}];
            break;
        }
            
        case NSFetchedResultsChangeInsert:
        {
            [self.blockOperation addExecutionBlock:^{[collectionView insertItemsAtIndexPaths:@[newIndexPath]];}];
            break;
        }
            
        case NSFetchedResultsChangeDelete:
        {
            [self.blockOperation addExecutionBlock:^{[collectionView deleteItemsAtIndexPaths:@[indexPath]];}];
            break;
        }
        
        case NSFetchedResultsChangeMove:
        {
            [self.blockOperation addExecutionBlock:^{[collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];}];
            break;
        }
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    assert([NSThread isMainThread]);
    
    [self.collectionView performBatchUpdates:^{
        [self.blockOperation start];
    } completion:^(BOOL succeeded)
     {        
         if([_dataSource respondsToSelector:@selector(collectionView:wasChangedByController:)])
         {
             [_dataSource collectionView:_collectionView wasChangedByController:self];
         }
     }];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)])
    {
        return [_dataSource collectionView:_collectionView canMoveItemAtIndexPath:indexPath];
    }
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if([_dataSource respondsToSelector:@selector(collectionView:moveItemAtIndexPath:toIndexPath:)])
    {
        return [_dataSource collectionView:_collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if([_dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
    {
        return [_dataSource numberOfSectionsInCollectionView:collectionView];
    }
    else
    {
        NSInteger count = self.sections.count;
        return count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([_dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
    {
        NSInteger items = [_dataSource collectionView:collectionView numberOfItemsInSection:section];
        return items;
    }
    else
    {
        NSArray *sections = self.sections;
        id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
        NSInteger count = [sectionInfo numberOfObjects];
        return count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    assert([NSThread isMainThread]);
    
    UICollectionViewCell *cell = nil;
    if([_dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)])
    {
        cell = [_dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    if(!cell)
    {
        NSString *cellIdentifier = _cellIdentifier;
        if([_dataSource respondsToSelector:@selector(collectionView:cellIdentifierForItemAtIndexPath:)])
        {
            cellIdentifier = [_dataSource collectionView:collectionView cellIdentifierForItemAtIndexPath:indexPath];
        }
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell setupCollectionView:_collectionView withObject:[self objectAtIndexPath:indexPath] forOwner:_dataSource];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([_dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
    {
        return [_dataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}

@end
