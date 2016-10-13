//
//  XKMusicViewController.h
//  网络音乐
//
//  Created by xukk on 15-7-29.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import "ViewController.h"
#import "Singleton.h"
#import "FMDB.h"

@interface XKMusicViewController : ViewController

singleton_interface(XKMusicViewController)

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (nonatomic,strong) FMDatabase *musicDB;
@end
