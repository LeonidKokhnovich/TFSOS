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
NSInteger RESPONSE_STATUS_CODE_CREATE_SUCCEED = 201;

NSString *CONTENT_TYPE_KEY = @"Content-Type";
NSString *JSON_CONTENT_TYPE = @"application/json";

NSString *CREATE_USER_REQUEST_LABEL = @"register user";
NSString *CREATE_SOS_SESSION_REQUEST_LABEL = @"create SOS session";
NSString *UPDATE_SOS_SESSION_DATA_REQUEST_LABEL = @"update SOS session data";
NSString *UPDATE_SOS_SESSION_STATUS_REQUEST_LABEL = @"update SOS session status";
NSString *RETRIEVE_SOS_SESSION_INFO_REQUEST_LABEL = @"retrieve SOS session info";

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
#pragma mark Public Methods

- (void)performRegisterUserRequestWithUserInfo:(UserInfoModel *)userInfo
                               completionBlock:(void (^)(NSString *userUUID, NSError *error))completionBlock
{
    NSDictionary *attributes = [userInfo toDictionary];
    
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
        [URLRequest setValue:JSON_CONTENT_TYPE forHTTPHeaderField:CONTENT_TYPE_KEY];
        URLRequest.HTTPBody = payload;
        
        NSLog(@"%@", [self messageForRequestWithLabel:CREATE_USER_REQUEST_LABEL
                                           URLRequest:URLRequest]);
        
        weakify(self);
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      {
                                          strongify(self);
                                          NSLog(@"%@", [self messageForCompletedDataTaskWithLabel:CREATE_USER_REQUEST_LABEL
                                                                                             data:data
                                                                                         response:response
                                                                                            error:error]);
                                          
                                          NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                          NSString *userUUID;
                                          
                                          if (    HTTPResponse.statusCode == RESPONSE_STATUS_CODE_CREATE_SUCCEED
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
        [URLRequest setValue:JSON_CONTENT_TYPE forHTTPHeaderField:CONTENT_TYPE_KEY];
        URLRequest.HTTPBody = payload;
        
        NSLog(@"%@", [self messageForRequestWithLabel:CREATE_SOS_SESSION_REQUEST_LABEL
                                           URLRequest:URLRequest]);
        weakify(self);
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      
                                      {
                                          strongify(self);
                                          NSLog(@"%@", [self messageForCompletedDataTaskWithLabel:CREATE_SOS_SESSION_REQUEST_LABEL
                                                                                             data:data
                                                                                         response:response
                                                                                            error:error]);
                                          
                                          NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                          NSString *sosUUID;
                                          
                                          if (    HTTPResponse.statusCode == RESPONSE_STATUS_CODE_CREATE_SUCCEED
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
        [URLRequest setValue:JSON_CONTENT_TYPE forHTTPHeaderField:CONTENT_TYPE_KEY];
        URLRequest.HTTPBody = payload;
        
        NSLog(@"%@", [self messageForRequestWithLabel:UPDATE_SOS_SESSION_DATA_REQUEST_LABEL
                                           URLRequest:URLRequest]);
        
        weakify(self);
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      {
                                          strongify(self);
                                          NSLog(@"%@", [self messageForCompletedDataTaskWithLabel:UPDATE_SOS_SESSION_DATA_REQUEST_LABEL
                                                                                             data:data
                                                                                         response:response
                                                                                            error:error]);
                                          
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

- (void)performSOSStatusUpdate:(SOS_STATUS)SOSStatus
                       SOSUUID:(NSString *)SOSUUID
               completionBlock:(void (^)(NSError *error))completionBlock
{
    NSDictionary *attributes = @{SOS_UUID_KEY: SOSUUID,
                                 SOS_STATUS_KEY: @(SOSStatus)};
    NSError *error;
    NSData *payload = [NSJSONSerialization dataWithJSONObject:attributes
                                                      options:0
                                                        error:&error];
    
    if (payload) {
        NSString *URLString = [NSString stringWithFormat:@"%@%@",
                               SOS_WEB_SERVER_BASE_URL,
                               SOS_WEB_SERVER_PATH_SOS_STATUS];
        
        NSURL *URL = [NSURL URLWithString:URLString];
        NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
        URLRequest.HTTPMethod = @"POST";
        [URLRequest setValue:JSON_CONTENT_TYPE forHTTPHeaderField:CONTENT_TYPE_KEY];
        URLRequest.HTTPBody = payload;
        
        NSLog(@"%@", [self messageForRequestWithLabel:UPDATE_SOS_SESSION_STATUS_REQUEST_LABEL
                                           URLRequest:URLRequest]);
        weakify(self);
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      
                                      {
                                          strongify(self);
                                          NSLog(@"%@", [self messageForCompletedDataTaskWithLabel:UPDATE_SOS_SESSION_STATUS_REQUEST_LABEL
                                                                                             data:data
                                                                                         response:response
                                                                                            error:error]);
                                          
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

- (void)retrieveStatusForSOSWithUUID:(NSString *)SOSUUID
                     completionBlock:(void (^)(SOS_STATUS status, NSError *error))completionBlock
{
    NSLog(@"Perform SOS status querying for SOS session with UUID: %@", SOSUUID);
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@",
                           SOS_WEB_SERVER_BASE_URL,
                           SOS_WEB_SERVER_PATH_SOS,
                           SOSUUID];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    
    NSLog(@"%@", [self messageForRequestWithLabel:RETRIEVE_SOS_SESSION_INFO_REQUEST_LABEL
                                       URLRequest:URLRequest]);
    weakify(self);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:URLRequest
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  
                                  {
                                      strongify(self);
                                      NSLog(@"%@", [self messageForCompletedDataTaskWithLabel:RETRIEVE_SOS_SESSION_INFO_REQUEST_LABEL
                                                                                         data:data
                                                                                     response:response
                                                                                        error:error]);
                                      
                                      NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                                      SOS_STATUS status = SOS_STATUS_UNKNOWN;
                                      
                                      if (    HTTPResponse.statusCode == RESPONSE_STATUS_CODE_SUCCESS
                                          &&  data)
                                      {
                                          NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:0
                                                                                                           error:&error];
                                          if (parsedResponse) {
                                              status = [[parsedResponse objectForKey:SOS_STATUS_KEY] unsignedIntegerValue];
                                          }
                                      }
                                      
                                      if (completionBlock) {
                                          completionBlock(status, error);
                                      }
                                  }];
    [task resume];
}


#pragma mark -
#pragma mark Helper Methods

- (NSString *)messageForRequestWithLabel:(NSString *)title URLRequest:(NSURLRequest *)URLRequest
{
    return [NSString stringWithFormat:@"Start %@ task\nurl request: %@", title, URLRequest];
}

- (NSString *)messageForCompletedDataTaskWithLabel:(NSString *)title data:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error
{
    return [NSString stringWithFormat:@"Did finish %@ task\ndata: %@\nresponse: %@\nerror: %@", title, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], response, error];
}


@end
