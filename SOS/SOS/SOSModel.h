//
//  SOSModel.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SOSModel : NSObject <Serializable>

@property (nonatomic) NSString *userUUID;
@property (nonatomic) NSString *SOSUUID;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;

@end

NS_ASSUME_NONNULL_END