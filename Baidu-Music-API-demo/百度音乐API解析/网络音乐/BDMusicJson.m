//
//  BDMusicJson.m
//  网络音乐
//
//  Created by xukk on 15-7-29.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import "BDMusicJson.h"
#import "BDMusic.h"

@implementation BDMusicJson

+(instancetype)musicJson{
    //百度音乐API
    NSString *urlStr = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.search.catalogSug&format=json&callback=&query=%@&_=1413017198449",@"平凡之路"];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    return 0;
}

@end
