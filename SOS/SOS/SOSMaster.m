//
//  SOSMaster.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "SOSMaster.h"
#import <CoreLocation/CoreLocation.h>
#import "NetworkCommunicator.h"
#import "SOSModel.h"
#import "ModelValidator.h"

typedef void (^ RequestLocationPermissionCompletionBlock)(void);

@interface SOSMaster () <CLLocationManagerDelegate>

@property (nonatomic) BOOL activating;
@property (nonatomic) BOOL deactivating;
@property (nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) RequestLocationPermissionCompletionBlock requestLocationPermissionCompletionBlock;
@property (nonatomic) NSString *SOSUUID;

@end

@implementation SOSMaster

@synthesize userUUID;

#pragma mark -
#pragma mark Life Circle

- (instancetype)init
{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 50;
    }
    return self;
}


#pragma mark -
#pragma mark Public Methods

- (void)startSOS
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Starting SOS.");
        
        self.activating = YES;
        
        weakify(self);
        [[NetworkCommunicator sharedInstance] performCreateSOSSessionForUserWithUUID:self.userUUID
                                                                     completionBlock:^(NSString * _Nonnull SOSUUID, NSError * _Nonnull error)
         {
             strongify(self);
             
             self.activating = NO;
             
#ifdef TEST_START_SOS
             if (/* DISABLES CODE */ (YES)) {
                 SOSUUID = [NSString stringWithFormat:@"%zd", arc4random()];
#else
             if (   error == nil
                 && SOSUUID)
             {
#endif
                 self.SOSUUID = SOSUUID;
                 [self.locationManager startUpdatingLocation];
                 
                 if ([self.delegate respondsToSelector:@selector(masterDidStartSOS:)]) {
                     dispatch_async(self.callbacksQueue, ^{
                         [self.delegate masterDidStartSOS:self];
                     });
                 }
             }
             else if ([self.delegate respondsToSelector:@selector(master:didFailToStartSOSWithError:)]) {
                 dispatch_async(self.callbacksQueue, ^{
                     [self.delegate master:self didFailToStartSOSWithError:error];
                 });
             }
         }];
    }
    else if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Requesting user location permission for SOS.");
        
        self.activating = YES;
        
        weakify(self);
        self.requestLocationPermissionCompletionBlock = ^{
            strongify(self);
            self.activating = NO;
            [self startSOS];
        };
        
        [self.locationManager requestAlwaysAuthorization];
    }
    else if ([self.delegate respondsToSelector:@selector(master:didFailToStartSOSWithError:)]) {
        NSError *error = [NSError errorWithDomain:SOS_MASTER_ERROR_DOMAIN
                                             code:SOS_MASTER_ERROR_CODE_NO_TRACK_LOCATION_PERMISSION
                                         userInfo:nil];
        dispatch_async(self.callbacksQueue, ^{
            [self.delegate master:self didFailToStartSOSWithError:error];
        });
    }
}

- (void)stopSOS
{
    NSLog(@"Stop SOS");
    
    self.deactivating = YES;
    
    weakify(self);
    [[NetworkCommunicator sharedInstance] performSOSStatusUpdate:SOS_STATUS_CANCELLED
                                                         SOSUUID:self.SOSUUID
                                                 completionBlock:^(NSError * _Nonnull error)
     {
         strongify(self);
         
         self.deactivating = NO;
         
         if (error == nil) {
             [self forceSOSToStop];
         }
         else if ([self.delegate respondsToSelector:@selector(master:didFailToStopSOSWithError:)]) {
             dispatch_async(self.callbacksQueue, ^{
                 [self.delegate master:self didFailToStopSOSWithError:error];
             });
         }
     }];
}

#pragma mark -
#pragma mark Accessories

- (BOOL)active
{
    return (self.SOSUUID != nil);
}

- (dispatch_queue_t)callbacksQueue
{
    if (_callbacksQueue == nil) {
        _callbacksQueue = dispatch_get_main_queue();
    }
    return _callbacksQueue;
}

#pragma mark -
#pragma mark Helper Methods

- (void)deliverNewSOSWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"Deliver SOS with coorindates: %f, %f",
          coordinate.longitude, coordinate.latitude);
    
    SOSModel *SOS = [SOSModel new];
    SOS.userUUID = self.userUUID;
    SOS.SOSUUID = self.SOSUUID;
    SOS.longitude = coordinate.longitude;
    SOS.latitude = coordinate.latitude;
    
    if ([ModelValidator validateSOSModel:SOS]) {
        weakify(self);
        [[NetworkCommunicator sharedInstance] retrieveStatusForSOSWithUUID:self.SOSUUID
                                                           completionBlock:^(SOS_STATUS status, NSError * _Nonnull error)
         {
             strongify(self);
             if (error == nil) {
                 if (status == SOS_STATUS_CANCELLED) {
                     [self forceSOSToStop];
                 }
                 else {
                     weakify(self);
                     [[NetworkCommunicator sharedInstance] performUpdateForSOS:SOS
                                                               completionBlock:^(NSError * _Nonnull error)
                      {
                          strongify(self);
                          if (   error
                              && [self.delegate respondsToSelector:@selector(master:didFailToDeliverSOSWithError:)])
                          {
                              dispatch_async(self.callbacksQueue, ^{
                                  [self.delegate master:self didFailToDeliverSOSWithError:error];
                              });
                          }
                      }];
                 }
             }
             else if ([self.delegate respondsToSelector:@selector(master:didFailToDeliverSOSWithError:)])
             {
                 dispatch_async(self.callbacksQueue, ^{
                     [self.delegate master:self didFailToDeliverSOSWithError:error];
                 });
             }
         }];
    }
    else if ([self.delegate respondsToSelector:@selector(master:didFailToStartSOSWithError:)]) {
        NSError *error = [NSError errorWithDomain:SOS_MASTER_ERROR_DOMAIN
                                             code:SOS_MASTER_ERROR_CODE_NO_TRACK_LOCATION_PERMISSION
                                         userInfo:@{NSLocalizedDescriptionKey: @"Can't deliver SOS, request data are not valid."}];
        dispatch_async(self.callbacksQueue, ^{
            [self.delegate master:self didFailToDeliverSOSWithError:error];
        });
    }
}

- (void)forceSOSToStop
{
    self.SOSUUID = nil;
    [self.locationManager stopUpdatingLocation];
    
    if ([self.delegate respondsToSelector:@selector(masterDidStopSOS:)]) {
        dispatch_async(self.callbacksQueue, ^{
            [self.delegate masterDidStopSOS:self];
        });
    }
}

#pragma mark -
#pragma mark Delegate Methods

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.requestLocationPermissionCompletionBlock) {
        self.requestLocationPermissionCompletionBlock();
        self.requestLocationPermissionCompletionBlock = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self deliverNewSOSWithCoordinate:manager.location.coordinate];
}

#pragma mark -
#pragma mark Notifications Handling Methods

@end
