//
//  MTDownListTableView.h
//  MTMusicDemo
//
//  Created by Cheng on 16/7/24.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTMusicModel;
@interface MTDownListTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) void(^downListTableViewRefrestCell)(MTMusicModel *model);

@end