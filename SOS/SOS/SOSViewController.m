//
//  SOSRequestViewController.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "SOSViewController.h"
#import "SOSMaster.h"
#import "ModelValidator.h"
#import "DCPathButton.h"
#import "DCPathItemButton.h"

typedef NS_ENUM(NSUInteger, PATH_BUTTON_TYPE) {
    PATH_BUTTON_TYPE_PHOTO = 0,
    PATH_BUTTON_TYPE_MESSAGE = 1
};

@interface SOSViewController () <SOSMasterDelegate, UITextFieldDelegate, DCPathButtonDelegate>

@property (weak, nonatomic) IBOutlet UIView *activateSOSContainerView;
@property (weak, nonatomic) IBOutlet UIView *deactivateSOSContainerView;
@property (weak, nonatomic) IBOutlet UITextField *secretCodeTextField;
@property (weak, nonatomic) IBOutlet UIView *activityOverlay;
@property (nonatomic) SOSMaster *master;
@property (weak, nonatomic) IBOutlet UIImageView *stopSOSImageView;
@property (nonatomic) BOOL showStopSOSImageView;
@property (weak, nonatomic) IBOutlet UIView *secretCodeContainerView;

@end

@implementation SOSViewController

@synthesize userUUID;

#pragma mark -
#pragma mark Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}


#pragma mark -
#pragma mark User Actions

- (IBAction)onSOSTapped:(id)sender
{
    NSLog(@"SOS tapped.");
    
    [self.master startSOS];
    [self updateUI];
}

- (IBAction)onStopSOSTapped:(id)sender
{
    NSLog(@"Stop SOS tapped.");
    
    self.showStopSOSImageView = NO;
    [self updateUI];
}

- (IBAction)cancelSOSTapped:(id)sender
{
    NSLog(@"Cancel SOS tapped.");
    
    [self cancelSOS];
}

#pragma mark -
#pragma mark Public Methods

- (void)updateUI
{
    self.activateSOSContainerView.hidden = self.master.active;
    self.deactivateSOSContainerView.hidden = !self.master.active;
    
    BOOL showStopSOS = (    self.master.active
                        &&  self.showStopSOSImageView);
    self.stopSOSImageView.hidden = !showStopSOS;
    if (showStopSOS) {
        [self.stopSOSImageView startPulseAnimationWithScale:1.1
                                             circleDuration:1.5];
    }
    else {
        [self.stopSOSImageView stopPulseAnimation];
    }
    
    self.secretCodeContainerView.hidden = showStopSOS;
    
    BOOL showActivityOverlay = (    self.master.activating
                                ||  self.master.deactivating);
    self.activityOverlay.hidden = !showActivityOverlay;
}

#pragma mark -
#pragma mark Accessories

#pragma mark -
#pragma mark Helper Methods

- (void)setup
{
    self.master = [[SOSMaster alloc] init];
    self.master.delegate = self;
    self.master.userUUID = self.userUUID;
    
    [self configureDCPathButton];
}

- (void)configureDCPathButton
{
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                         highlightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[
                                 itemButton_3,
                                 itemButton_4
                                 ]];
    
    // Change the bloom radius, default is 105.0f
    //
    dcPathButton.bloomRadius = 120.0f;
    
    // Change the DCButton's center
    //
    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 25.5f);
    
    // Setting the DCButton appearance
    //
    dcPathButton.allowSounds = NO;
    dcPathButton.allowCenterButtonRotation = YES;
    
    dcPathButton.bottomViewColor = [UIColor grayColor];
    
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTopRight;
    dcPathButton.dcButtonCenter = CGPointMake(10 + dcPathButton.frame.size.width/2,
                                              self.view.frame.size.height - dcPathButton.frame.size.height/2 - 10);
    
//    [self.deactivateSOSContainerView addSubview:dcPathButton];
}

- (void)cancelSOS
{
    NSString *secretCode = self.secretCodeTextField.text;
    
    if ([ModelValidator validateSecretCode:secretCode
                               forUserUUID:self.userUUID]) {
        [self.master stopSOS];
    }
    else {
        [self showAlertWithTitle:TextStringWarning
                         message:TextStringIncorrectSecretCode];
    }
    
    [self.secretCodeTextField resignFirstResponder];
    self.secretCodeTextField.text = nil;
    
    [self updateUI];
}

- (void)takePhoto
{
    NSLog(@"Take photo");
}

- (void)sendMessage
{
    NSLog(@"Send message");
}


#pragma mark -
#pragma mark Delegate Methods

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self cancelSOS];
    return YES;
}

#pragma mark SOSMasterDelegate

- (void)masterDidStartSOS:(SOSMaster *)master
{
    self.showStopSOSImageView = YES;
    [self updateUI];
}

- (void)master:(SOSMaster *)master didFailToStartSOSWithError:(NSError *)error
{
    NSLog(@"Did fail to start SOS with error %@.", error);
    
    [self showAlertWithTitle:TextStringWarning
                     message:TextStringFailedToPerformSOS];
    [self updateUI];
}

- (void)master:(SOSMaster *)master didFailToDeliverSOSWithError:(NSError *)error
{
    NSLog(@"Did fail to deliver SOS with error %@.", error);
    
    if (self.presentedViewController == nil) {
        [self showAlertWithTitle:TextStringWarning
                         message:TextStringFailedToPerformSOS];
    }
    
    [self updateUI];
}

- (void)master:(SOSMaster *)master didFailToStopSOSWithError:(NSError *)error
{
    NSLog(@"Did fail to stop SOS with error %@.", error);
    
    [self showAlertWithTitle:TextStringWarning
                     message:TextStringFailedToStopSOS];
    [self updateUI];
}

- (void)masterDidStopSOS:(SOSMaster *)master
{
    [self updateUI];
}

#pragma mark DCPathButtonDelegate

- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex
{
    PATH_BUTTON_TYPE buttonType = (PATH_BUTTON_TYPE)itemButtonIndex;
    
    switch (buttonType) {
        case PATH_BUTTON_TYPE_PHOTO: {
            [self takePhoto];
            break;
        }
        case PATH_BUTTON_TYPE_MESSAGE: {
            [self sendMessage];
            break;
        }
    }
}


@end