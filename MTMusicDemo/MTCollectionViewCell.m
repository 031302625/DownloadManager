//
//  MTCollectionViewCell.m
//  MTMusicDemo
//
//  Created by Cheng on 16/7/22.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import "MTCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MTMusicModel.h"
#import "MTConstant.h"
#import "MTPlayButton.h"

@interface MTCollectionViewCell() {
    
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MTPlayButton *playButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, assign, getter=isMusicPlaying) BOOL musicPlaying;
@end

@implementation MTCollectionViewCell

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"init");
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor purpleColor];
    
    //imageview
    self.imageView.frame = self.contentView.bounds;
    
    //downButton
    CGFloat downButtonX = self.contentView.bounds.size.width - MT_DOWNLOADBUTTONW - MT_MARGIN;
    CGFloat downButtonY = self.contentView.bounds.size.height - MT_DOWNLOADBUTTONW - MT_MARGIN;
    self.downButton.frame = CGRectMake(downButtonX, downButtonY, MT_DOWNLOADBUTTONW, MT_DOWNLOADBUTTONW);
}

#pragma mark - ClassMethods

- (void)playButtonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(cellPlayButtonClicke:currentPlayModel:)]) {
        [_delegate cellPlayButtonClicke:self currentPlayModel:_musicModel];
    }
}

- (void)downButtonClick:(UIButton *)button {
    //hide
    [button setHidden:YES];
    
    //添加progress
    CGFloat progressViewW = self.bounds.size.width - 2 * MT_PROGRESSVIEW_MARGIN;
    CGFloat progressViewH = 2.0f;
    CGFloat progressViewX = MT_PROGRESSVIEW_MARGIN;
    CGFloat progressViewY = self.bounds.size.height - progressViewH - MT_MARGIN * 2;
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.tintColor = [UIColor colorWithRed:247.0 / 255.0f green:78.0 / 255.0f blue:120.0 / 255.0f alpha:1.0f];
    [self.contentView addSubview:progressView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cellDownLoadButtonClicke:currentDownLoadModel:downLoadProgressView:)]) {
        [_delegate cellDownLoadButtonClicke:self currentDownLoadModel:_musicModel downLoadProgressView:progressView];
    }
}

- (void)createPlayButton {
    _playButton = [MTPlayButton sharedInstance];
    
    //set x y
    CGRect playButtonRect = _playButton.frame;
    CGFloat playButtonX = (self.bounds.size.width - MT_PLAYBUTTONW) * 0.5;
    CGFloat playButtonY = (self.bounds.size.height - MT_PLAYBUTTONW) * 0.5;
    playButtonRect.origin.x = playButtonX;
    playButtonRect.origin.y = playButtonY;
    _playButton.frame = playButtonRect;
    
    if (_musicPlaying) {
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else {
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    [_playButton removeTarget:nil action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_playButton];
}

#pragma mark - Setter/Getter

- (void)setMusicModel:(MTMusicModel *)musicModel {
    _musicModel = musicModel;
    
    //load image
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:musicModel.imageUrl]];
}

- (void)setCurrentMusicItem:(NSUInteger)currentMusicItem {
    _currentMusicItem = currentMusicItem; 
    
    //change status
    _musicPlaying = !_musicPlaying;
    
    //create play button
    [self createPlayButton];
}

- (UIImageView *)imageView { 
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)downButton {
    if (!_downButton) {
        _downButton = [[UIButton alloc] init];
        _downButton.layer.cornerRadius = MT_DOWNLOADBUTTONW * 0.5;
        _downButton.layer.masksToBounds = YES;
        _downButton.backgroundColor = [UIColor colorWithRed:247.0 / 255.0f green:78.0 / 255.0f blue:120.0 / 255.0f alpha:1.0f];
        _downButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_downButton setImage:[UIImage imageNamed:@"downLoad"] forState:UIControlStateNormal];
        [_downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_downButton];
    }
    return _downButton;
}

@end

