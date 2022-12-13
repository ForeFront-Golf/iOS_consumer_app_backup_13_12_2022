//
//  Course+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-03-24.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Course+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *course_id;
@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *photo_url;
@property (nullable, nonatomic, copy) NSString *photo_url_thumb;
@property (nullable, nonatomic, retain) Club *club;

@end

NS_ASSUME_NONNULL_END
