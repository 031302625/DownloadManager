//
//  MTMusicModel.h
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/23.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTDownLoadFileProtocol.h"

@class MTASMusicOperation;

@interface MTMusicModel : NSObject<MTDownLoadFileProtocol>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSURL *audioFileURL;
@property (nonatomic, strong) MTASMusicOperation *operation;

@end
