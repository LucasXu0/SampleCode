//
//  XKMusicDownload.h
//  网络音乐
//
//  Created by xukk on 15-7-29.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKMusicSource.h"
#import "Singleton.h"

@interface XKMusicDownload : NSObject
singleton_interface(XKMusicDownload)
/*
 歌曲存储路径
 */
@property (nonatomic,strong) NSURL *songURL;

-(void)songURLWithDownloadURL:(NSURL *)downloadURL;

@end
