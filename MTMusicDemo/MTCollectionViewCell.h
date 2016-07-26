//
//  MTCollectionViewCell.h
//  MTMusicDemo
//
//  Created by Cheng on 16/7/22.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTMusicModel;
@class MTCollectionViewCell;

@protocol MTCollectionViewCellDelegate <NSObject>

@optional

- (void)cellPlayButtonClicke:(MTCollectionViewCell *)cell currentPlayModel:(MTMusicModel *)model;
- (void)cellDownLoadButtonClicke:(MTCollectionViewCell *)cell currentDownLoadModel:(MTMusicModel *)model downLoadProgressView:(UIProgressView *)progressView;

@end

@interface MTCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MTMusicModel *musicModel;
@property (nonatomic, assign) NSUInteger currentMusicItem;

@property (nonatomic, weak) id<MTCollectionViewCellDelegate> delegate;
@end
