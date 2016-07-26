//
//  MTOperationQueueManager.m
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/18.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import "MTOperationQueueManager.h"
#import "MTASMusicOperation.h"


static MTOperationQueueManager *mt_musicOperationManager = nil;

@interface MTOperationQueueManager (){
    NSMutableArray *_musicModels;
}
@property (nonatomic ,strong) NSOperationQueue *queue;
@end

@implementation MTOperationQueueManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        mt_musicOperationManager = [[self alloc] init];
    });
    return mt_musicOperationManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _musicModels = [[NSMutableArray alloc]init];
        self.queue = [[NSOperationQueue alloc]init];
        self.queue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)setMaxCurrentOperationCount:(NSInteger)maxCurrentOperationCount{
    if (maxCurrentOperationCount) {
        self.queue.maxConcurrentOperationCount = maxCurrentOperationCount;
    }
}

- (NSArray *)musicModels { 
    return _musicModels;
}

- (void)addMusicModels: (NSArray <MTDownLoadFileProtocol>*)musicModels {
    if ([musicModels isKindOfClass:[NSArray class]]) {
        [_musicModels addObjectsFromArray:musicModels];
    }
}

- (void)startWithMusicModel:(id<MTDownLoadFileProtocol>)musicModel{
    if (musicModel.operation == nil) {
        musicModel.operation = [[MTASMusicOperation alloc] initWithModel:musicModel];
    }
    //添加operation判断避免出现重复添加
    if (musicModel.operation.isExecuting || musicModel.operation.isFinished) {
    }else{
        [self.queue addOperation:musicModel.operation];
       NSLog(@"queue  %@",self.queue.operations);
    }
}

- (void)stopWithMusicModel:(id<MTDownLoadFileProtocol>)musicModel {
    if (musicModel.operation) {
        [musicModel.operation cancel];
    }
}

- (void)addPlayOperation:(MTPlayOperation *)playOperation{
    [playOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.queue addOperation:playOperation];
    NSLog(@"queue  %@", self.queue.operations);
}
@end
