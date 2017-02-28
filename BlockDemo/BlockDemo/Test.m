//
//  Test.m
//  BlockDemo
//
//  Created by TsuiYuenHong on 2017/2/27.
//  Copyright © 2017年 TsuiYuenHong. All rights reserved.
//

#import "Test.h"

@implementation Test

- (void)excuteNormalBlockWithParameter:(NSString *)string CompletedBlock:(NormalBlock)completedBlock{
   
    self.normalBlock = [completedBlock copy];
    
    // 延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        // 处理本来的参数
        NSString *newString = [NSString stringWithFormat:@"-- %@ --",string];
        self.normalBlock(newString);
    });
}

- (void)excuteTargetBlockWithTarget:(id)target Parameter:(NSString *)string CompletedBlock:(TargetBlock)completedBlock{
   
    self.targetBlock = [completedBlock copy];
    
    // 延时操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        // 处理本来的参数
        NSString *newString = [NSString stringWithFormat:@"-- %@ --",string];
        self.targetBlock(target,newString);
    });
}

- (void)dealloc{
    NSLog(@"--- Test Class Dealloc ---");
}

@end
