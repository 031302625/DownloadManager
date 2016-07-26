//
//  MTPlayOperation.h
//  MTMusicDemo
//
//  Created by TomWu on 16/7/25.
//  Copyright © 2016年 TomWu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PlayOperation)(void);

@interface MTPlayOperation : NSOperation

@property(nonatomic, copy)PlayOperation playOperation;

@end
