//
//  NSString+Helpers.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

/**
 *  Returns string that is a result of MD5 hash function.
 *
 *  @return MD5 hash string.
 */
- (NSString *)MD5String;

@end
