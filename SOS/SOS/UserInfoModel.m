//
//  UserInfoModel.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "UserInfoModel.h"

NSString *FIRST_NAME_KEY = @"first_name";
NSString *LAST_NAME_KEY = @"last_name";
NSString *BIRTH_DATE_KEY = @"dob";
NSString *HOME_ADDRESS_KEY = @"address_home";
NSString *PHONE_NUMBER_KEY = @"phone_number";
NSString *EMERGENCY_CONTACT_KEY = @"emergency_contact";
NSString *EMERGENCY_PHONE_KEY = @"emergency_phone";
NSString *SECRET_CODE_KEY = @"secret_code";

@implementation UserInfoModel

#pragma mark -
#pragma mark Public Methods

- (NSDictionary *)toDictionary
{
    return @{FIRST_NAME_KEY: self.firstName,
             LAST_NAME_KEY: self.lastName,
             BIRTH_DATE_KEY: self.birthDate,
             HOME_ADDRESS_KEY: self.homeAddress,
             PHONE_NUMBER_KEY: self.phoneNumber,
             EMERGENCY_CONTACT_KEY: self.emergencyContact,
             EMERGENCY_PHONE_KEY: self.emergencyNumber,
             SECRET_CODE_KEY: self.secretCode};
}

@end
