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

@interface SOSViewController () <SOSMasterDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *activateSOSContainerView;
@property (weak, nonatomic) IBOutlet UIView *deactivateSOSContainerView;
@property (weak, nonatomic) IBOutlet UITextField *secretCodeTextField;
@property (weak, nonatomic) IBOutlet UIView *activityOverlay;
@property (nonatomic) SOSMaster *master;

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
    self.activityOverlay.hidden = !self.master.activating;
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
}

- (void)cancelSOS
{
    [self.secretCodeTextField resignFirstResponder];
    
    NSString *secretCode = self.secretCodeTextField.text;
    
    if ([ModelValidator validateSecretCode:secretCode
                               forUserUUID:self.userUUID]) {
        [self.master stopSOS];
    }
    else {
        [self showAlertWithTitle:TextStringWarning
                         message:TextStringIncorrectSecretCode];
    }
    
    [self updateUI];
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

#pragma mark -
#pragma mark Notifications Handling Methods

@end