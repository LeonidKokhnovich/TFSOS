//
//  UIViewController+Helpers.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "UIViewController+Helpers.h"

@implementation UIViewController (Helpers)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:TextStringOK
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC
                       animated:YES
                     completion:nil];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification
                            withScrollView:(UIScrollView *)scrollView
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    double animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
    [UIView commitAnimations];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification
                            withScrollView:(UIScrollView *)scrollView
{
    double animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    scrollView.contentInset = UIEdgeInsetsZero;
    
    [UIView commitAnimations];
}

@end
