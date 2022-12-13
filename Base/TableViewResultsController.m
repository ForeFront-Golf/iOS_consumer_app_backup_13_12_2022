//
//  TableViewResultsController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "TableViewResultsController.h"

@implementation TableViewResultsController

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath forTableView:(UITableView*)tableView andCellIdentifiers:(NSArray*)identifiers;
{
    if(self = [self initWithFetchRequest:fetchRequest managedObjectContext:[CoreData context] sectionNameKeyPath:sectionNameKeyPath cacheName:nil])
    {
        self.delegate = self;
        _tableView = tableView;
        _cellIdentifier = identifiers[0];
        _insertRowAnimation = UITableViewRowAnimationLeft;
        _deleteRowAnimation = UITableViewRowAnimationRight;
        id previousResultsController = _tableView.dataSource;
        if(previousResultsController && [previousResultsController isKindOfClass:[TableViewResultsController class]])
        {
            _dataSource = (id<TableViewResultsDataSource>)[previousResultsController dataSource];
        }
        else
        {
            _dataSource = (id<TableViewResultsDataSource>)_tableView.dataSource;
        }
        _tableView.dataSource = self;
        
        for(NSString *identifier in identifiers)
        {
            if([identifier isEqualToString:kUITableViewCell])
            {
                [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
            }
            else
            {
                [_tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
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
    _selectedObjects = @[].mutableCopy;
    for(NSIndexPath *indexPath in _tableView.indexPathsForSelectedRows)
    {
        [_selectedObjects addObject:[self objectAtIndexPath:indexPath]];
    }
    
    _rowsToInsert = @[].mutableCopy;
    _sectionsToInsert = @[].mutableCopy;
    [_tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSAssert([NSThread isMainThread], @"Must be called from the main thread!");
    
    [_rowsToInsert filterUsingPredicate:[NSPredicate predicateWithFormat:@"NOT section in %@",_sectionsToInsert]];
    for(NSIndexPath *indexPath in _rowsToInsert)
    {
        UITableViewRowAnimation insertAnimation = _insertRowAnimation;
        if([_dataSource respondsToSelector:@selector(tableView:cellInsertAnimationForIndexPath:)])
        {
            insertAnimation = [_dataSource tableView:_tableView cellInsertAnimationForIndexPath:indexPath];
        }
        
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:insertAnimation];
    }
    
    [_tableView endUpdates];
    
    for(NSManagedObject *object in _selectedObjects)
    {
        [_tableView selectRowAtIndexPath:[self indexPathForObject:object] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    if([_dataSource respondsToSelector:@selector(tableview:wasChangedByController:)])
    {
        [_dataSource tableview:_tableView wasChangedByController:self];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    assert([NSThread isMainThread]);
    
    switch (type)
    {
        case NSFetchedResultsChangeUpdate:
        {
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
            
        case NSFetchedResultsChangeInsert:
        {
            [_rowsToInsert addObject:newIndexPath];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:_deleteRowAnimation];
            break;
        }
            
        case NSFetchedResultsChangeMove:
        {
            UITableViewRowAnimation insertAnimation = _insertRowAnimation;
            UITableViewRowAnimation deleteAnimation = _deleteRowAnimation;
            if([indexPath isEqual:newIndexPath])
            {
                insertAnimation = deleteAnimation = UITableViewRowAnimationNone;
            }
            else if([_dataSource respondsToSelector:@selector(tableView:cellInsertAnimationForIndexPath:)])
            {
                insertAnimation = [_dataSource tableView:_tableView cellInsertAnimationForIndexPath:indexPath];
            }
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:deleteAnimation];
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:insertAnimation];
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    assert([NSThread isMainThread]);
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [_sectionsToInsert addObject:@(sectionIndex)];
            
            UITableViewRowAnimation insertAnimation = _insertRowAnimation;
            if([_dataSource respondsToSelector:@selector(tableView:cellInsertAnimationForIndexPath:)])
            {
                insertAnimation = [_dataSource tableView:_tableView cellInsertAnimationForIndexPath:[NSIndexPath indexPathForItem:0 inSection:sectionIndex]];
            }
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:insertAnimation];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:_deleteRowAnimation];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([_dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        return [_dataSource numberOfSectionsInTableView:tableView];
    }
    else
    {
        NSInteger count = self.sections.count;
        return count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
    {
        NSInteger rows = [_dataSource tableView:tableView numberOfRowsInSection:section];
        return rows;
    }
    else
    {
        NSArray *sections = self.sections;
        id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
        NSInteger rows = [sectionInfo numberOfObjects];
        return rows;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    assert([NSThread isMainThread]);
    
    UITableViewCell *cell = nil;
    if([_dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)])
    {
        cell = [_dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    if(!cell)
    {
        NSString *cellIdentifier = _cellIdentifier;
        if([_dataSource respondsToSelector:@selector(tableView:cellIdentifierForRowAtIndexPath:)])
        {
            cellIdentifier = [_dataSource tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
        }
        
        cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell setupTableView:tableView withObject:[self objectAtIndexPath:indexPath] forOwner:_dataSource];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([_dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
    {
        return [_dataSource tableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if([_dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)])
    {
        return [_dataSource tableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
    {
        return [_dataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return false;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
    {
        return [_dataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    return false;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if([_dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
    {
        return [_dataSource sectionIndexTitlesForTableView:tableView];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if([_dataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)])
    {
        return [_dataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
    {
        return [_dataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if([_dataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
    {
        return [_dataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

@end
