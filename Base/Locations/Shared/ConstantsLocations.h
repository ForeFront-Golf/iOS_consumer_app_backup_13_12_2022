//
//  ConstantsLocations.h
//  Zimity
//
//  Created by Eddy Douridas on 2017-10-04.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#ifndef ConstantsLocations_h
#define ConstantsLocations_h

////////////////////// General Constants /////////////////////
static CGFloat const kDefaultMinimumAccuracy = 200;
static CGFloat const kDefaultUpdateFrequency = 600;
static NSInteger const kFailedCountMax = 100;

static NSString *const kUserEnteredRegion = @"userEnteredRegion";
static NSString *const kUserExitedRegion = @"userExitedRegion";
static NSString *const kUserLocationUpdated = @"userLocationUpdated";

////////////////////// Includes //////////////////////////
//Frameworks
#import <CoreLocation/CoreLocation.h>

// Classes
#import "LocationsManager.h"

#endif /* ConstantsLocations_h */
