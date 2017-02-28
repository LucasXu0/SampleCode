//
//  SecondViewController.m
//  BlockDemo
//
//  Created by TsuiYuenHong on 2017/2/27.
//  Copyright © 2017年 TsuiYuenHong. All rights reserved.
//

#import "SecondViewController.h"
#import "Test.h"

@interface SecondViewController ()

@property (nonatomic, copy) NSString *kkString;
@property (nonatomic, strong) Test *testClass;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _kkString = @"TsuiYuenHong";
    _testClass = [Test new];
    
    //[self testNormalBlock];
    //[self testNormalBlockWithWeakStrongDance];
    [self testTargetBlock];
}

// 循环引用
- (void)testNormalBlock{
    [_testClass excuteNormalBlockWithParameter:_kkString CompletedBlock:^(NSString *string) {
        NSDictionary *dict = @{_kkString:string};
        NSLog(@"%@",dict);
    }];
}

// weak strong dance 不会循环引用
- (void)testNormalBlockWithWeakStrongDance{
    __weak typeof(self) wSelf = self;
    [_testClass excuteNormalBlockWithParameter:_kkString CompletedBlock:^(NSString *string) {
        if (!wSelf) return; // 注意判空 （可测试:注释该行，跳转后5秒内返回第一页，会出现 crash）
        __strong typeof(self) sSelf = wSelf; // 防止以下操作过程中 wSelf 被释放
        NSDictionary *dict = @{sSelf.kkString:string};
        NSLog(@"%@",dict);

        // 注释 44 - 46 行代码并执行一下代码，在 for 循环过程中返回第一页，就知道 __strong typeof(self) sSelf = wSelf; 有什么用了
//        NSMutableArray *mArr = [NSMutableArray array];
//        for (int i = 0; i < 100000; i ++) {
//            [mArr addObject:wSelf.kkString];
//            NSLog(@"%@",wSelf.kkString);
//        }
    }];
}

// 不用 weak strong dace 也不会循环引用，不过会延长生命周期
- (void)testTargetBlock{
    [_testClass excuteTargetBlockWithTarget:self Parameter:_kkString CompletedBlock:^(typeof(self) target, NSString *string) {
        NSDictionary *dict = @{target.kkString:string};
        NSLog(@"%@",dict);
    }];
}

- (void)logHelloWorld{
    NSLog(@"Hello World");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"--- SecondViewController Class DisAppear ---");
}

- (void)dealloc{
    NSLog(@"--- SecondViewController Class Dealloc ---");
}

@end
