//
//  XKMusicViewController.m
//  网络音乐
//
//  Created by xukk on 15-7-29.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import "XKMusicViewController.h"
#import "CZMusicTool.h"
#import "XKMusicDownload.h"
#import "XKMusicSource.h"
#import "UIImageView+WebCache.h"

@interface XKMusicViewController()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *songTextField;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (nonatomic,retain) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIImageView *songImage;

@end

@implementation XKMusicViewController
singleton_implementation(XKMusicViewController)


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.downloadBtn.hidden = YES;
    
    //创建数据库
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingString:@"/music.sqlite"];
    
    //提供一个多线程安全的数据库实例
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    NSLog(@"%@ -- %@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES)[0],filePath);
    [queue inDatabase:^(FMDatabase *db) {
        BOOL flag1 = [db executeUpdate:@"create table if not exists t_music (id integer primary key autoincrement,song text,singer text,musicURL text);"];
        _musicDB = db;
        if (flag1) {
            NSLog(@"数据库创建成功");
        }else{
            NSLog(@"创建失败");
        }
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)getMusic {
    self.downloadBtn.hidden = YES;
    
    if ([self searchCacheMusic] == YES) {
        NSLog(@"本地已经缓存");
    }else{
        [[XKMusicSource sharedXKMusicSource] musicSourceWithMusicName:self.songTextField.text];
    }
}

- (IBAction)downloadMusic {
    [[XKMusicDownload sharedXKMusicDownload] songURLWithDownloadURL:[XKMusicSource sharedXKMusicSource].downloadURL];

    dispatch_async(dispatch_get_main_queue(), ^{
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:app.icon] placeholderImage:[UIImage imageNamed:@"user_default"]];
        
        [self.songImage sd_setImageWithURL:[XKMusicSource sharedXKMusicSource].imageURL];
        self.singerName.text = [XKMusicSource sharedXKMusicSource].singerName;
        self.songName.text = [XKMusicSource sharedXKMusicSource].songName;
    });
}

- (IBAction)playMusic {
    [CZMusicTool sharedCZMusicTool].player.delegate = self;

    NSLog(@"%@",[XKMusicDownload sharedXKMusicDownload].songURL);
    
    [[CZMusicTool sharedCZMusicTool] prepareToPlayWith:[XKMusicDownload sharedXKMusicDownload].songURL];
    [[CZMusicTool sharedCZMusicTool] play];
}

- (IBAction)clean {
    [_musicDB executeUpdate:@"delete from t_music;"];
    NSLog(@"删除表完成");
}


#pragma mark 判断是否已有本地缓存
/*
 只完成了歌曲,歌手和歌曲名缓存.没有做照片!
 */
- (BOOL)searchCacheMusic{
    NSString *singerName = [_musicDB stringForQuery:@"select singer from t_music where song = ?",self.songTextField.text];
    
    if (singerName) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [documentPath stringByAppendingFormat:@"/%@.mp3",self.songTextField.text] ;
        filePath = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@ ",filePath);
        self.songName.text = self.songTextField.text;
        self.singerName.text = singerName;
        [XKMusicDownload sharedXKMusicDownload].songURL = [NSURL URLWithString:filePath];
        return YES;
    }
    return NO;
}







@end
