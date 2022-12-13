//
//  CourseCell.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-03-27.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "CourseCell.h"

@implementation CourseCell

- (void)setupTableView:(UITableView *)tableView withObject:(id)object forOwner:(id)owner
{
    _club = object;
    _nameLabel.text = _club.name;

//    User *currentUser = [User currentUser];
//    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentUser.location.latitude.doubleValue longitude:currentUser.location.longitude.doubleValue];
//    CLLocation *clubLocation = [[CLLocation alloc] initWithLatitude:_club.lat.doubleValue longitude:_club.lon.doubleValue];
//    CLLocationDistance distance = [currentLocation distanceFromLocation:clubLocation] / 1000.f;
    _distanceLabel.text = [NSString stringWithFormat:@"%.1f km",_club.distance];
}

- (IBAction)callButtonPressed
{
    NSString *phoneNumber = [[_club.phone_number componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"() -"]] componentsJoinedByString: @""];
    NSURL *phoneNumberURL = [NSURL URLWithString:[@"tel://" stringByAppendingString:phoneNumber]];
    [[UIApplication sharedApplication] openURL:phoneNumberURL options:@{} completionHandler:^(BOOL success) {}];
}

- (IBAction)directionButtonPressed
{
    NSURL *directionURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@,%@",_club.lat,_club.lon]];
    [[UIApplication sharedApplication] openURL:directionURL options:@{} completionHandler:^(BOOL success) {}];
}

@end
