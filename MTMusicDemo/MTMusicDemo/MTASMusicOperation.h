//
//  MTASMusicOperation.h
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/17.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTDownLoadFileProtocol.h"

typedef void(^MTProgressChange)(double);

@interface MTASMusicOperation : NSOperation

@property (nonatomic, assign) NSInteger downLoadSpeed;        /**下载速度*/
@property (nonatomic, assign) double progress;                /**下载进度*/
@property (nonatomic, weak) id <MTDownLoadFileProtocol>musicModel;
@property (nonatomic, copy) MTProgressChange progressOnChange;

- (instancetype)initWithModel:(id<MTDownLoadFileProtocol>)musicModel;

@end
