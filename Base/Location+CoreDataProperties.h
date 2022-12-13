//
//  Location+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-08-22.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Location+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSNumber *latitude;
@property (nullable, nonatomic, copy) NSNumber *location_id;
@property (nullable, nonatomic, copy) NSNumber *longitude;
@property (nullable, nonatomic, copy) NSNumber *v_accuracy;
@property (nullable, nonatomic, copy) NSNumber *h_accuracy;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
