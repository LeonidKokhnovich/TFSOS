//
//  NetworkCommunicator.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "NetworkCommunicator.h"
#import "UserInfoModel.h"

NSInteger RESPONSE_STATUS_CODE_SUCCESS = 200;
NSString *USER_UUID_KEY = @"user_uuid";

@implementation NetworkCommunicator

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
#pragma mark User Actions

#pragma mark -
#pragma mark Public Methods

- (void)performRegisterUserRequestWithUserInfo:(UserInfoModel *)userInfo
                               completionBlock:(void (^)(NSString *userUUID, NSError *error))completionBlock
{
    NSDictionary *modelDictionary = [userInfo toDictionary];
    
    NSError *error;
    NSData *payload = [NSJSONSerialization dataWithJSONObject:modelDictionary
                                                      options:0
                                                        error:&error];
    
    if (payload) {
        NSString *URLString = [NSString stringWithFormat:@"%@%@",
                               SOS_WEB_SERVER_BASE_URL,
                               SOS_WEB_SERVER_REGISTER_NEW_USER_PATH];
        
        NSURL *URL = [NSURL URLWithString:URLString];
        NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
        URLRequest.HTTPMethod = @"POST";
        URLRequest.HTTPBody = payload;
        
        [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
         {
             NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
             NSString *userUUID;
             
             if (    HTTPResponse.statusCode == RESPONSE_STATUS_CODE_SUCCESS
                 &&  data)
             {
                 NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:0
                                                                                  error:&error];
                 if (parsedResponse) {
                     userUUID = [parsedResponse objectForKey:USER_UUID_KEY];
                 }
             }
             
             if (completionBlock) {
                 completionBlock(userUUID, error);
             }
         }];
    }
    else if (completionBlock) {
        completionBlock(nil, error);
    }
}


#pragma mark -
#pragma mark Accessories

#pragma mark -
#pragma mark Helper Methods

#pragma mark -
#pragma mark Delegate Methods

#pragma mark -
#pragma mark Notifications Handling Methods

@end
