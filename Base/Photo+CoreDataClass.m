//
//  Photo+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-01-26.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Photo+CoreDataClass.h"
#import "Facebook_User+CoreDataClass.h"
#import "User+CoreDataClass.h"

@implementation Photo
    
- (void)setThumbUpdatedAt:(NSDate *)thumbUpdatedAt
{
    [self willChangeValueForKey:kThumbUpdatedAt];
    [self setPrimitiveValue:thumbUpdatedAt forKey:kThumbUpdatedAt];
    [self didChangeValueForKey:kThumbUpdatedAt];
    
    self.readyForDisplay = thumbUpdatedAt != nil || self.mediaUpdatedAt != nil;
}

- (void)setMediaUpdatedAt:(NSDate *)mediaUpdatedAt
{
    [self willChangeValueForKey:kMediaUpdatedAt];
    [self setPrimitiveValue:mediaUpdatedAt forKey:kMediaUpdatedAt];
    [self didChangeValueForKey:kMediaUpdatedAt];
    
    self.readyForDisplay = self.thumbUpdatedAt != nil || mediaUpdatedAt != nil;
    
    [self.club makeDirty];
    [self.clubLogo makeDirty];
}

- (void)setReadyForDisplay:(BOOL)readyForDisplay
{
    [self willChangeValueForKey:@"readyForDisplay"];
    [self setPrimitiveValue:@(readyForDisplay) forKey:@"readyForDisplay"];
    [self didChangeValueForKey:@"readyForDisplay"];
    
    if(readyForDisplay)
    {
        [self.user makeDirty];
        [self.menuItem makeDirty];
        for(Menu_Item_Type *menuItemType in self.menuItem.menu_item_types)
        {
            menuItemType.menu_item = self.menuItem;
        }
    }
}

- (NSString*)getAmazonURLForKey:(NSString*)key
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/public/%@/%@",kAWSURL,kAWSBucket,self.user.user_id,[self getNameForKey:key]];
    return url;
}

- (void)uploadToS3ForKey:(NSString *)key
{
    [self uploadToS3ForKey:key withBlock:^(BOOL succeeded){}];
}

- (void)uploadToS3ForKey:(NSString*)key withBlock:(void (^)(BOOL succeeded))block
{
    assert(self.user);
    NSString *awsKey = [self getAWSPathForKey:key];
    AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
    [transferUtility uploadFile:[self getURLForKey:key] bucket:kAWSBucket key:awsKey contentType:@"image/jpeg" expression:nil completionHandler:^(AWSS3TransferUtilityUploadTask * _Nonnull task, NSError * _Nullable error)
    {
        if(error)
        {
            NSLog(@"Error: %@", error);
            block(false);
        }
        else
        {
            block(true);
        }
    }];
}

- (void)deleteFromS3ForKey:(NSString *)key
{
    assert(self.user);
    AWSS3DeleteObjectRequest *deleteObjectRequest = [AWSS3DeleteObjectRequest new];
    deleteObjectRequest.bucket = [NSString stringWithFormat:@"%@/public/%@",kAWSBucket,self.user.user_id];
    deleteObjectRequest.key = [self getNameForKey:key];
    [[AWSS3 defaultS3] deleteObject:deleteObjectRequest];
}

- (void)downloadPhotoWithBlock:(void (^)(BOOL succeeded))block
{
    self.thumbURL = [self getAmazonURLForKey:kThumbnail];
    self.mediaURL = [self getAmazonURLForKey:kMedia];
    [self fetchDataForKey:kThumbnail withBlock:^()
     {
         if([self hasDataForKey:kThumbnail])
         {
             block(true);
         }
         else
         {
             [self deleteObject];
             block(false);
         }
     }];
}

- (CGSize)getSizeForKey:(NSString*)key
{
    UIImage *image = [self getBestImage];
    CGSize bounds = [key isEqualToString:kThumbnail] ? kThumbnailSize : kImageSize;
    CGSize size = [image aspectFitSizeForBounds:bounds];
    return size;
}

@end
