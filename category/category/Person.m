//
//  Perosn.m
//  category
//
//  Created by TsuiYuenHong on 2016/9/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "Person.h"

@implementation Person

// 原方法
- (void)talk{
    NSLog(@"\n我是原实例方法\n我是%@",self.name);
}

+ (void)run{
    NSLog(@"\n我是原类方法\n我是跑得很快的的香港记者");
}

@end
