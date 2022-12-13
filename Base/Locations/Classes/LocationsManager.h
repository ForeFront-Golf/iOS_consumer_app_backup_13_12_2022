//
//  LocationsManager.h
//  Zimity
//
//  Created by Eddy Douridas on 2017-10-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationManagerDelegate <NSObject>

- (CGFloat)secondsUntilNextLocationUpdate;

@end

////////////////////////////////////////////////////////////////////////////////////
@interface LocationsManager : NSObject <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;

+ (void)requestLocation;
+ (void)stopUpdatingLocation;
+ (void)startMonitoringSignificantLocationChanges;
+ (void)stopMonitoringSignificantLocationChanges;
+ (void)setDelegate:(id<LocationManagerDelegate>)delegate;
+ (LocationsManager*)manager;

@property (nonatomic,assign) id<LocationManagerDelegate> delegate;
@property CLLocation *currentLocation;
@property CGFloat minimumAccuracy;
@property NSInteger failedCount;

+ (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address;
- (void)createRegionAtLocation:(CLLocationCoordinate2D)location radius:(double)radius identifier:(NSString *)identifier;
- (void)removeRegion:(NSString *)identifier;

@end
