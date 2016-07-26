//
//  MTMusicModel+Provider.m
//  MTDouASPlayer
//
//  Created by TomWu on 16/7/23.
//  Copyright © 2016年 TomWu_wxd. All rights reserved.
//

#import "MTMusicModel+Provider.h"
#import "MTASMusicOperation.h"

@implementation MTMusicModel (Provider)

+(void)load{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self modelsData];
    });
    
}

+ (NSArray *)modelsData{
    
    static NSArray *models = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        models = [self onlineQueue];
    });
    return models;
}

+ (NSArray *)onlineQueue{
    static NSArray *tracks = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://oakbcmhd4.bkt.clouddn.com/music_list2.txt"]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:NULL
                                                     error:NULL];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    NSMutableArray *allTracks = [NSMutableArray array];
    
    for (NSDictionary *data in [dict objectForKey:@"data"]) {
        MTMusicModel *musicModel = [[MTMusicModel alloc] init];
        
        [musicModel setFileName:[data objectForKey:@"file_name"]];
        [musicModel setImageUrl:[data objectForKey:@"pic"]];
        [musicModel setTitle:[data objectForKey:@"title"]];
        
        if (musicModel.operation == nil) {
            musicModel.operation = [[MTASMusicOperation alloc] initWithModel:musicModel];
        }
        
        [musicModel setAudioFileURL:[NSURL URLWithString:[data objectForKey:@"music_url"]]];
        [allTracks addObject:musicModel];
    }
    
    tracks = [allTracks copy];
    return tracks;
}

@end
