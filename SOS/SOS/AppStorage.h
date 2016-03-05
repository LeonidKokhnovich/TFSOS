//
//  AppStorage.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppStorage : NSObject <Singleton>

- (void)saveUserUUID:(NSString * _Nullable)userUUID;
- (NSString * _Nullable)userUUID;

@end

NS_ASSUME_NONNULL_END