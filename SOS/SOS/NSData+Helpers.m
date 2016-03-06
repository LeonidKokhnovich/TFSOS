//
//  NSData+Helpers.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "NSData+Helpers.h"

@implementation NSData (Helpers)

+ (NSData *)randomDataWithLength:(NSUInteger)length
{
    NSMutableData* theData = [NSMutableData dataWithCapacity:length];
    for (unsigned int i = 0; i < length;i++) {
        u_int32_t randomBits = arc4random();
        
        // Yes, I know... 4 to 1 byte... But that's ok for emulation purposes.
        
        [theData appendBytes:(void*)&randomBits length:1];
    }
    return theData;
}

static inline char itoh(int i) {
    if (i > 9) return 'A' + (i - 10);
    return '0' + i;
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    // The following implementation is copied from the following page: http://stackoverflow.com/questions/7317860/converting-hex-nsstring-to-nsdata
    
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    NSUInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

- (NSString *)convertToHex
{
    NSUInteger i, len;
    unsigned char *buf, *bytes;
    
    len = self.length;
    bytes = (unsigned char*)self.bytes;
    buf = malloc(len*2);
    
    for (i=0; i<len; i++) {
        buf[i*2] = itoh((bytes[i] >> 4) & 0xF);
        buf[i*2+1] = itoh(bytes[i] & 0xF);
    }
    
    return [[NSString alloc] initWithBytesNoCopy:buf
                                          length:len*2
                                        encoding:NSASCIIStringEncoding
                                    freeWhenDone:YES];
}

@end
