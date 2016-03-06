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

@end

@implementation RegisterUserViewController

#pragma mark -
#pragma mark Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self subscribeToNotifications];
    [self checkUserAuthorizationStatus];
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
    NSLog(@"Did tap register button");
    
    [self registerUser];
}

#pragma mark -
#pragma mark Accessories


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
             
             // Update UI.
             
             self.activityOverlay.hidden = YES;
             
#ifdef TEST_SIGN_UP
             if (/* DISABLES CODE */ (YES)) {
                 userUUID = [NSString stringWithFormat:@"%zd", arc4random()];
#else
             if (userUUID) {
#endif
                 [[AppStorage sharedInstance] saveUserUUID:userUUID];
                 
                 // Attempt to autorize the user with the new UUID.
                 
                 [self authorizeUser];
             }
             else {
                 [self showAlertWithTitle:TextStringWarning
                                  message:TextStringNetworkRequestFailed];
             }
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
    returnModel.birthDate = self.birthDateTextField.text;
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
    returnModel.birthDate = [self randomString];
    returnModel.homeAddress = [self randomString];
    returnModel.phoneNumber = [self randomString];
    returnModel.emergencyContact = [self randomString];
    returnModel.emergencyNumber = [self randomString];
    returnModel.secretCode = [self randomString];
    return returnModel;
}

- (NSString *)randomString
{
    return [[NSData randomDataWithLength:10] convertToHex];
}


#pragma mark Subcribers

- (void)subscribeToNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillAppearNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillAppearNotification:)
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
    return YES;
}


#pragma mark -
#pragma mark Notifications Handling Methods

- (void)onKeyboardWillAppearNotification:(NSNotification *)notification
{
    [self handleKeyboardWillHideNotification:notification
                              withScrollView:self.scrollView];
}

- (void)onKeyboardWillDisappearNotification:(NSNotification *)notification
{
    [self handleKeyboardWillHideNotification:notification
                              withScrollView:self.scrollView];
}

@end
