//
//  Club+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Club+CoreDataClass.h"
#import "Course+CoreDataClass.h"
#import "Menu+CoreDataClass.h"
@implementation Club

- (void)prepareForDeletion
{
    [super prepareForDeletion];
    
    [[NSFileManager defaultManager] removeItemAtPath:[self.photo getPathForKey:kMedia] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self.logoPhoto getPathForKey:kMedia] error:nil];
}

- (void)setClub_id:(NSNumber *)club_id
{
    [self willChangeValueForKey:@"club_id"];
    [self setPrimitiveValue:club_id forKey:@"club_id"];
    [self didChangeValueForKey:@"club_id"];
    
    if(!self.photo)
    {
        self.photo = [Photo createObject];
        self.photo.photo_id = [NSString stringWithFormat:@"club_%@",club_id];
    }
    if(!self.logoPhoto)
    {
        self.logoPhoto = [Photo createObject];
        self.logoPhoto.photo_id = [NSString stringWithFormat:@"logo_%@",club_id];
    }
}

- (void)setLon:(NSNumber *)lon
{
    [self willChangeValueForKey:@"lon"];
    [self setPrimitiveValue:lon forKey:@"lon"];
    [self didChangeValueForKey:@"lon"];
    [self changeDistance];
}

- (void)setLat:(NSNumber *)lat
{
    [self willChangeValueForKey:@"lat"];
    [self setPrimitiveValue:lat forKey:@"lat"];
    [self didChangeValueForKey:@"lat"];
    [self changeDistance];
    
}

- (void)changeDistance
{
    User *currentUser = [User currentUser];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentUser.location.latitude.doubleValue longitude:currentUser.location.longitude.doubleValue];
    CLLocation *clubLocation = [[CLLocation alloc] initWithLatitude:self.lat.doubleValue longitude:self.lon.doubleValue];
    self.distance = [currentLocation distanceFromLocation:clubLocation] / 1000.f;
}

- (void)downloadMenus
{
    NSString *url = [NSString stringWithFormat:@"%@/club/%@/menu?full=true", kServerURL,self.club_id];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         for(NSDictionary *menuData in results[@"Menu"])
         {
             [Menu serializeFrom:menuData];
         }
     }];
}

+ (void)downloadClubsWithBlock:(void (^)(void))block
{
    NSString *url = [NSString stringWithFormat:@"%@/club?private=true", kServerURL];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         for(NSDictionary *clubData in results[@"Club"])
         {
             [self serializeFrom:clubData];
         }
         
         block();
     }];
}

@end
