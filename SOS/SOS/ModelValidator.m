//
//  ModelValidator.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "ModelValidator.h"

@implementation ModelValidator

+ (BOOL)validateUserInfoModel:(UserInfoModel *)model
{
    BOOL returnValue = NO;
    
    if (model) {
#warning NO VALIDATION
        returnValue = YES;
    }
    
    return returnValue;
}

@end
