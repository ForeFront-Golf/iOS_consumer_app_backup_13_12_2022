//
//  NSPredicate+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2015-01-16.
//  Copyright (c) 2015 DDMAppDesign. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kEqual = @"eqaul";
static NSString *const kContains = @"contains";

@interface NSPredicate (Extend)

+ (NSPredicate*)predicateWithDictionary:(NSDictionary*)dictionary;

@end
