//
//  XKMusicSource.m
//  网络音乐
//
//  Created by xukk on 15-7-29.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import "XKMusicSource.h"
#import <AFNetworking.h>
#import "XKMusicViewController.h"

@implementation XKMusicSource
singleton_implementation(XKMusicSource)

/*
 返回音乐数据
 */
-(void)musicSourceWithMusicName:(NSString *)musicName{
    [[XKMusicSource sharedXKMusicSource] getMusicIDWithMusicUrlOfString:musicName];
}

/*
 获取音乐对应ID
 */
-(void)getMusicIDWithMusicUrlOfString:(NSString *)musicName{
    //1.URL
    NSString *urlStr = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.search.catalogSug&format=json&callback=&query=%@&_=1413017198449",musicName];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //2.AFN网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //2.1因为API返回了多个数据,将AFN解析好的数据传入数组中
        NSArray *songsArray = [responseObject objectForKey:@"song"];
        
        //获取搜索结果的所有歌曲的ID和结果
        for (NSInteger i = 0; i < songsArray.count; i++) {
            self.songsID[i] = [songsArray[i] objectForKey:@"songid"];
            self.singersName[i] = [songsArray[i] objectForKey:@"artistname"];
        }
        
        //获取第一手歌ID和歌手和歌曲名字
        self.songID = [songsArray[0] objectForKey:@"songid"];
        self.singerName = [songsArray[0] objectForKey:@"artistname"];
        self.songName = [songsArray[0] objectForKey:@"songname"];
        
        [[XKMusicSource sharedXKMusicSource] getMusicSourceWithMusicUrlOfString:self.songID];
        NSLog(@"一级缓冲完毕");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"第一个资源错误%@",error);
    }];
}

/**
 获取音乐数据(下载地址等信息)
 */
-(void) getMusicSourceWithMusicUrlOfString:(NSString *)musicID{
    //1.URL
    NSString *urlStr2 = [NSString stringWithFormat:@"http://ting.baidu.com/data/music/links?songIds=%@",musicID];
    urlStr2 = [urlStr2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //2.NSSession网络请求
    NSURL *url2 = [NSURL URLWithString:urlStr2];
    
    __block NSString *urlTmp = [[NSString alloc] init];
    
    __block NSString *strTmp = [[NSString alloc] init];
    
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    
    [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableDictionary *dicts2 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //这个网页JSON貌似是按照 字典->字典->数组->字典 这个顺序解析
        
        //存储字典
        NSDictionary *dict2 = [dicts2 objectForKey:@"data"];

#pragma mark 默认返回是第一首歌曲的信息
        
        //获取歌曲照片
        strTmp = [NSString stringWithString:dict2[@"songList"][0][@"songPicBig"]];
        strTmp = [[self returnRightImageURL:strTmp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.imageURL = [NSURL URLWithString:strTmp];
        //获取歌曲下载地址
        urlTmp= [NSString stringWithString:dict2[@"songList"][0][@"songLink"]];
//        urlTmp = [urlTmp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.downloadURL = [NSURL URLWithString:urlTmp];
        
        [XKMusicViewController sharedXKMusicViewController].downloadBtn.hidden = NO;
        NSLog(@"二级缓冲完毕");
     }];
}

//解析网页JSON中照片的地址
-(NSString *)returnRightImageURL:(NSString *)str{
    
    NSString *subStr = @"http";
    NSArray *array = [str componentsSeparatedByString:subStr];
    NSInteger count = array.count - 1;
    
    if (count == 1) {
        return str;
    }else{
        str = [str substringFromIndex:4];
        NSInteger location = [str rangeOfString:subStr].location;
        str = [str substringFromIndex:location];
        
        location = str.length - 4;
        str = [str substringToIndex:location];
    }
    return str;
}

@end





