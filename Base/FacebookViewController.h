//
//  FacebookViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2015-06-18.
//  Copyright (c) 2015 DDMAppDesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacebookControllerDelegate;

@interface FacebookViewController : UIViewController <CollectionViewResultsDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property id<FacebookControllerDelegate> delegate;
@property CollectionViewResultsController *resultsController;
@property UIRefreshControl *refreshControl;
@property NSIndexPath* selectedIndexPath;

+ (FacebookViewController*)createFacebookViewControllerWithDelegate:(id<FacebookControllerDelegate>)delegate;

@end

@protocol FacebookControllerDelegate <NSObject>

- (void)facebookController:(FacebookViewController *)facebookController didFinishPickingPhoto:(Photo *)photo;

@end

