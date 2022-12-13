//
//  Club+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Chenyao Yang on 2018-05-16.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Club+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Club (CoreDataProperties)

+ (NSFetchRequest<Club *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSNumber *club_id;
@property (nullable, nonatomic, copy) NSNumber *created_at;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nonatomic) double distance;
@property (nullable, nonatomic, copy) NSNumber *lat;
@property (nullable, nonatomic, copy) NSNumber *lon;
@property (nullable, nonatomic, copy) NSNumber *modified_at;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phone_number;
@property (nullable, nonatomic, copy) NSString *photo_url;
@property (nullable, nonatomic, copy) NSString *photo_url_thumb;
@property (nullable, nonatomic, copy) NSNumber *private;
@property (nullable, nonatomic, copy) NSNumber *valid;
@property (nonatomic) float tax_rate;
@property (nonatomic) BOOL show_tax;
@property (nullable, nonatomic, retain) NSSet<Course *> *courses;
@property (nullable, nonatomic, retain) Photo *logoPhoto;
@property (nullable, nonatomic, retain) NSSet<Membership *> *memberships;
@property (nullable, nonatomic, retain) NSSet<Menu *> *menus;
@property (nullable, nonatomic, retain) NSSet<Order *> *orders;
@property (nullable, nonatomic, retain) Photo *photo;
@property (nullable, nonatomic, retain) NSSet<User *> *users;

@end

@interface Club (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet<Course *> *)values;
- (void)removeCourses:(NSSet<Course *> *)values;

- (void)addMembershipsObject:(Membership *)value;
- (void)removeMembershipsObject:(Membership *)value;
- (void)addMemberships:(NSSet<Membership *> *)values;
- (void)removeMemberships:(NSSet<Membership *> *)values;

- (void)addMenusObject:(Menu *)value;
- (void)removeMenusObject:(Menu *)value;
- (void)addMenus:(NSSet<Menu *> *)values;
- (void)removeMenus:(NSSet<Menu *> *)values;

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet<Order *> *)values;
- (void)removeOrders:(NSSet<Order *> *)values;

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet<User *> *)values;
- (void)removeUsers:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
