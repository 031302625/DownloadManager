//
//  MTAnimation.h
//  MTAlertView
//
//  Created by Cheng on 16/7/12.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   动画方式
 */
typedef NS_ENUM(NSUInteger, MTAnimationStyle) {
    MTAnimationStyleNone = 0,   /**< 没有动画 **/
    MTAnimationStyleFade,   /**< 渐渐显示和隐藏 **/
    MTAnimationStyleSlideFromBottom,  /**< 从下方弹出或显示 **/
    MTAnimationStyleSlideFromTop, /**< 从下方弹出或显示 **/
    MTAnimationStyleBounce, /**< 从中间展开或向中间隐藏 **/
    MTAnimationStyleStyleDropDown, /**< 从上方一定位置弹出，或坠落隐藏 **/
} NS_AVAILABLE_IOS(7.0);

/**
 *   视图动画设置类
 */
@interface MTAnimation : UIView

/**
 *  指定view的显示动画
 *
 *  @param view       需要动画的视图
 *  @param style      动画类型
 *  @param completion 动画显示完成block回调
 */
+ (void)animationShowInView:(UIView *)view style:(MTAnimationStyle)style completion:(void(^)())completion;

/**
 *  指定view的隐藏动画
 *
 *  @param view       需要动画的视图
 *  @param style      动画类型
 *  @param completion 动画消失的block回调
 */
+ (void)animationHideInView:(UIView *)view style:(MTAnimationStyle)style completion:(void(^)())completion;

@end 
