//
//  UserInfoModel.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject <Serializable>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *birthDate;
@property (nonatomic) NSString *homeAddress;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSString *emergencyContact;
@property (nonatomic) NSString *emergencyNumber;
@property (nonatomic) NSString *secretCode;

@end

NS_ASSUME_NONNULL_END