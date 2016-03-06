//
//  ModelValidator.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UserInfoModel;
@class SOSModel;

@interface ModelValidator : NSObject

+ (BOOL)validateUserInfoModel:(UserInfoModel *)model;
+ (BOOL)validateSOSModel:(SOSModel *)model;
+ (BOOL)validateSecretCode:(NSString *)secretCode
               forUserUUID:(NSString *)userUUID;

@end

NS_ASSUME_NONNULL_END