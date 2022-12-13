//
//  Photo+CoreDataProperties.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2018-03-24.
//  Copyright © 2018 ddmappdesign. All rights reserved.
//
//

#import "Photo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created_at;
@property (nullable, nonatomic, copy) NSDate *mediaUpdatedAt;
@property (nullable, nonatomic, copy) NSString *mediaURL;
@property (nullable, nonatomic, copy) NSString *photo_id;
@property (nonatomic) BOOL readyForDisplay;
@property (nonatomic) int16_t sort_order;
@property (nullable, nonatomic, copy) NSDate *thumbUpdatedAt;
@property (nullable, nonatomic, copy) NSString *thumbURL;
@property (nullable, nonatomic, retain) Club *club;
@property (nullable, nonatomic, retain) Club *clubLogo;
@property (nullable, nonatomic, retain) Facebook_User *facebook_user;
@property (nullable, nonatomic, retain) Menu_Item *menuItem;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
