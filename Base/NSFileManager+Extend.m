//
//  NSFileManager+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "NSFileManager+Extend.h"

@implementation NSFileManager (Extend)

+ (NSString*)pathForDocuments
{
    NSString *documentsDirectory = [self pathForDirectory:NSDocumentDirectory];
    return documentsDirectory;
}

+ (NSString*)pathForDirectory:(NSSearchPathDirectory)directory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

@end
