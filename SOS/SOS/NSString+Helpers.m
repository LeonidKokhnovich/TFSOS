//
//  NSString+Helpers.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "NSString+Helpers.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Helpers)

- (NSString *)MD5String
{
    const char *cstr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    NSMutableString *str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [str appendFormat:@"%02X", result[i]];
    }
    return str;
}

@end
