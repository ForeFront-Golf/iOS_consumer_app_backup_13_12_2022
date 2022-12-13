//
//  DocumentViewController.h
//  Union
//
//  Created by Eddy Douridas on 2014-08-27.
//  Copyright (c) 2014 Matt Michels. All rights reserved.
//

@interface DocumentViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property IBOutlet UIWebView *webView;

@property NSString *fileName;
@property DDMResultsController *resultsController;

@end
