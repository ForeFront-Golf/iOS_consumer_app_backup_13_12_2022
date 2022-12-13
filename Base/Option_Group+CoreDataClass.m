//
//  Option_Group+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-10.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Option_Group+CoreDataClass.h"
#import "Menu_Item+CoreDataClass.h"
#import "Option_Item+CoreDataClass.h"
@implementation Option_Group

- (bool)isSingleOption
{
    return [self.option_type isEqualToString:@"SINGLE_OPTION"];
}

@end
