//
//  ParseManager.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2015-02-27.
//  Copyright (c) 2015 DDMAppDesign. All rights reserved.
//

static NSString *const kFacebookPhotosSynced = @"facebookPhotosSynced";

@interface DDMFacebookManager : NSObject <UIAlertViewDelegate>

+ (DDMFacebookManager*)manager;

- (void)fetchFacebookPhotos;

@end
