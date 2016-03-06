//
//  UIView+Helpers.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-06.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helpers)

- (void)startPulseAnimationWithScale:(CGFloat)scale
                      circleDuration:(NSTimeInterval)circleDuration;
- (void)stopPulseAnimation;

@end
