//
//  MTPopView.h
//  MTAlertView
//
//  Created by Cheng on 16/7/14.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTAnimation.h"

/**
 *   用于给指定的View并弹出显示窗口类
 */
@interface MTPopView : UIView
@property (nonatomic, strong) UIView *customeView;  /**< 需要弹出的自定义view **/

/**
 *  初始化MTPopView
 *
 *  @param customeView 传入的自定义View
 *
 *  @return MTPopView
 */
- (instancetype)initPopViewWith:(UIView *)customeView;

/**
 *  通过动画形式默认显示在窗口
 *
 *  @param style      动画类型
 *  @param completion 动画完成的Block回调
 */
- (void)showAnimation:(MTAnimationStyle)style completion:(void(^)())completion;

/**
 *  通过动画指定父视图显示
 *
 *  @param parentView 父视图
 *  @param style      动画类型
 *  @param completion 动画完成的Block回调
 */
- (void)showInParentView:(UIView *)parentView animation:(MTAnimationStyle)style completion:(void(^)())completion;

/**
 *  隐藏当前的PopView，并带有动画
 *
 *  @param style      动画类型
 *  @param completion 动画消失的Block回调
 */
- (void)dissmissAnimation:(MTAnimationStyle)style completion:(void(^)())completion;

@property (nonatomic, assign) MTAnimationStyle defaultHideAnimationStyle;   /**< 默认的隐藏动画 **/
@property (nonatomic, strong) UIView *parentView;   /**< 父视图 **/

/**
 *  POPView布局计算
 */
- (void)calculateLayout;

@end
