//
//  NetworkCommunicator.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "NetworkCommunicator.h"
#import "UserInfoModel.h"
#import "SOSModel.h"

NSInteger RESPONSE_STATUS_CODE_SUCCESS = 200;

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
    NSDictionary *attributes = [userInfo toDictionary];
 
    NSLog(@"Perform register user request with attributes: %@.", attributes);
    
    NSError *error;
    NSData *payload = [NSJSONSerialization dataWithJSONObject:attributes
                                                      options:0
                                                        error:&error];
    
    if (payload) {
        NSString *URLString = [NSString stringWithFormat:@"%@%@",
                               SOS_WEB_SERVER_BASE_URL,
                               SOS_WEB_SERVER_PATH_USER];
        
        NSURL *URL = [NSURL URLWithString:URLString];
        NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
        URLRequest.HTTPMethod = @"POST";
        URLRequest.HTTPBody = payload;
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
         {
             NSLog(@"Did finish register user request with response: %@, data: %@, error: %@.", response,
                   data, error);
             
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
        [task resume];
    }
    else if (completionBlock) {
        completionBlock(nil, error);
    }
}

- (void)performCreateSOSSessionForUserWithUUID:(NSString *)userUUID
                               completionBlock:(void (^)(NSString *SOSUUID, NSError *error))completionBlock
{
    NSDictionary *attributes = @{USER_UUID_KEY: userUUID};
    
    NSLog(@"Perform create SOS session with attributes: %@", attributes);
    
    NSError *error;
    NSData *payload = [NSJSONSerialization dataWithJSONObject:attributes
                                                      options:0
                                                        error:&error];
    
    if (payload) {
        NSString *URLString = [NSString stringWithFormat:@"%@%@",
                               SOS_WEB_SERVER_BASE_URL,
                               SOS_WEB_SERVER_PATH_SOS];
        
        NSURL *URL = [NSURL URLWithString:URLString];
        NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
        URLRequest.HTTPMethod = @"POST";
        URLRequest.HTTPBody = payload;
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      
        {
                                          NSLog(@"Did finish create SOS session with response: %@, data: %@, error: %@", response, data, error);
                                          
                                          NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                          NSString *sosUUID;
                                          
                                          if (    HTTPResponse.statusCode == RESPONSE_STATUS_CODE_SUCCESS
                                              &&  data)
                                          {
                                              NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:0
                                                                                                               error:&error];
                                              if (parsedResponse) {
                                                  sosUUID = [parsedResponse objectForKey:SOS_UUID_KEY];
                                              }
                                          }
                                          
                                          if (completionBlock) {
                                              completionBlock(sosUUID, error);
                                          }
                                      }];
        [task resume];
    }
    else if (completionBlock) {
        completionBlock(nil, error);
    }
}

- (void)performUpdateForSOS:(SOSModel *)SOS
            completionBlock:(void (^)(NSError *error))completionBlock
{
    NSDictionary *attributes = [SOS toDictionary];
    
    NSLog(@"Perform update SOS request with attributes: %@", attributes);
    
    NSError *error;
    NSData *payload = [NSJSONSerialization dataWithJSONObject:attributes
                                                      options:0
                                                        error:&error];
    
    if (payload) {
        NSString *URLString = [NSString stringWithFormat:@"%@%@%@",
                               SOS_WEB_SERVER_BASE_URL,
                               SOS_WEB_SERVER_PATH_SOS,
                               SOS.SOSUUID];
        
        NSURL *URL = [NSURL URLWithString:URLString];
        NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
        URLRequest.HTTPMethod = @"POST";
        URLRequest.HTTPBody = payload;
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      {
                                          NSLog(@"Did finish update SOS request with response: %@, data: %@, error: %@", response, data, error);
                                          
                                          if (completionBlock) {
                                              completionBlock(error);
                                          }
                                      }];
        [task resume];
    }
    else if (completionBlock) {
        completionBlock(error);
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
