//
//  RegisterUserViewController.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "UserInfoModel.h"
#import "ModelValidator.h"
#import "NetworkCommunicator.h"
#import "AppStorage.h"
#import "UserSessionObligatorily.h"

NSString *SEGUE_NAME_SHOW_SOS = @"Show SOS";

@interface RegisterUserViewController () <UITextFieldDelegate>

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
@property (weak, nonatomic) IBOutlet UIView *activityOverlay;
@property (nonatomic) NSNumberFormatter *numberFormatter;

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

#pragma mark View Transitions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_NAME_SHOW_SOS]) {
        NSString *userUUID = [[AppStorage sharedInstance] userUUID];
        id <UserSessionObligatorily> vc = segue.destinationViewController;
        [vc setUserUUID:userUUID];
    }
}


#pragma mark -
#pragma mark User Actions

#pragma mark -
#pragma mark Public Methods

- (IBAction)onRegisterButtonTapped:(id)sender
{
    NSLog(@"Did tap register button");
    
    [self registerUser];
}

#pragma mark -
#pragma mark Accessories

- (NSNumberFormatter *)numberFormatter
{
    if (_numberFormatter == nil) {
        _numberFormatter = [NSNumberFormatter new];
    }
    return _numberFormatter;
}


#pragma mark -
#pragma mark Helper Methods

- (void)authorizeUser
{
    BOOL userAuthorized = [self checkUserAuthorizationStatus];
    
    if (userAuthorized) {
        [self performSegueWithIdentifier:SEGUE_NAME_SHOW_SOS
                                  sender:nil];
    }
}

- (BOOL)checkUserAuthorizationStatus
{
    BOOL authorized = NO;
    
    NSString *userUUID = [[AppStorage sharedInstance] userUUID];
    if (userUUID) {
        authorized = YES;
    }
    
    return authorized;
}

- (void)registerUser
{
#ifdef TEST_SIGN_UP
    UserInfoModel *userInfo = [self createTestUserInfoModel];
#else
    UserInfoModel *userInfo = [self createUserInfoModel];
#endif
    
    if ([ModelValidator validateUserInfoModel:userInfo]) {
        // Update UI.
        
        self.activityOverlay.hidden = NO;
        
        weakify(self);
        [[NetworkCommunicator sharedInstance] performRegisterUserRequestWithUserInfo:userInfo
                                                                     completionBlock:^(NSString * _Nonnull userUUID, NSError * _Nonnull error)
         {
             strongify(self);
             
             __block NSString *blockedUserUUID = userUUID;
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 // Update UI.
                 
                 self.activityOverlay.hidden = YES;
                 
#ifdef TEST_SIGN_UP
                 if (/* DISABLES CODE */ (YES)) {
                     blockedUserUUID = [NSString stringWithFormat:@"%zd", arc4random()];
#else
                     if (blockedUserUUID) {
#endif
                         [[AppStorage sharedInstance] saveUserUUID:blockedUserUUID];
                         
                         NSString *secretCodeHash = [userInfo.secretCode.lowercaseString MD5String];
                         [[AppStorage sharedInstance] saveSecretCodeHash:secretCodeHash
                                                             forUserUUID:blockedUserUUID];
                         
                         // Attempt to autorize the user with the new UUID.
                         
                         [self authorizeUser];
                     }
                     else {
                         [self showAlertWithTitle:TextStringWarning
                                          message:TextStringNetworkRequestFailed];
                     }

             });
         }];
    }
    else {
        [self showAlertWithTitle:TextStringWarning
                         message:TextStringInputIsNotValid];
    }
}

- (UserInfoModel * _Nonnull)createUserInfoModel
{
    UserInfoModel *returnModel = [UserInfoModel new];
    returnModel.firstName = self.firstNameTextField.text;
    returnModel.lastName = self.lastNameTextField.text;
    returnModel.birthDate = [self.numberFormatter numberFromString:self.birthDateTextField.text];
    returnModel.homeAddress = self.homeAddressTextField.text;
    returnModel.phoneNumber = self.phoneNumberTextField.text;
    returnModel.emergencyContact = self.emergencyContactTextField.text;
    returnModel.emergencyNumber = self.emergencyNumberTextField.text;
    returnModel.secretCode = self.secretCodeTextField.text;
    return returnModel;
}

- (UserInfoModel * _Nonnull)createTestUserInfoModel
{
    UserInfoModel *returnModel = [UserInfoModel new];
    returnModel.firstName = [self randomString];
    returnModel.lastName = [self randomString];
    returnModel.birthDate = [NSNumber numberWithInteger:arc4random()];
    returnModel.homeAddress = [self randomString];
    returnModel.phoneNumber = [self randomString];
    returnModel.emergencyContact = [self randomString];
    returnModel.emergencyNumber = [self randomString];
    returnModel.secretCode = @"123";//[self randomString];
    return returnModel;
}

- (NSString *)randomString
{
    return [[NSData randomDataWithLength:10] convertToHex];
}

- (NSArray <UITextField *> *)textFields
{
    return @[self.firstNameTextField,
             self.lastNameTextField,
             self.birthDateTextField,
             self.homeAddressTextField,
             self.phoneNumberTextField,
             self.emergencyContactTextField,
             self.emergencyNumberTextField,
             self.secretCodeTextField];
}

- (void)makeViewVisible:(UIView *)view
       withinScrollView:(UIScrollView *)scrollView
               animated:(BOOL)animated
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGSize contentViewSize = scrollView.contentSize;
    static CGFloat minEdgeOffset = 80.0f;
    
    if (CGRectGetMinY(view.frame) < contentOffset.y + minEdgeOffset) {
        CGPoint newContentOffset = CGPointMake(contentOffset.x,
                                               CGRectGetMinY(view.frame) - minEdgeOffset);
        [scrollView setContentOffset:newContentOffset animated:animated];
    }
    if (CGRectGetMaxY(view.frame) > contentOffset.y + contentViewSize.height - minEdgeOffset) {
        CGPoint newContentOffset = CGPointMake(contentOffset.x,
                                               CGRectGetMaxY(view.frame) - contentViewSize.height + minEdgeOffset);
        [scrollView setContentOffset:newContentOffset animated:animated];
    }
}


#pragma mark Subcribers

- (void)subscribeToNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSArray *textFields = [self textFields];
    NSInteger textFieldIndex = [textFields indexOfObject:textField];
    
    if (    textFieldIndex != textFields.count - 1
        &&  textFieldIndex != NSNotFound)
    {
        UITextField *nextTextField = [textFields objectAtIndex:textFieldIndex + 1];
        [nextTextField becomeFirstResponder];
        
        [self makeViewVisible:nextTextField
             withinScrollView:self.scrollView
                     animated:YES];
    }
    else
    {
        [textField resignFirstResponder];
        [self registerUser];
    }
    
    return YES;
}


#pragma mark -
#pragma mark Notifications Handling Methods

- (void)onKeyboardWillShowNotification:(NSNotification *)notification
{
    [self handleKeyboardWillShowNotification:notification
                              withScrollView:self.scrollView];
}

- (void)onKeyboardWillHideNotification:(NSNotification *)notification
{
    [self handleKeyboardWillHideNotification:notification
                              withScrollView:self.scrollView];
}

@end
