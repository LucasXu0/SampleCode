//
//  ViewController.m
//  fmdb
//
//  Created by xukk on 15-7-28.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()
@property (nonatomic,strong) FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSString *filePath = [cachePath stringByAppendingString:@"contact.sqlite"];
    
    //提供一个多线程安全的数据库实例
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    [queue inDatabase:^(FMDatabase *db) {
        BOOL flag1 = [db executeUpdate:@"create table if not exists t_contact (id integer primary key autoincrement,name text,phone text);"];
        
        _db = db;
        if (flag1) {
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
        }
        
    }];
}

- (IBAction)insert:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL flag = [_db executeUpdate:@"insert into t_contact (name,phone) values (?,?)",@"xukk",@"1560232"];
        if (flag) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    });

}
- (IBAction)delete:(id)sender {
    BOOL flag = [_db executeUpdate:@"delete from t_contact;"];
    if (flag) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}
- (IBAction)change:(id)sender {
    
}
- (IBAction)search:(id)sender {
    FMResultSet *result = [_db executeQuery:@"select * from t_contact"];
    
    while ([result next]) {
        NSString *name = [result stringForColumn:@"name"];
        NSString *phone = [result stringForColumn:@"phone"];
        NSLog(@"%@--%@",name,phone);
    }

}


@end
