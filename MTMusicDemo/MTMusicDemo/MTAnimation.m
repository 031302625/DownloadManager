//
//  MTAnimation.m
//  MTAlertView
//
//  Created by Cheng on 16/7/12.
//  Copyright © 2016年 TomWu. All rights reserved.
//  动画类

#import "MTAnimation.h"

@implementation MTAnimation

+ (void)animationShowInView:(UIView *)view style:(MTAnimationStyle)style completion:(void (^)())completion {
    switch (style) {
        case MTAnimationStyleNone: {
            if (completion) {
                completion();
            }
            break;
        }
        case MTAnimationStyleFade: {
            view.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 view.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }]; 
            break;
        }
        case MTAnimationStyleSlideFromBottom: {
            CGRect rect = view.frame;
            CGRect originRect = rect;
            rect.origin.y = [UIScreen mainScreen].bounds.size.height + view.bounds.size.height;
            view.frame = rect;
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 view.frame = originRect;
                             } completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
            break;
        }
        case MTAnimationStyleSlideFromTop: {
            CGRect rect = view.frame;
            CGRect originRect = rect;
            rect.origin.y = -rect.size.height;
            view.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = originRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case MTAnimationStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = view;
            [animation setValue:completion forKey:@"animationStop"];
            [view.layer addAnimation:animation forKey:@"bouce"];
            break;
        }
        case MTAnimationStyleStyleDropDown: {
            CGFloat y = view.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - view.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = view;
            [animation setValue:completion forKey:@"animationStop"];
            [view.layer addAnimation:animation forKey:@"dropdown"];
            break;
        }
    }
}

+ (void)animationHideInView:(UIView *)view style:(MTAnimationStyle)style completion:(void (^)())completion {
    switch (style) {
        case MTAnimationStyleNone: {
            if (completion) {
                completion();
            }
            break;
        }
        case MTAnimationStyleFade: {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 view.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
            break;
        }
        case MTAnimationStyleSlideFromBottom: {
            CGRect rect = view.frame;
            rect.origin.y = [UIScreen mainScreen].bounds.size.height + view.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 view.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
            break;
        }
        case MTAnimationStyleSlideFromTop: {
            CGRect rect = view.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 view.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
            break;
        }
        case MTAnimationStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = view;
            [animation setValue:completion forKey:@"animationStop"];
            [view.layer addAnimation:animation forKey:@"bounce"];
            view.transform = CGAffineTransformMakeScale(0.01, 0.01);
            break;
        } 
        case MTAnimationStyleStyleDropDown: {
            CGPoint point = view.center;
            point.y += view.bounds.size.height;
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 view.center = point;
                                 CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                                 view.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
            break;
        }
    }
}
@end
