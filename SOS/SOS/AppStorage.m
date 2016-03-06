//
//  AppStorage.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "AppStorage.h"

NSString *CURRENT_USER_UUID_KEY = @"CURRENT_USER_UUID_KEY";
NSString *SECRET_CODE_HASH_PREFIX_KEY = @"SECRET_CODE_HASH";

@implementation AppStorage

#pragma mark -
#pragma mark Static Methods

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


#pragma mark -
#pragma mark Public Methods

- (void)saveUserUUID:(NSString *)userUUID
{
    [[NSUserDefaults standardUserDefaults] setObject:userUUID
                                              forKey:CURRENT_USER_UUID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userUUID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_USER_UUID_KEY];
}

- (void)saveSecretCodeHash:(NSString *)secretCodeHash
               forUserUUID:(NSString *)userUUID
{
    NSString *key = [self secretCodeHashKeyForUserUUID:userUUID];
    [[NSUserDefaults standardUserDefaults] setObject:secretCodeHash
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString * _Nullable)secretCodeHashForUserUUID:(NSString *)userUUID
{
    NSString *key = [self secretCodeHashKeyForUserUUID:userUUID];
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}


#pragma mark -
#pragma mark Helper Methods

- (NSString *)secretCodeHashKeyForUserUUID:(NSString *)userUUID
{
    return [NSString stringWithFormat:@"%@_%@", SECRET_CODE_HASH_PREFIX_KEY, userUUID];
}


@end
