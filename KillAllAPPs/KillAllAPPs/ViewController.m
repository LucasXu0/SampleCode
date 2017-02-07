//
//  ViewController.m
//  KillAllAPPs
//
//  Created by TsuiYuenHong on 2017/2/7.
//  Copyright © 2017年 TsuiYuenHong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *allBundleIDs = [self getAllApplicationBundleIDs];
    [allBundleIDs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self killAPPWithBundleID:obj];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method 

/**
 终结指定 bundle id 的 APP

 @param bundleID bundle id
 */
- (void)killAPPWithBundleID:(NSString *)bundleID{
    
    Class class_BKSSystemService = objc_getClass("BKSSystemService");
    NSObject *bksSS = [[class_BKSSystemService alloc] init];
    
    /*
    该私有 API 含有2个以上参数，不可以使用以下方法调用

    if ([bksSS respondsToSelector:@selector(terminateApplication: forReason: andReport: withDescription:)]) {
        [bksSS performSelector:@selector(terminateApplication: forReason: andReport: withDescription:) withObject:nil];
    }
    */
    
    // 判断是否存在方法
    if ([[bksSS class] instancesRespondToSelector:@selector(terminateApplication: forReason: andReport: withDescription:)]) {
        // 获取方法签名
        NSMethodSignature *signature = [[bksSS class] instanceMethodSignatureForSelector:@selector(terminateApplication: forReason: andReport: withDescription:)];
        
        // 包装方法
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:bksSS];
        [invocation setSelector:@selector(terminateApplication: forReason: andReport: withDescription:)];
        
        // 设置参数
        CFStringRef appBundleID = (__bridge CFStringRef)bundleID;
        int reason = 0;
        bool report = NO;
        id description = NULL;
        
        [invocation setArgument:&appBundleID atIndex:2];
        [invocation setArgument:&reason atIndex:3];
        [invocation setArgument:&report atIndex:4];
        [invocation setArgument:&description atIndex:5];
        [invocation retainArguments];
        
        [invocation invoke];
    }
}


/**
 获取全部 APP 的 bundle id
 注意 ： 该方法过滤掉含有 apple 的 bundle id

 @return bundle ids
 */
- (NSArray *)getAllApplicationBundleIDs{
    
    // 获取全部 app
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *allApps = [workspace performSelector:@selector(allApplications)];
    
    // 枚举遍历获取 bundle id
    NSMutableArray *allBundleIDs = [NSMutableArray array];
    [allApps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *bundleID = [obj performSelector:@selector(bundleIdentifier)];
        if (![bundleID containsString:@"apple"]) {
            [allBundleIDs addObject:bundleID];
        }
    }];
    
    return allBundleIDs;
}

@end
