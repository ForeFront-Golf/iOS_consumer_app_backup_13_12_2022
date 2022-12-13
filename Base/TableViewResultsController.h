//
//  TableViewResultsController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewResultsDataSource;

@interface TableViewResultsController : NSFetchedResultsController <NSFetchedResultsControllerDelegate, UITableViewDataSource>

@property UITableView *tableView;
@property NSString *cellIdentifier;
@property NSMutableArray *rowsToInsert;
@property NSMutableArray *sectionsToInsert;
@property NSMutableArray *selectedObjects;
@property (weak) IBOutlet id<TableViewResultsDataSource> dataSource;
@property UITableViewRowAnimation insertRowAnimation;
@property UITableViewRowAnimation deleteRowAnimation;

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)sectionNameKeyPath forTableView:(UITableView*)tableView andCellIdentifiers:(NSArray*)identifiers;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol TableViewResultsDataSource <NSObject>

@optional
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
- (UITableViewRowAnimation)tableView:(UITableView *)tableView cellInsertAnimationForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)tableview:(UITableView *)tableView wasChangedByController:(TableViewResultsController*)controller;

@end
