//
//  NetworkCommunicator.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UserInfoModel;
@class SOSModel;

@interface NetworkCommunicator : NSObject <Singleton>

- (void)performRegisterUserRequestWithUserInfo:(UserInfoModel *)userInfo
                               completionBlock:(void (^)(NSString *userUUID, NSError *error))completionBlock;
- (void)performCreateSOSSessionForUserWithUUID:(NSString *)userUUID
                               completionBlock:(void (^)(NSString *SOSUUID, NSError *error))completionBlock;
- (void)performUpdateForSOS:(SOSModel *)SOS
            completionBlock:(void (^)(NSError *error))completionBlock;

@end

NS_ASSUME_NONNULL_END