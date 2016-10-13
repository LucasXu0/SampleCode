//
//  XKMusicSource.h
//  网络音乐
//
//  Created by xukk on 15-7-29.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface XKMusicSource : NSObject
singleton_interface(XKMusicSource)

/**
 歌曲ID
 */
@property (nonatomic,strong) NSMutableArray *songsID;
/**
 音乐ID
 */
@property (nonatomic,strong) NSString *songID;
/**
 音乐下载地址
 */
@property (nonatomic,strong) NSURL *downloadURL;
/**
 歌手组
 */
@property (nonatomic,strong) NSMutableArray *singersName;
/**
 歌手
 */
@property (nonatomic,copy) NSString *singerName;
/**
 歌曲名
 */
@property (nonatomic,copy) NSString *songName;
/**
 歌曲照片URL
 */
@property (nonatomic,strong) NSURL *imageURL;
/**
 
 */
-(void)musicSourceWithMusicName:(NSString *)musicName;
-(void) getMusicIDWithMusicUrlOfString:(NSString *)musicName;
-(void) getMusicSourceWithMusicUrlOfString:(NSString *)musicID;
@end
