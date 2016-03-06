//
//  SOSMisc.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#ifndef SOSMisc_h
#define SOSMisc_h

#define SOS_MASTER_ERROR_DOMAIN @"com.sos.master"

typedef NS_ENUM(NSUInteger, SOS_MASTER_ERROR_CODE) {
    SOS_MASTER_ERROR_CODE_NO_TRACK_LOCATION_PERMISSION,
    SOS_MASTER_ERROR_CODE_INVALID_SOS_DATA
};

#define USER_UUID_KEY @"user_uuid"
#define SOS_UUID_KEY @"sos_uuid"

#endif /* SOSMisc_h */
