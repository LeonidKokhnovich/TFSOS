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

@interface NetworkCommunicator : NSObject <Singleton>

- (void)performRegisterUserRequestWithUserInfo:(UserInfoModel *)userInfo
                               completionBlock:(void (^)(NSString *userUUID, NSError *error))completionBlock;

@end

NS_ASSUME_NONNULL_END