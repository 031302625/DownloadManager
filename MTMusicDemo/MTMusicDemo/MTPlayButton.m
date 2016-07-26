//
//  MTPlayButton.m
//  MTMusicDemo
//
//  Created by Cheng on 16/7/23.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import "MTPlayButton.h"
#import "MTConstant.h"

@implementation MTPlayButton

static MTPlayButton *_sharedButton = nil;

- (void)dealloc {
    NSLog(@"MTPlayButton");
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedButton = [[MTPlayButton alloc] initWithFrame:CGRectMake(0, 0, MT_PLAYBUTTONW, MT_PLAYBUTTONW)];
        _sharedButton.layer.borderWidth = 1.0f;
        _sharedButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _sharedButton.layer.cornerRadius = MT_PLAYBUTTONW * 0.5;
        _sharedButton.layer.masksToBounds = YES;
        _sharedButton.backgroundColor = [UIColor colorWithRed:9/255.0f green:11/255.0f blue:14/255.0f alpha:0.5];
        _sharedButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    });
    return _sharedButton;
}

@end
