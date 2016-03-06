//
//  NSData+Helpers.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Helpers)

/**
 *  Method creates an NSData object with random bytes of the specifid length.
 *
 *  @param length Expected output data length in bytes.
 *
 *  @return NSData instance with random bytes in it.
 */
+ (NSData * _Nonnull)randomDataWithLength:(NSUInteger)length;

/**
 *  Method creates an NSData object from the specified hex formatted string.
 *
 *  @param hexString String with hex. Example: @"72ff63ce".
 *
 *  @return NSData instance.
 */
+ (NSData * _Nonnull)dataFromHexString:(NSString * _Nonnull)hexString;

/**
 *  Method generates a hex string that corresponds to the data.
 *
 *  @return Hex string.
 */
- (NSString * _Nonnull)convertToHex;

@end
