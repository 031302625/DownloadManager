//
//  DownloadCell.m
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/19.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import "DownloadCell.h"
#import "MTMusicModel.h"
#import "MTASMusicOperation.h"
#import <UIImageView+WebCache.h>
#import "MTConstant.h"

static void *MTProgressKVOKey = &MTProgressKVOKey;
static void *MTDownLoadSpeedKVOkey = &MTDownLoadSpeedKVOkey;

@interface DownloadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *title; 

@end

@implementation DownloadCell

- (void)dealloc{
    NSLog(@"dealloc");
    [_musicModel.operation removeObserver:self forKeyPath:@"progress"];
}

- (void)awakeFromNib {
    self.progressView.progress = 0;
    self.progressLabel.text = @"0%";
    
}

- (void)setMusicModel:(MTMusicModel *)musicModel{
    
    if (_musicModel != musicModel) {
        _musicModel = musicModel;
    }
    self.title.text = musicModel.title;
    [self.image sd_setImageWithURL:[NSURL URLWithString:_musicModel.imageUrl]];
    [_musicModel.operation addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self performSelectorOnMainThread:@selector(updataProgress) withObject:nil waitUntilDone:nil];
}

- (void)updataProgress {
    self.progressView.progress = _musicModel.operation.progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%.1f %%",_musicModel.operation.progress * 100];
    
    if (fabs(_musicModel.operation.progress - 1.0) <= MT_EPSILON) {
        if (_delegate && [_delegate respondsToSelector:@selector(cellDownLoadFinished:musicModel:)]) {
            [_delegate cellDownLoadFinished:self musicModel:_musicModel];
        }
    }
} 


@end
