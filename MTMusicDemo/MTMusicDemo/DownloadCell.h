//
//  DownloadCell.h
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/19.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTMusicModel;
@class DownloadCell;

@protocol DownloadCellDelegate <NSObject>
- (void)cellDownLoadFinished:(DownloadCell *)cell musicModel:(MTMusicModel *)model;
@end

@interface DownloadCell : UITableViewCell

@property (nonatomic, strong) MTMusicModel *musicModel;

@property (nonatomic, weak) id<DownloadCellDelegate> delegate;

@end
