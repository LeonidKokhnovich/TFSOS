//
//  RegisterUserViewController.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "RegisterUserViewController.h"

@interface RegisterUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emergencyContactTextField;
@property (weak, nonatomic) IBOutlet UITextField *emergencyNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretCodeTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomLayoutConstraint;

@end

@implementation RegisterUserViewController

#pragma mark -
#pragma mark Life Circle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self subscribeToNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self unsubscribeFromNotifications];
}

#pragma mark -
#pragma mark User Actions

#pragma mark -
#pragma mark Public Methods

- (IBAction)onRegisterButtonTapped:(id)sender
{
    
}

#pragma mark -
#pragma mark Accessories

#pragma mark -
#pragma mark Helper Methods

#pragma mark Subcribers

- (void)subscribeToNotifications
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onKeyboardWillAppearNotification:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onKeyboardWillAppearNotification:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void)unsubscribeFromNotifications
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Delegate Methods

#pragma mark -
#pragma mark Notifications Handling Methods

//- (void)onKeyboardWillAppearNotification:(NSNotification *)notification
//{
//    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    double animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    [UIView setAnimationCurve:animationCurve];
//    
//    self.scrollViewBottomLayoutConstraint.constant = -keyboardSize.height;
//    [self.scrollView setNeedsLayout];
//    
//    [UIView commitAnimations];
//}
//
//- (void)onKeyboardWillDisappearNotification:(NSNotification *)notification
//{
//    double animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    [UIView setAnimationCurve:animationCurve];
//    
//    self.scrollViewBottomLayoutConstraint.constant = 0;
//    [self.scrollView setNeedsLayout];
//    
//    [UIView commitAnimations];
//}

@end
