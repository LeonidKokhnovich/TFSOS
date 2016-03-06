//
//  SOSRequestViewController.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "SOSViewController.h"

@interface SOSViewController ()

@property (weak, nonatomic) IBOutlet UIView *activateSOSContainerView;
@property (weak, nonatomic) IBOutlet UIView *deactivateSOSContainerView;
@property (weak, nonatomic) IBOutlet UITextField *secretCodeTextField;

@end

@implementation SOSViewController

@synthesize userUUID;

#pragma mark -
#pragma mark Life Circle

#pragma mark -
#pragma mark User Actions

- (IBAction)onSOSTapped:(id)sender
{
    NSLog(@"SOS tapped");
}

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Accessories

#pragma mark -
#pragma mark Helper Methods

#pragma mark -
#pragma mark Delegate Methods

#pragma mark -
#pragma mark Notifications Handling Methods

@end