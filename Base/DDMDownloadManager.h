//
//  DDMDownloadManager.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-07-05.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMDownloadManager : NSObject

+ (DDMDownloadManager*)manager;

@property NSMutableArray *currentDownloads;
@property NSMutableDictionary *queuedDownloads;
@property NSMutableArray *downloads;

- (void)downloadFile:(NSString*)fileName forObject:(NSManagedObject*)object forKey:(NSString*)key withBlock:(void (^)(void))block;

@end
