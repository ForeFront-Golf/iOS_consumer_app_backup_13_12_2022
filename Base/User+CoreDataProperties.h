//
//  User+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-04-06.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *banned;
@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nonatomic) BOOL current;
@property (nullable, nonatomic, copy) NSString *dob;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *first_name;
@property (nonatomic) BOOL knownClubStatus;
@property (nullable, nonatomic, copy) NSString *last_name;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *phone_number;
@property (nullable, nonatomic, copy) NSNumber *phone_valid;
@property (nullable, nonatomic, copy) NSString *profile_photo_url;
@property (nullable, nonatomic, copy) NSNumber *rating;
@property (nullable, nonatomic, copy) NSString *session_id;
@property (nullable, nonatomic, copy) NSNumber *signup_complete;
@property (nullable, nonatomic, copy) NSNumber *user_id;
@property (nullable, nonatomic, copy) NSNumber *valid;
@property (nonatomic) BOOL membership_complete;
@property (nullable, nonatomic, retain) Club *club;
@property (nullable, nonatomic, retain) Facebook_User *facebook_user;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) NSSet<Order *> *orders;
@property (nullable, nonatomic, retain) Photo *photo;
@property (nullable, nonatomic, retain) NSSet<Membership *> *memberships;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet<Order *> *)values;
- (void)removeOrders:(NSSet<Order *> *)values;

- (void)addMembershipsObject:(Membership *)value;
- (void)removeMembershipsObject:(Membership *)value;
- (void)addMemberships:(NSSet<Membership *> *)values;
- (void)removeMemberships:(NSSet<Membership *> *)values;

@end

NS_ASSUME_NONNULL_END
