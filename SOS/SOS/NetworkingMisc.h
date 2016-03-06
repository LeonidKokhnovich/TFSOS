//
//  NetworkingMisc.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#ifndef NetworkingMisc_h
#define NetworkingMisc_h

#define USER_UUID_KEY @"user_uuid"
#define SOS_UUID_KEY @"sos_uuid"
#define SOS_STATUS_KEY @"status"

typedef NS_ENUM(NSUInteger, SOS_STATUS) {
    SOS_STATUS_CANCELLED = 0,
    SOS_STATUS_UNKNOWN = NSUIntegerMax
};

#endif /* NetworkingMisc_h */
