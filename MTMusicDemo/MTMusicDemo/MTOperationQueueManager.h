//
//  MTOperationQueueManager.h
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/18.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUSimpleHTTPRequest.h"
#import "MTDownLoadFileProtocol.h"
#import "MTPlayOperation.h"



@interface MTOperationQueueManager : NSObject

@property (nonatomic, copy) NSArray *musicModels;
/**最大并发数*/
@property (nonatomic, assign) NSInteger maxCurrentOperationCount;

+ (instancetype)sharedManager;

- (void)addMusicModels:(NSArray <MTDownLoadFileProtocol>*)musicModels;

- (void)startWithMusicModel:(id<MTDownLoadFileProtocol>)musicModel;
- (void)stopWithMusicModel:(id<MTDownLoadFileProtocol>)musicModel;

- (void)addPlayOperation:(MTPlayOperation *)playOperation;

@end
