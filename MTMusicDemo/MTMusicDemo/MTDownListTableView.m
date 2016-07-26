//
//  MTDownListTableView.m
//  MTMusicDemo
//
//  Created by Cheng on 16/7/24.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import "MTDownListTableView.h"
#import "DownloadCell.h" 

@interface MTDownListTableView()<UITableViewDataSource, UITableViewDelegate, DownloadCellDelegate>

@end

@implementation MTDownListTableView

- (instancetype)initWithFrame:(CGRect)frame { 
    if (self = [super initWithFrame:frame]) {
        [self registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:nil] forCellReuseIdentifier:@"DownloadCell"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
    }
    return self; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell"];
    cell.delegate = self;
    cell.musicModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

#pragma mark - DownloadCellDelegate

- (void)cellDownLoadFinished:(DownloadCell *)cell musicModel:(MTMusicModel*)model {
//    [_dataArray removeObject:model];
    [cell removeFromSuperview];
    
    if (_downListTableViewRefrestCell) {
        _downListTableViewRefrestCell(model);
    }
}
@end
