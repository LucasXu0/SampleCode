//
//  XKMusicDownload.m
//  网络音乐
//
//  Created by xukk on 15-7-29.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import "XKMusicDownload.h"
#import <AFNetworking.h>
#import "XKMusicSource.h"
#import "XKMusicViewController.h"

@implementation XKMusicDownload
singleton_implementation(XKMusicDownload)

-(void)songURLWithDownloadURL:(NSURL *)downloadURL{
    
    //AFN网络请求
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    
    //AFN下载
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *songURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //拼接下载路径
        NSString *lastName = [NSString stringWithFormat:@"%@.mp3",[XKMusicSource sharedXKMusicSource].songName];
        lastName = [lastName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *lastURL = [songURL URLByAppendingPathComponent:lastName];
        return lastURL;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        self.songURL = filePath;
        
        //将下载歌曲写入数据库
        [[XKMusicViewController sharedXKMusicViewController].musicDB executeUpdate:@"insert into t_music (song,singer,musicURL) values (?,?,?)",[XKMusicSource sharedXKMusicSource].songName,[XKMusicSource sharedXKMusicSource].singerName,self.songURL];
        
        [XKMusicViewController sharedXKMusicViewController].downloadBtn.hidden = YES;
        NSLog(@"下载完成");
    }];
    
    //开启下载
    [downloadTask resume];
    
}

@end
