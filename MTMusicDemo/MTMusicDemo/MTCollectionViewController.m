//
//  MTCollectionViewController.m
//  MTMusicDemo
//
//  Created by Cheng on 16/7/22.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import "MTCollectionViewController.h"
#import "MTCollectionViewCell.h"
#import "MTMusicModel+Provider.h"
#import "MTOperationQueueManager.h"
#import "MTASMusicOperation.h"
#import "MTConstant.h"
#import "DOUAudioStreamer.h"
#import "MTPopView.h"
#import "MTDownListTableView.h"
#import "MTPlayOperation.h"

@interface MTCollectionViewController()<MTCollectionViewCellDelegate> {
    NSArray *_musicArray;
    NSMutableDictionary *_playButtonDict;
    NSMutableArray *_downListArray;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *downLookButton;
@property (nonatomic, strong) DOUAudioStreamer *streamer;
@property (nonatomic, strong) MTPopView *popView;
@property (nonatomic, strong) MTDownListTableView *tableView;
@end

@implementation MTCollectionViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.titleLabel;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.downLookButton];
    
    [self.collectionView registerClass:[MTCollectionViewCell class] forCellWithReuseIdentifier:@"MTCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 10.0f;
    CGFloat space = 5.0f;
    CGFloat width = (self.collectionView.bounds.size.width - 2 * space - 2 * margin) / 3;
    
    layout.sectionInset = UIEdgeInsetsMake(44, margin, 0, margin);
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = space;
    layout.minimumInteritemSpacing = space;
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setCollectionViewLayout:layout];
    
    //add music data 
    _musicArray = [MTMusicModel modelsData];
    _playButtonDict = [NSMutableDictionary dictionary];
    _downListArray = [NSMutableArray array];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _musicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTCollectionViewCell *cell = (MTCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MTCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item < _musicArray.count) {
        cell.musicModel = [_musicArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MTCollectionViewCell *cell = (MTCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.item < _musicArray.count) {
//        NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(playWithCurrentModel:) object:[_musicArray objectAtIndex:indexPath.item]];
        MTPlayOperation *playOperation = [[MTPlayOperation alloc]init];
        playOperation.playOperation = ^{
            [self playWithCurrentModel:[_musicArray objectAtIndex:indexPath.item]];
        };
        [[MTOperationQueueManager sharedManager] addPlayOperation:playOperation];
        [self.streamer play];
    
        cell.currentMusicItem = indexPath.item;
    }
}

#pragma mark - Getter
 
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择音乐";
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)downLookButton { 
    if (!_downLookButton) {
        _downLookButton = [[UIButton alloc] init];
        _downLookButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_downLookButton setTitle:@"下载管理" forState:UIControlStateNormal];
        [_downLookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downLookButton addTarget:self action:@selector(downLoadListShow) forControlEvents:UIControlEventTouchUpInside];
        [_downLookButton sizeToFit];
    }
    return _downLookButton; 
}

#pragma mark - Class Methods

- (void)initializePopDownListView {
    //add button
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(300 - 44 - 5, 0, 44, 44)];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //add label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = @"下载列表";
    
    NSDictionary *attrs = @{NSFontAttributeName : label.font};
    CGSize labeSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    //add barView
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    barView.backgroundColor = [UIColor colorWithRed:247.0 / 255.0f green:78.0 / 255.0f blue:120.0 / 255.0f alpha:1.0f];
     
    //label size
    CGFloat labelX = (barView.bounds.size.width - labeSize.width) * 0.5;
    CGFloat labelY = (barView.bounds.size.height - labeSize.height) * 0.5;
    label.frame = CGRectMake(labelX, labelY, labeSize.width, labeSize.height);
    
    //add tableView
    self.tableView = [[MTDownListTableView alloc] initWithFrame:CGRectMake(0, 44, 300, 360)];
    
    //add container
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 404)];
    
    [barView addSubview:label];
    [barView addSubview:closeButton];
    [containerView addSubview:barView];
    [containerView addSubview:self.tableView];
    
    //初始化PopView
    self.popView = [[MTPopView alloc] initPopViewWith:containerView];
}

- (void)downLoadListShow {
    NSLog(@"downLoadListShow");
    //init popDownListView
    [self initializePopDownListView];
    
    __block typeof(_downListArray) _blockDownListArray = _downListArray;
    __weak typeof(self) _weakSelf = self;
    
    [self.tableView setDownListTableViewRefrestCell:^(MTMusicModel *model) {
        [_blockDownListArray removeObject:model];
        [_weakSelf.tableView reloadData];
    }];
    
    //传递数据
    self.tableView.dataArray = _downListArray;
    
    [self.popView showInParentView:[UIApplication sharedApplication].keyWindow animation:MTAnimationStyleSlideFromTop completion:nil];
}

- (void)closeButtonClick {
    [self.popView dissmissAnimation:MTAnimationStyleSlideFromTop completion:nil];
}

#pragma mark - Delegate

- (void)cellDownLoadButtonClicke:(MTCollectionViewCell *)cell currentDownLoadModel:(MTMusicModel *)model downLoadProgressView:(UIProgressView *)progressView {
    [[MTOperationQueueManager sharedManager] startWithMusicModel:model];
    [model.operation setProgressOnChange:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress = progress;
            //比较大小
            if (fabs(progress - 1.0) <= MT_EPSILON) {
                [progressView removeFromSuperview];
            }
        });
    }];
    //添加当前已经点击下载的model
    [_downListArray addObject:model];
}

//- (void)cellPlayButtonClicke:(MTCollectionViewCell *)cell currentPlayModel:(MTMusicModel *)model {
//    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(playWithCurrentModel:) object:model];
//    [[MTOperationQueueManager sharedManager] addPlayOperation:invocationOperation];
//}

- (void)playWithCurrentModel:(MTMusicModel *)model {
    self.streamer = [DOUAudioStreamer streamerWithAudioFile:model];
    [self.streamer play];
}
@end
