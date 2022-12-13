//
//  NSPredicate+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2015-01-16.
//  Copyright (c) 2015 DDMAppDesign. All rights reserved.
//

#import "NSPredicate+Extend.h"

@implementation NSPredicate (Extend)

+ (NSPredicate*)predicateWithDictionary:(NSDictionary*)dictionary
{
    NSPredicate *predicate = nil;
    for(NSString *key in dictionary.allKeys)
    {
        id value = dictionary[key];
        NSPredicate *subPredicate = [NSPredicate predicateWithFormat:@"%K = %@",key, value];
        if(predicate)
        {
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, subPredicate]];
        }
        else
        {
            predicate = subPredicate;
        }
    }
    
    return predicate;
}

@end

