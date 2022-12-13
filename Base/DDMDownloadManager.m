//
//  DDMDownloadManager.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-07-05.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

static const NSInteger kMaxNumberOfDownloads = 5;

#import "DDMDownloadManager.h"

@implementation DDMDownloadManager

+ (DDMDownloadManager*)manager
{
    static DDMDownloadManager *manager = nil;
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [DDMDownloadManager new];
            [manager setup];
        }
    }
    return manager;
}

- (void)setup
{
    _currentDownloads = @[].mutableCopy;
    _queuedDownloads = @{}.mutableCopy;
    _downloads = @[].mutableCopy;
}

- (bool)canDownloadFile:(NSString*)fileName forObject:(NSManagedObject*)object forKey:(NSString*)key withBlock:(void (^)(void))block
{
    if([_currentDownloads containsObject:fileName])
    {
        return false;
    }
    else if(_currentDownloads.count >= kMaxNumberOfDownloads)
    {
        _queuedDownloads[fileName] = @{@"object":object, @"key":key, @"block":block};
        return false;
    }
    
    return true;
}

- (void)downloadFile:(NSString*)fileName forObject:(NSManagedObject*)object forKey:(NSString*)key withBlock:(void (^)(void))block
{
    if(![self canDownloadFile:fileName forObject:object forKey:key withBlock:block])
    {
        return;
    }
    
    NSString *fileURLKey = [NSString stringWithFormat:@"%@URL",key];
    if([object objectForKey:@"facebook_user"])
    {
        if([object hasDataForKey:key])
        {
            block();
        }
        else
        {
            [_currentDownloads addObject:fileName];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[object valueForKey:fileURLKey]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [object saveData:data forKey:key];
                    [self removeFile:fileName];
                    [Globals postNotificationName:kFileDownloaded object:nil userInfo:@{@"key":key, @"object":object}];
                    block();
                });
            });
        }
    }
    else
    {
        NSString *fileUpdatedAtKey = [NSString stringWithFormat:@"%@UpdatedAt",key];
        NSDate *updatedAt = [object objectForKey:fileUpdatedAtKey];
        NSTimeInterval lastUpdatedDiff = [[NSDate date] timeIntervalSinceDate:updatedAt];
        if(lastUpdatedDiff < kS3UpdateImageTime)
        {
            block();
        }
        else
        {
            [_currentDownloads addObject:fileName];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                [self downloadFromAmazonForObject:object forKey:key withBlock:^(NSError *error)
                {
                    NSString *fileName = [object getNameForKey:key];
                    [self removeFile:fileName];
                    block();
                }];
            });
        }
    }
}

- (void)downloadFromAmazonForObject:(NSManagedObject*)object forKey:(NSString*)key withBlock:(void (^)(NSError *error))block;
{
    NSDate *updatedAt = [object objectForKey:[NSString stringWithFormat:@"%@UpdatedAt",key]];
    if(![object hasDataForKey:key])
    {
        updatedAt = nil;
    }

    NSString *awsKey = [object getAWSPathForKey:key];
    AWSS3HeadObjectRequest *head = [AWSS3HeadObjectRequest new];
    head.bucket = kAWSBucket;
    head.key = awsKey;
    head.ifModifiedSince = updatedAt;
    [[[AWSS3 defaultS3] headObject:head] continueWithBlock:^id(AWSTask *task)
     {
         AWSS3HeadObjectOutput *result = task.result;
         if([result.contentType isEqualToString:@"image/png"] || [result.contentType isEqualToString:@"image/jpeg"] || [result.contentType isEqualToString:@"application/pdf"] || [result.contentType isEqualToString:@"binary/octet-stream"])
         {
             [[AWSS3TransferUtility defaultS3TransferUtility] downloadDataFromBucket:kAWSBucket key:awsKey expression:nil completionHandler:^(AWSS3TransferUtilityDownloadTask * _Nonnull task, NSURL * _Nullable location, NSData * _Nullable data, NSError * _Nullable error)
             {
                 if(error)
                 {
                     NSLog(@"Error: %@", error);
                 }
                 else
                 {
                     [object saveData:data forKey:key];
                     NSString *fileUpdatedAtKey = [NSString stringWithFormat:@"%@UpdatedAt",key];
                     [object setObject:[NSDate date] forKey:fileUpdatedAtKey];
                 }
                 block(error);
             }];
         }
         else
         {
             block(nil);
         }
         return nil;
     }];
}

- (void)removeFile:(NSString*)fileName
{
    [_currentDownloads removeObject:fileName];
    
    if(_currentDownloads.count < kMaxNumberOfDownloads && _queuedDownloads.count > 0)
    {
        NSString *fileName = _queuedDownloads.allKeys.firstObject;
        NSDictionary *nextDownloadData = [_queuedDownloads objectForKey:fileName];
        NSManagedObject *object = nextDownloadData[@"object"];
        NSString *key = nextDownloadData[@"key"];
        id block = nextDownloadData[@"block"];
        [_queuedDownloads removeObjectForKey:fileName];
        [self downloadFile:fileName forObject:object forKey:key withBlock:block];
    }
}

@end
