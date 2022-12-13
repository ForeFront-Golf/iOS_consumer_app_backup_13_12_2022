//
//  AppDelegate.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [OneSignal initWithLaunchOptions:launchOptions appId:@"5125db8e-579f-4505-99cb-8b89f6d26b26" handleNotificationReceived:^(OSNotification *notification) {
        NSLog(@"Notification Received");
        // Data will have the custom data that we add into the notification.
        // e.g. order_id = 123, fulfilled=true
        // Note: This will not be called if this is a background notification.
        // Background notifications are silent with no badge info.  They trigger a background app fetch.
        // Background notifications still call: application:didReceiveRemoteNotification:fetchCompletionHandler:
        
        OSNotificationPayload *payload = [notification payload];
        NSDictionary *data = [payload additionalData];
        NSLog(@"%@", data);
        
    } handleNotificationAction:^(OSNotificationOpenedResult *result) {
        NSLog(@"Notification Opened");
    } settings:nil];
    
    NSLog(@"Facebook SDK Version:%@", [FBSDKSettings sdkVersion]);
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[AWSMobileClient sharedInstance] didFinishLaunching:application withOptions:launchOptions];
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1 identityPoolId:@"us-east-1:e8fa1784-aca5-4385-a6e9-527a20028d4c"];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    [GMSServices provideAPIKey:@"AIzaSyDabTryjQDThcMgE1x1FrA7uz-kT48tDbg"];
    
    [self setupControllers];
    
    return YES;
}

- (void)setupControllers
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    self.window.backgroundColor = [UIColor clearColor];
    _navigationController = [[DDMNavigationController alloc] initWithRootViewController:[LaunchViewController new]];
    [_navigationController setNavigationBarHidden:YES];
    SettingsViewController *settingsViewController = [SettingsViewController new];
    _revealController = [PKRevealController revealControllerWithFrontViewController:_navigationController leftViewController:settingsViewController];
    [_revealController setMinimumWidth:bounds.size.width * 0.8 maximumWidth:bounds.size.width forViewController:settingsViewController];
    self.window.rootViewController = _revealController;
    [self.window makeKeyAndVisible];
    _revealController.revealPanGestureRecognizer.delegate = _revealController;
    
    [Globals globals];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    return handled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [CoreData save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [LocationsManager requestLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [LocationsManager requestLocation];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received Notification");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Background Notification Received. %@", userInfo);
    
    // After this method is called, the app has 30 seconds to make server requests and then call the following...
    // completionHandler(BACKGROUND_FETCH_RESULT)
    // Possible results are:
    // UIBackgroundFetchResultNewData (for success)
    // UIBackgroundFetchResultNoData (for no update available)
    // UIBackgroundFetchResultFailed (for an error)
    //
    // If you do not call this method then your app will be terminated and may not be reopened when a new notification arrives.
    
    [[User currentUser] syncOrdersWithBlock:^
    {
        completionHandler(UIBackgroundFetchResultNewData);
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [CoreData save];
    
    if([User currentUser])
    {
        [LocationsManager startMonitoringSignificantLocationChanges];
    }
}

@end
