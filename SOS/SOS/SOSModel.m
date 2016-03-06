//
//  SOSModel.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "SOSModel.h"

NSString *LONGITUDE_DATE_KEY = @"longitude";
NSString *LATITUDE_ADDRESS_KEY = @"latitude";

@implementation SOSModel

#pragma mark -
#pragma mark Public Methods

- (NSDictionary *)toDictionary
{
    return @{USER_UUID_KEY: self.userUUID,
             SOS_UUID_KEY: self.SOSUUID,
             LONGITUDE_DATE_KEY: @(self.longitude),
             LATITUDE_ADDRESS_KEY: @(self.latitude)};
}

@end
