//
//  MTDownLoadFileProtocol.h
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/23.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DOUAudioFile.h"

@class MTASMusicOperation;

@protocol MTDownLoadFileProtocol <NSObject, DOUAudioFile>

@required
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) MTASMusicOperation *operation;

@optional

- (NSString *)localPath;

@end
