//
//  ViewController.m
//  网络音乐
//
//  Created by xukk on 15-7-28.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import "XKMusicSource.h"


@interface ViewController ()<AVAudioPlayerDelegate>
@property (nonatomic,strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UITextField *songname;
@property (nonatomic,retain) AVAudioPlayer *player;
@property (nonatomic,strong) __block NSURL *downURL;
@end

@implementation ViewController



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getMusicIDWithMusicUrlOfString:@"平凡之路"];
    
}
- (IBAction)getMusicUrl:(id)sender {
    self.downURL = [NSURL URLWithString: @"http://zhangmenshiting.baidu.com/data2/music/38542270/382338211365422461.mp3?xcode=808f67065a7ea25b17e77954bed13215"];
    NSLog(@"%@",self.downURL);

    dispatch_async(dispatch_get_main_queue(), ^{
        [self musicJson];
        NSLog(@"获取完成--%@",self.downURL);
    });
    
    
}

-(NSNumber *)getMusicIDWithMusicUrlOfString:(NSString *)musicName{
    //1.URL
    NSString *urlStr = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.search.catalogSug&format=json&callback=&query=%@&_=1413017198449",musicName];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //2.AFN网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *songsArray = [responseObject objectForKey:@"song"];
        NSLog(@"%@",songsArray[0]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    return 0;
}

- (void)musicJson{

    //百度音乐API
    NSString *urlStr = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?from=webapp_music&method=baidu.ting.search.catalogSug&format=json&callback=&query=%@&_=1413017198449",self.songname.text];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
//    __block NSURL *lastURL = [[NSURL alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",result);
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *l = [dic objectForKey:@"song"];
//        NSLog(@"%@",l[0]);
//        NSLog(@"%@",l[0][@"songid"]);
        
        NSString *downloadStr = [NSString stringWithFormat:@"http://ting.baidu.com/data/music/links?songIds=%@",l[0][@"songid"]];
        NSURL *downloadURL = [NSURL URLWithString:downloadStr];
        
        NSURLRequest *request2 = [NSURLRequest requestWithURL:downloadURL];
        
        __block NSString *urlStr = [[NSString alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSMutableDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",dic2[@"data"]);
            NSDictionary *l2 = [dic2 objectForKey:@"data"];
//            NSLog(@"%lu",(unsigned long)[l2[@"songList"] count]);
//            for (NSDictionary * dict2 in l2[@"songList"][0]){
//                NSLog(@"%@",dict2);
//            }
            NSLog(@"这是获取中%@",l2[@"songList"][0][@"songLink"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                urlStr = [NSString stringWithString:l2[@"songList"][0][@"songLink"] ];
                urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                self.downURL = [NSURL URLWithString:urlStr];
                NSLog(@"%@",self.downURL);
            });

        }];
     }];
    
//    NSLog(@"获取中2%@",lastURL);
//    return lastURL;
}

- (IBAction)download {
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
//    __block NSURL *urlStr= [[NSURL alloc] init] ;
    

//    
//    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
//        urlStr = [self musicJson];
//         NSLog(@"下载的url%@",urlStr);
//    }];
    
//    NSString *urlStr = @"http://zhangmenshiting.baidu.com/data2/music/38542270/382338211365422461.mp3?xcode=808f67065a7ea25b17e77954bed13215";
    
   
    
//    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",self.downURL);
    
        NSURLRequest *request = [NSURLRequest requestWithURL:self.downURL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {
            
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
            NSString *lastName = [NSString stringWithString:[response suggestedFilename]];
            
            lastName = [lastName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *lastURL = [downloadURL URLByAppendingPathComponent:lastName];
            
            return lastURL;
            
        } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
            //此处已经在主线程了
            self.url = filePath;
            
            NSLog(@"下载完成%@",self.url);
        }];
        
        [downloadTask resume];
//    }];
//    [op2 addDependency:op1];
//    [queue addOperation:op1];
//    [queue addOperation:op2];

    
}

- (IBAction)play:(id)sender {
    
    
    self.player.delegate = self;
    
    NSLog(@"%@",self.url);
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.url error:nil];
    
    if ([self.player prepareToPlay]) {
        NSLog(@"准备成功");
    }
    if ([self.player play]) {
        NSLog(@"播放成功");
    }
}

- (void)session{
    NSString *urlStr = @"http://zhangmenshiting.baidu.com/data2/music/38542270/382338211365422461.mp3";
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",location.path);
        NSLog(@"%@",[[NSBundle mainBundle] pathForResource:location.path.lastPathComponent ofType:nil]);
    }];
    
    [task resume];
}

@end
