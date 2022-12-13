//
//  LocationsManager.m
//  Zimity
//
//  Created by Eddy Douridas on 2017-10-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//
//  Most importantly, requestLocation must be called to begin location services.
//  Once called, the service will be powered up and determine the current location the best it can.
//  Once a location is determined, location services is powered down. LocationManagerDelegate is responsible for
//  powering up the service again. Implementing secondsUntilNextLocationUpdate will determine when to power up
//  the service again. If the LocationManagerDelegate is not used, then a delay of kDefaultUpdateFrequency will be used.
//  This process will repeat indefinitely until stopUpdatingLocations is called.

#import "LocationsManager.h"

@implementation LocationsManager

// Powers up location services and immediately determine the current location the best it can
+ (void)requestLocation
{
    if([[self manager].locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [[self manager].locationManager requestAlwaysAuthorization];
    }
    
    [[self manager] powerUp];
    [[self manager].locationManager startUpdatingLocation];
}

+ (void)stopUpdatingLocation
{
    [[self manager].locationManager stopUpdatingLocation];;
}

+ (void)startMonitoringSignificantLocationChanges
{
    [[self manager].locationManager startMonitoringSignificantLocationChanges];;
}

+ (void)stopMonitoringSignificantLocationChanges;
{
    [[self manager].locationManager stopMonitoringSignificantLocationChanges];
}

+ (void)setDelegate:(id<LocationManagerDelegate>)delegate
{
    [self manager].delegate = delegate;
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertAction *action1 = [UIAlertAction initWithTitle:@"Settings" forTarget:[UIApplication sharedApplication] andSelector:@selector(openURL:) withObject:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        UIAlertAction *action2 = [UIAlertAction initWithTitle:@"Cancel"];
        [UIAlertController showWithTitle:@"Location Permission Denied" message:@"To track your location, please go to Settings and enable Location Service for this app." actions:@[action1,action2]];
    }
}

+ (LocationsManager*)manager
{
    static LocationsManager *manager = nil;
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [LocationsManager new];
        }
    }
    return manager;
}

- (id)init
{
    if(self = [super init])
    {
        _minimumAccuracy = kDefaultMinimumAccuracy;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //App specific.  Set to true if location manager should run in background
        //        _locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManager.activityType = CLActivityTypeFitness;
    }
    return self;
}

- (void)powerUp
{
    _failedCount = 0;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)powerDownFor:(CGFloat)duration
{
    _locationManager.distanceFilter = NSIntegerMax;
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(powerUp) withObject:nil afterDelay:duration];
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"locationManagerDidPauseLocationUpdates");
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"locationManagerDidResumeLocationUpdates");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed to get location: %@", error.userInfo);
    [self locationFailed];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    NSTimeInterval remaining = [UIApplication sharedApplication].backgroundTimeRemaining;
//    NSLog(@"Background time remaining %ld.",(long)remaining);
    
    CLLocation *location = locations.lastObject;
    NSTimeInterval age = [[NSDate date] timeIntervalSinceDate:location.timestamp];
    if(age > 5.0)
    {
        //Location data is too old
        return;
    }
    
    if(_locationManager.distanceFilter == NSIntegerMax)
    {
        //In power down mode, waiting until powered up again
        return;
    }

    if(location.horizontalAccuracy < 0)
    {
        //Accuracy is invalid
        return;
    }
    
    NSTimeInterval lastUpdate = [location.timestamp timeIntervalSinceDate:_currentLocation.timestamp];
    CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
    NSLog(@"Potential Location: Age = %f. Time Elapsed = %f. Distance Traveled = %f. Accuracy = %f. Latitude = %f. longitude = %f.",age, lastUpdate, distance, location.horizontalAccuracy, location.coordinate.latitude, location.coordinate.longitude);
    if(location.horizontalAccuracy > _minimumAccuracy)
    {
        //No accurate enough
        NSLog(@"Inaccurate location. Failed count = %ld.",(long)_failedCount);
        [self locationFailed];
        return;
    }
    
    [self broadcastLocation:location];
}

- (void)locationFailed
{
    _failedCount++;
    if(_failedCount > kFailedCountMax)
    {
        NSLog(@"Failed to determine an accurate location. Powering down.");
        [self powerDownFor:kDefaultUpdateFrequency];
    }
}

- (void)broadcastLocation:(CLLocation*)location
{
    CGFloat secondsUntilNextLocationUpdate = kDefaultUpdateFrequency;
    if([_delegate respondsToSelector:@selector(secondsUntilNextLocationUpdate)])
    {
        secondsUntilNextLocationUpdate = [_delegate secondsUntilNextLocationUpdate];
    }
    [self powerDownFor:secondsUntilNextLocationUpdate];
    
    _currentLocation = location;
    NSLog(@"Location Accepted.  Next update in %f seconds.",secondsUntilNextLocationUpdate);
    NSMutableDictionary *info = @{@"latitude":@(location.coordinate.latitude),@"longitude":@(location.coordinate.longitude), @"horizontalAccuracy":@(location.horizontalAccuracy), @"verticalAccuracy":@(location.verticalAccuracy)}.mutableCopy;
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLocationUpdated object:nil userInfo:info];
}

/////////////////////////////////////////////////////////////////////////////////
+ (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result)
    {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil])
        {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil])
            {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

- (void)createRegionAtLocation:(CLLocationCoordinate2D)location radius:(double)radius identifier:(NSString *)identifier
{
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:location radius:radius identifier:identifier];
    [_locationManager startMonitoringForRegion:region];
}

- (void)removeRegion:(NSString *)identifier
{
    CLCircularRegion *region = [_locationManager.monitoredRegions filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@",identifier]].anyObject;
    [_locationManager stopMonitoringForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserEnteredRegion object:nil userInfo:@{@"region":region}];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserExitedRegion object:nil userInfo:@{@"region":region}];
}

@end
