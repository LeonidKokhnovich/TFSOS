//
//  UIView+Helpers.m
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-06.
//  Copyright © 2016 Team14. All rights reserved.
//

#import "UIView+Helpers.h"

NSString *ANIMATION_KEY_PULSE_EFFECT = @"ANIMATION_KEY_PULSE_EFFECT";
NSString *LAYER_SCALE_KEY = @"transform.scale";

@implementation UIView (Helpers)

- (void)startPulseAnimationWithScale:(CGFloat)scale
                      circleDuration:(NSTimeInterval)circleDuration
{
    if ([self.layer animationForKey:ANIMATION_KEY_PULSE_EFFECT] == nil) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:LAYER_SCALE_KEY];
        animation.values = @[@(1.0), @(scale), @(1.0), @(scale), @(1.0), @(1.0)];
        animation.keyTimes = @[@(0.05), @(0.2), @(0.4), @(0.55), @(0.75), @(1.0)];
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        animation.duration = circleDuration;
        animation.repeatCount = CGFLOAT_MAX;
        [self.layer addAnimation:animation forKey:ANIMATION_KEY_PULSE_EFFECT];
    }
}

- (void)stopPulseAnimation
{
    [self.layer removeAnimationForKey:ANIMATION_KEY_PULSE_EFFECT];
}

@end
