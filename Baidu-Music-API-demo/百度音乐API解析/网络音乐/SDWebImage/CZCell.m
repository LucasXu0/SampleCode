
//
//  CZCell.m
//  SDWbeImage
//
//  Created by xukk on 15-7-27.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import "CZCell.h"

@implementation CZCell

+ (instancetype) cellWithDic:(NSDictionary *)dic{
    CZCell *app = [[CZCell alloc] init];
    [app setValuesForKeysWithDictionary:dic];
    return app;
}

+ (NSArray *) cellsList{
    //加载plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    
    //字典转模型
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        CZCell *cell = [CZCell cellWithDic:dic];
        [tmpArray addObject:cell];
    }
    return tmpArray;
}

@end
