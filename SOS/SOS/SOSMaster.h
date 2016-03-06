//
//  SOSMaster.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SOSMasterDelegate;

@interface SOSMaster : NSObject <UserSessionObligatorily>

@property (nonatomic, readonly) BOOL activating;
@property (nonatomic, readonly) BOOL active;
@property (weak, nonatomic) id <SOSMasterDelegate> delegate;
@property (nonatomic) dispatch_queue_t callbacksQueue;

- (void)startSOS;
- (void)stopSOS;

@end

@protocol SOSMasterDelegate <NSObject>

@optional
- (void)masterDidStartSOS:(SOSMaster *)master;
- (void)master:(SOSMaster *)master didFailToStartSOSWithError:(NSError *)error;
- (void)master:(SOSMaster *)master didFailToDeliverSOSWithError:(NSError *)error;

@end