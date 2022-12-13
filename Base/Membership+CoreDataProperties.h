//
//  Membership+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-02.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Membership+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Membership (CoreDataProperties)

+ (NSFetchRequest<Membership *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *first_name;
@property (nullable, nonatomic, copy) NSString *last_name;
@property (nullable, nonatomic, copy) NSString *member_code;
@property (nullable, nonatomic, copy) NSNumber *membership_id;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *phone_number;
@property (nullable, nonatomic, copy) NSNumber *valid;
@property (nullable, nonatomic, retain) Club *club;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
