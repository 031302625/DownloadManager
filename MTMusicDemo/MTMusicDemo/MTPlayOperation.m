//
//  MTPlayOperation.m
//  MTMusicDemo
//
//  Created by TomWu on 16/7/25.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import "MTPlayOperation.h"

@interface MTPlayOperation () {
    
    BOOL _finished;
    BOOL _executing;

}

@end

@implementation MTPlayOperation

- (instancetype)init{
    if (self = [super init]) {
        _finished = NO;
        _executing = NO;
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
        if (self.isCancelled){
            return;
        }
        if (_playOperation) {
            _playOperation();
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception%@",exception);
    }
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
