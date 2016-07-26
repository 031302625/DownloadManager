//
//  MTASMusicOperation.m
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/17.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import "MTASMusicOperation.h"
#import "DOUSimpleHTTPRequest.h"


@interface MTASMusicOperation (){
    NSData *_data;
    BOOL _finished;
    BOOL _executing;
}

@property (nonatomic, strong)DOUSimpleHTTPRequest *request;

@end

@implementation MTASMusicOperation

@synthesize finished = _finished;
@synthesize executing = _executing;

- (instancetype)initWithModel:(id<MTDownLoadFileProtocol>)musicModel{
    if (self = [super init]) {
        _finished = NO;
        _executing = NO;
        _musicModel = musicModel;
    }
    return self;
}

- (void)start {
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main{
    @try {
         NSLog(@" mainThread: %@, currentThread: %@", [NSThread mainThread], [NSThread currentThread]);
        if (self.isCancelled) return;
        [self startRequest];
    } @catch (NSException *exception) {
        NSLog(@"Exception%@",exception);
    }
}

- (BOOL)isExecuting{
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isConcurrent{
    return YES;
}

- (void)cancel{
    [self willChangeValueForKey:@"isCancelled"];
    [super cancel];
    [self.request cancel];
    [self didChangeValueForKey:@"isCancelled"];
    [self completeOperation];
    
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


- (void)startRequest{
    NSURL *url = [_musicModel audioFileURL];
    self.request = [DOUSimpleHTTPRequest requestWithURL:url];
    [self.request start];
    
    __block typeof (_data) _blockData = _data;
    __weak  typeof (self) _weakSelf = self;
    __block typeof (_musicModel) _blockMusicModel = _musicModel;
    
    [self.request setProgressBlock:^(double progress){
        _weakSelf.progress = progress;
        
        //block
        if (_weakSelf.progressOnChange) {
            _weakSelf.progressOnChange(progress);
        }
    }];
    if (self.isCancelled) {
        [self.request cancel];
        return;
    }
    
    [self.request setCompletedBlock:^(void){
        if (_weakSelf.request.isFailed) {
            
        } else {
            _blockData = _weakSelf.request.responseData;
            if (_blockData) {
                [_weakSelf saveDataToLocalPath:_blockMusicModel.localPath fileName:_blockMusicModel.fileName];
                NSLog(@"保存成功！");
                [_weakSelf willChangeValueForKey:@"isFinished"];
                _finished = YES;
                [_weakSelf didChangeValueForKey:@"isFinished"];
                [_weakSelf willChangeValueForKey:@"isExecuting"];
                _executing = NO;
                [_weakSelf didChangeValueForKey:@"isExecuting"];
             ;

            }
        }
    }];
}

- (BOOL)saveDataToLocalPath:(NSString *)localPath fileName:(NSString *)name{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (!localPath) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/Cache/",NSHomeDirectory()];//沙盒路径
        localPath = path;
    }
    NSString *allPath = [NSString stringWithFormat:@"%@%@",localPath,name];
    
    if (![manager fileExistsAtPath:allPath]) {
        BOOL iswrite = [_data writeToFile:allPath atomically:YES];
        NSLog(@"写入成功");
        return iswrite;
    } else {
        return NO;
    }
}

@end
