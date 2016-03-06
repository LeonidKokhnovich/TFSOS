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
        &&  [self validateBasicStringParameter:model.firstName]
        &&  [self validateBasicStringParameter:model.lastName]
        &&  [self validateBasicStringParameter:model.birthDate]
        &&  [self validateBasicStringParameter:model.homeAddress]
        &&  [self validateBasicStringParameter:model.phoneNumber]
        &&  [self validateBasicStringParameter:model.emergencyContact]
        &&  [self validateBasicStringParameter:model.emergencyNumber]
        &&  [self validateBasicStringParameter:model.secretCode])
    {
        returnValue = YES;
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
