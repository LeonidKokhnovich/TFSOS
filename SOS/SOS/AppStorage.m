//
//  AppStorage.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "AppStorage.h"

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
#pragma mark Life Circle

#pragma mark -
#pragma mark Public Methods

- (void)saveUserUUID:(NSString *)userUUID
{
    
}

- (NSString *)userUUID
{
    return nil;
}



#pragma mark -
#pragma mark Helper Methods

@end
