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
NSString *LOCATION_LIST_KEY = @"location_list";
NSString *DATE_KEY = @"date";

@implementation SOSModel

#pragma mark -
#pragma mark Public Methods

- (NSDictionary *)toDictionary
{
    NSInteger timestampt = [[NSDate date] timeIntervalSinceReferenceDate];
    return @{LOCATION_LIST_KEY: @[@{DATE_KEY: @(timestampt),
                                    LONGITUDE_DATE_KEY: @(self.longitude),
                                    LATITUDE_ADDRESS_KEY: @(self.latitude)}]};
}

@end
