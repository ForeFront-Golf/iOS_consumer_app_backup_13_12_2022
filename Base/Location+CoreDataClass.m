//
//  Location+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-16.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Location+CoreDataClass.h"
#import "User+CoreDataClass.h"

@implementation Location

- (void)setLatitude:(NSNumber *)latitude
{
    [self willChangeValueForKey:@"latitude"];
    [self setPrimitiveValue:latitude forKey:@"latitude"];
    [self didChangeValueForKey:@"latitude"];
    
    [self.user makeDirty];
}

@end
