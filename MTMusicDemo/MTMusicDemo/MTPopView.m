//
//  MTPopView.m
//  MTAlertView
//
//  Created by Cheng on 16/7/14.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import "MTPopView.h"

@interface MTPopView()
@property (nonatomic, strong) UIView *backView; /**< 背景视图 **/

@end

@implementation MTPopView

#pragma mark Life Cycle

- (void)dealloc {
    NSLog(@"MTPopView dealloc");
    _parentView = nil;
    _customeView = nil;
    _backView = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initPopViewWith:(UIView *)customeView {
    if (self = [super init]) {
        _customeView = customeView; 
        
        //initialize
        [self initialize];
    }
    return self;
}

#pragma mark Show/Hide

- (void)showAnimation:(MTAnimationStyle)style completion:(void (^)())completion {
    _defaultHideAnimationStyle = style;
    [self showInParentView:[UIApplication sharedApplication].keyWindow animation:style completion:^{
        if (completion) {
            completion();
        } 
    }];
}

- (void)showInParentView:(UIView *)parentView animation:(MTAnimationStyle)style completion:(void (^)())completion {
    _parentView = parentView;
    _defaultHideAnimationStyle = style;
    
    [self calculateLayout];
    [self addPopSubViews];
    
    //弹出动画
    [MTAnimation animationShowInView:self style:style completion:^{
        if (completion) {
            completion();
        }
    }]; 
}

- (void)dissmissAnimation:(MTAnimationStyle)style completion:(void (^)())completion {
    __weak typeof(self) _weakSelf = self;
    [MTAnimation animationHideInView:self style:style completion:^{
        [_weakSelf tearDown];
    }];
}

#pragma mark Class Methods

/** 初始化 **/
- (void)initialize {
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor lightGrayColor];
    _backView.alpha = 0.5;
    
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
}

/** 计算当前popview的尺寸 **/
- (void)calculateLayout {
    _backView.frame = _parentView.bounds;
    
    //self在parentView居中显示
    CGFloat parentViewW = _parentView.bounds.size.width;
    CGFloat parentViewH = _parentView.bounds.size.height;
    
    CGFloat customeViewW = _customeView.bounds.size.width;
    CGFloat customeViewH = _customeView.bounds.size.height;
    
    self.frame = CGRectMake((parentViewW - customeViewW) * 0.5, (parentViewH - customeViewH) * 0.5, customeViewW, customeViewH);
    _customeView.frame = self.bounds;
}

- (void)addPopSubViews {
    [_parentView addSubview:_backView];
    [_parentView addSubview:self];
    [self addSubview:_customeView];
}

- (void)tearDown {
    [_backView removeFromSuperview];
    [_customeView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark Animation stop

/** 动画完成的代理 **/
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void(^completion)(void) = [anim valueForKey:@"animationStop"];
    if (completion) {
        completion();
    }
}
@end
