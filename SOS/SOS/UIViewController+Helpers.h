//
//  UIViewController+Helpers.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helpers)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)handleKeyboardWillShowNotification:(NSNotification *)notification
                            withScrollView:(UIScrollView *)scrollView;
- (void)handleKeyboardWillHideNotification:(NSNotification *)notification
                            withScrollView:(UIScrollView *)scrollView;

@end
