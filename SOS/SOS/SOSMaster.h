//
//  SOSMaster.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOSMaster : NSObject <UserSessionObligatorily>

- (void)startSOS;
- (void)stopSOS;

@end
