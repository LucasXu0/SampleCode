//
//  Person+OtherSkills.h
//  category
//
//  Created by TsuiYuenHong on 2016/9/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "Person.h"


@interface Person (OtherSkills){
    //int i;
    //NSString *str;
}

// 添加实例属性
@property (nonatomic, copy) NSString *otherName;
@property (nonatomic, copy) NSString *otherName2;
// 添加类属性
@property (class, nonatomic, copy) NSString *clsStr;

+ (void)run;
- (void)talk;
// - (void)tanxiaofengsheng;

// 执行实例方法
- (void)logInstProp;
// 执行类方法
+ (void)logClsProp;

@end
