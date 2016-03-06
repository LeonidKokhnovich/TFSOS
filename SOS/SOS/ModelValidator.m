//
//  ModelValidator.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "ModelValidator.h"
#import "SOSModel.h"
#import "UserInfoModel.h"
#import "AppStorage.h"

@implementation ModelValidator


#pragma mark -
#pragma mark Public Methods

+ (BOOL)validateUserInfoModel:(UserInfoModel *)model
{
    BOOL returnValue = NO;
    
    if (    model
        &&  [self validateName:model.firstName]
        &&  [self validateName:model.lastName]
        &&  [self validateBirthDate:model.birthDate]
        &&  [self validateBasicStringParameter:model.homeAddress]
        &&  [self validatePhoneNumber:model.phoneNumber]
        &&  [self validateName:model.emergencyContact]
        &&  [self validatePhoneNumber:model.emergencyNumber]
        &&  [self validateBasicStringParameter:model.secretCode])
    {
        returnValue = YES;
    }
    
    return returnValue;
}

+ (BOOL)validateName:(NSString *)input
{
    BOOL returnValue = NO;
    
    if (input) {
        NSString *regex = @"^[A-Za-z ,.'-]+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        returnValue = [predicate evaluateWithObject:input];
    }
    
    return returnValue;
}

+ (BOOL)validateBirthDate:(NSNumber *)birthDateNumber
{
    BOOL returnValue = NO;
    
    NSString *stringRepresentation = [NSString stringWithFormat:@"%@", birthDateNumber];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *birthDate = [format dateFromString:stringRepresentation];
    
    if (    birthDate
        &&  [birthDate timeIntervalSinceNow] < 0)
    {
        returnValue = YES;
    }
    
    return returnValue;
}

+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber
{
    BOOL returnValue = NO;
    
    if (phoneNumber) {
        NSString *phoneRegex = @"^([0-9]{3}.){2}[0-9]{4}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        returnValue = [predicate evaluateWithObject:phoneNumber];
    }
    
    return returnValue;
}

+ (BOOL)validateSOSModel:(SOSModel *)model
{
    BOOL returnValue = NO;
    
    if (    model
        &&  [self validateBasicStringParameter:model.userUUID]
        &&  [self validateBasicStringParameter:model.SOSUUID])
    {
        returnValue = YES;
    }
    
    return returnValue;
}

+ (BOOL)validateSecretCode:(NSString *)secretCode
               forUserUUID:(NSString *)userUUID
{
    BOOL returnValue = NO;
    
    NSString *secretCodeHash = [secretCode.lowercaseString MD5String];
    NSString *secretCodeHashSample = [[AppStorage sharedInstance] secretCodeHashForUserUUID:userUUID];
    
    if ([secretCodeHash isEqualToString:secretCodeHashSample]) {
        returnValue = YES;
    }
    
    return returnValue;
}


#pragma mark -
#pragma mark Helper Methods

+ (BOOL)validateBasicStringParameter:(NSString *)parameter
{
    return (    parameter
            &&  [parameter isEqualToString:@""] == NO);
}

@end
