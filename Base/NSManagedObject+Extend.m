//
//  NSManagedObject+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2015-01-14.
//  Copyright (c) 2015 DDMAppDesign. All rights reserved.
//

#import "NSManagedObject+Extend.h"

@implementation NSManagedObject (Extend)

+ (instancetype)createObject
{
    NSString *className = NSStringFromClass([self class]);
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[CoreData context]];
    return object;
}

+ (instancetype)getObjectWithId:(id)objectId
{
    NSString *objectIdKey = self.objectIdKey;
    id object = [self fetchObjectForPredicate:[NSPredicate predicateWithFormat:@"%K == %@",objectIdKey, objectId]];
    if(!object)
    {
        object = [self createObject];
        [object setValue:objectId forKey:objectIdKey];
    }
    return object;
}

+ (instancetype)getObjectWithDictionary:(NSDictionary*)dictionary;
{
    NSManagedObject *object = [self fetchObjectForPredicate:[NSPredicate predicateWithDictionary:dictionary]];
    if(!object)
    {
        object = [self createObject];
        for(NSString *key in dictionary.allKeys)
        {
            id value = dictionary[key];
            [object setValue:value forKey:key];
        }
    }
    
    return object;
}

+ (NSString*)objectIdKey;
{
    NSString *className = NSStringFromClass([self class]).lowercaseString;
    NSString *objectIdKey = [NSString stringWithFormat:@"%@_id",className];
    return objectIdKey;
}

- (NSString*)objectIdKey;
{
    NSString *objectIdKey = [[self class] objectIdKey];
    return objectIdKey;
}

- (id)objectId
{
    id objectId = [self objectForKey:self.objectIdKey];
    return objectId;
}

- (BOOL)hasKey:(NSString*)key
{
    id value = self.entity.propertiesByName[key];
    BOOL hasKey = value != nil;
    return hasKey;
}

- (id)objectForKey:(NSString*)key
{
    if([self hasKey:key])
    {
        return [self valueForKey:key];
    }
    return nil;
}

- (void)setObject:(id)object forKey:(NSString*)key
{
    if([self hasKey:key])
    {
        return [self setValue:object forKey:key];
    }
}

- (NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *dictionary = [self dictionaryWithValuesForKeys:self.entity.attributesByName.allKeys].mutableCopy;
    id enumerator = ^(NSString *key, NSRelationshipDescription *relationship, BOOL *stop)
    {
        if(!relationship.isToMany)
        {
            NSManagedObject *object = [self valueForKey:key];
            dictionary[object.objectIdKey] = object.objectId;
        }
    };
    [self.entity.relationshipsByName enumerateKeysAndObjectsUsingBlock:enumerator];
    
    return dictionary;
}

- (void)makeDirty
{
    id objectId = self.objectId;
    NSString *objectIdKey = self.objectIdKey;
    [self setValue:objectId forKey:objectIdKey];
}

+ (NSInteger)fetchObjectCountForPredicate:(NSPredicate*)predicate
{
    NSFetchRequest *request = [self createFetchRequestForPredicate:predicate sortedBy:nil];
    NSError *error = nil;
    NSInteger count = [[CoreData context] countForFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:@"%@",[error description]];
    }
    return count;
}

+ (instancetype)fetchObjectWithId:(id)objectId
{
    NSString *objectIdKey = self.objectIdKey;
    id object = [self fetchObjectForPredicate:[NSPredicate predicateWithFormat:@"%K == %@",objectIdKey, objectId]];
    return object;
}

+ (instancetype)fetchObjectForPredicate:(NSPredicate*)predicate
{
    return [self fetchObjectsForPredicate:predicate sortedBy:nil].firstObject;
}

+ (NSArray*)fetchObjectsForPredicate:(NSPredicate*)predicate
{
    return [self fetchObjectsForPredicate:predicate sortedBy:nil];
}

+ (NSArray*)fetchObjectsForPredicate:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors
{
    NSFetchRequest *request = [self createFetchRequestForPredicate:predicate sortedBy:sortDescriptors];
    NSError *error = nil;
    NSArray *results = [[CoreData context] executeFetchRequest:request error:&error];
    if(error != nil)
    {
        [NSException raise:NSGenericException format:@"%@",[error description]];
    }
    return results;
}

+ (NSFetchRequest*)createFetchRequestForPredicate:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors
{
    NSString *className = NSStringFromClass([self class]);
    NSEntityDescription *newEntity = [NSEntityDescription entityForName:className inManagedObjectContext:[CoreData context]];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:newEntity];
    
    if (predicate)
    {
        [request setPredicate:predicate];
    }
    
    if(sortDescriptors)
    {
        [request setSortDescriptors:sortDescriptors];
    }
    
    return request;
}

- (void)deleteObject
{
    [[NSFileManager defaultManager] removeItemAtPath:[self getPathForKey:kThumbnail] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[self getPathForKey:kMedia] error:nil];
    
    [[CoreData context] deleteObject:self];
}

+ (NSString*)getURLForObjectId:(NSNumber*)objectId
{
    NSString *objectIdString = objectId ? [NSString stringWithFormat:@"/%@",objectId] : @"";
    NSString *url = [NSString stringWithFormat:@"%@/%@%@", kServerURL, NSStringFromClass(self).lowercaseString,objectIdString];
    return url;
}

+ (NSString*)postURLForObjectId:(NSNumber*)objectId
{
    NSString *url = [self getURLForObjectId:objectId];
    return url;
}

+ (NSDictionary*)processResponse:(NSDictionary *)response
{
    NSString *className = NSStringFromClass(self);
    id data = response[className];
    if(data && data != [NSNull null])
    {
        return data;
    }
    
    className = [NSString stringWithFormat:@"%@s",className];
    data = response[className];
    if(data && data != [NSNull null])
    {
        return data;
    }
    
    return nil;
}


+ (bool)processError:(NSInteger)statusCode
{
    if(statusCode == kInvalidAccountError)
    {
        [Globals logout];
        return true;
    }
    else if(statusCode == kDisabledAccountError)
    {
        [UIAlertController showWithTitle:nil message:@"This account has been banned." actions:nil preferredStyle:UIAlertControllerStyleAlert];
        [CoreData deleteAllObjects];
        [Globals logout];
        return true;
    }
    return false;
}

// Networking Functionality
///////////////////////////////////////////////////////////////////////////////
+ (NSDate*)getLastUpdatedAt
{
    NSManagedObject *object = [self fetchObjectsForPredicate:nil sortedBy:@[[[NSSortDescriptor alloc] initWithKey:@"modified_at" ascending:NO selector:nil]]].firstObject;
    
    NSDate *lastUpdatedAtDate = [object valueForKey:@"modified_at"];
    return lastUpdatedAtDate ? lastUpdatedAtDate : [NSDate dateWithTimeIntervalSince1970:0];
}

+ (id)serializeFrom:(NSDictionary*)data
{
    if(!data)
    {
        return nil;
    }
    
    NSString *className = NSStringFromClass(self);
    NSDictionary *subData = [data objectForKey:className];
    if(subData)
    {
        data = subData;
    }
    
    NSString *objectIdKey = self.objectIdKey;
    id objectId = data[objectIdKey];
    NSManagedObject *object = [self getObjectWithId:objectId];
    [object serializeFrom:data];
    return object;
}

- (void)serializeFrom:(NSDictionary*)data
{
    if(!data)
    {
        return;
    }
    
    for(NSString *key in self.entity.attributesByName.allKeys)
    {
        id value = data[key];
        if(value == nil)    //key not present, ignore
        {
            continue;
        }
        if(value == [NSNull null])
        {
            value = nil;
        }
        
        [self setObject:value forKey:key];
    }
    
    for(NSString *key in self.entity.relationshipsByName.allKeys)
    {
        NSString *ptrKey = [NSString stringWithFormat:@"%@_id",key];
        NSRelationshipDescription *description = self.entity.relationshipsByName[key];
        NSString *className = description.destinationEntity.managedObjectClassName;
        NSString *relatedKey = description.isToMany ? key : className;
        NSDictionary *relatedData = data[relatedKey];
        Class class = NSClassFromString(className);
        if(!relatedData)
        {
            id ptrValue = data[ptrKey];
            if(ptrValue && ptrValue != [NSNull null])
            {
                if([[[class entity].attributesByName[ptrKey] attributeValueClassName] isEqualToString:@"NSNumber"])
                {
                    NSString *ptrStringValue = ptrValue;
                    ptrValue = @(ptrStringValue.integerValue);
                }
                NSString *ptrKeyStripped = [ptrKey stringByReplacingOccurrencesOfString:@"[0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, ptrKey.length)];
                relatedData = @{ptrKeyStripped:ptrValue};
            }
        }
        
        if(relatedData)
        {
            if(description.isToMany)
            {
                NSMutableSet *relatedObjects = [self valueForKey:key];
                relatedObjects = relatedObjects.mutableCopy;
                for(NSDictionary *relatedDictionary in relatedData)
                {
                    NSManagedObject *relatedObject = [class serializeFrom:relatedDictionary];
                    [relatedObjects addObject:relatedObject];
                }
                [self setValue:relatedObjects forKey:key];
            }
            else
            {
                NSManagedObject *relatedObject = [class serializeFrom:relatedData];
                [self setValue:relatedObject forKey:key];
            }
        }
    }
}

- (NSString*)getNameForKey:(NSString*)key
{
    NSString *className = NSStringFromClass([self class]);
    NSString *objectId = self.objectId;
    NSString *name;
    if([self objectForKey:@"club"])
    {
        name = [NSString stringWithFormat:@"%@.jpg",objectId];
    }
    else if([self objectForKey:@"clubLogo"])
    {
        name = [NSString stringWithFormat:@"%@.png",objectId];
    }
    else if([self objectForKey:@"menuItem"])
    {
        if(key == kThumbnail)
        {
            name = [NSString stringWithFormat:@"%@_%@.jpg",objectId,key];
        }
        else
        {
            name = [NSString stringWithFormat:@"%@.jpg",objectId];
        }
    }
    else if(key == kThumbnail)
    {
        name = [NSString stringWithFormat:@"%@_%@_%@.jpg",className, objectId, key];
    }
    else
    {
        name = [NSString stringWithFormat:@"%@_%@.jpg",className, objectId];
    }
    return name;
}

- (NSString*)getPathForKey:(NSString*)key
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[NSFileManager pathForDocuments], [self getNameForKey:key]];
    return path;
}

- (NSURL*)getURLForKey:(NSString*)key
{
    NSURL *url = [NSURL fileURLWithPath:[self getPathForKey:key]];
    return url;
}

- (NSString*)getAWSPathForKey:(NSString*)key
{
    NSString *awsKey;
    User *user = [self objectForKey:@"user"];
    Club *club = [self objectForKey:@"club"];
    Club *clubLogo = [self objectForKey:@"clubLogo"];
    Menu_Item *menuItem = [self objectForKey:@"menuItem"];
    if(user)
    {
        awsKey = user.profile_photo_url;
        if(!awsKey)
        {
            awsKey = [NSString stringWithFormat:@"public/user/%@/profile.jpg",user.user_id];
        }
    }
    else if(club)
    {
        awsKey = club.photo_url;
    }
    else if(clubLogo)
    {
        awsKey = clubLogo.photo_url_thumb;
    }
    else if(menuItem)
    {
        awsKey = menuItem.photo_url;
    }
    return awsKey;
}

- (BOOL)hasDataForKey:(NSString*)key
{
    bool exists = [[NSFileManager defaultManager] fileExistsAtPath:[self getPathForKey:key]];
    return exists;
}

- (NSData*)getDataForKey:(NSString *)key
{
    NSData *data = [NSData dataWithContentsOfURL:[self getURLForKey:key]];
    return data;
}

- (void)fetchDataForKey:(NSString *)key
{
    Photo *photo = [self objectForKey:@"photo"];
    if(photo)
    {
        [photo fetchDataForKey:key withBlock:^(){}];
    }
    else
    {
        [self fetchDataForKey:key withBlock:^(){}];
    }
}

- (void)fetchDataForKey:(NSString*)key withBlock:(void (^)(void))block;
{
    NSString *fileName = [self getNameForKey:key];
    [[DDMDownloadManager manager] downloadFile:fileName forObject:self forKey:key withBlock:block];
}

- (void)saveData:(NSData*)data forKey:(NSString*)fileKey
{
    NSString *fileUpdatedAtKey = [NSString stringWithFormat:@"%@UpdatedAt",fileKey];
    if(data)
    {
        if([data writeToFile:[self getPathForKey:fileKey] atomically:YES])
        {
            [self setObject:[NSDate date] forKey:fileUpdatedAtKey];
        }
        else
        {
            [self setObject:nil forKey:fileUpdatedAtKey];
            NSLog(@"Error: Could not %@ data for objectId = %@",fileKey, self.objectId);
        }
    }
    else
    {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[self getPathForKey:fileKey] error: &error];
        [self setObject:[NSDate date] forKey:fileUpdatedAtKey];
    }
}

- (UIImage*)getImageForKey:(NSString*)key
{
    NSManagedObject *photo = [self objectForKey:@"photo"];
    if(!photo)
    {
        photo = self;
    }
    
    NSData *data = [photo getDataForKey:key];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (UIImage*)getBestImage
{
    UIImage *image = [self getImageForKey:kMedia];
    if(!image)
    {
        image = [self getImageForKey:kThumbnail];
    }
    return image;
}

@end
