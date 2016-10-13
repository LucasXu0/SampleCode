//
//  Person+OtherSkills.m
//  category
//
//  Created by TsuiYuenHong on 2016/9/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "Person+OtherSkills.h"
#import <objc/runtime.h>

static NSString *_clsStr = nil;
static NSString *_otherName = nil;

@implementation Person (OtherSkills)

@dynamic otherName;

+ (void)run{
    // 警告⚠️ Category is implementing a method which will also be implemented by its primary class
    NSLog(@"\n我是重写方法\n我是跑得很快的的香港记者");
}

// 重写方法
- (void)talk{
    // 警告⚠️ Category is implementing a method which will also be implemented by its primary class
    NSLog(@"\n我是重写方法\n我是会谈笑风生的%@",self.otherName);
}

- (void)tanxiaofengsheng{
    NSLog(@"\n我是Category的方法\n我是会谈笑风生的%@",self.otherName);
}

- (void)logInstProp{
    NSLog(@"\n输出实例属性\n我是会谈笑风生的%@",self.otherName);
}

+ (void)logClsProp{
    NSLog(@"\n输出类属性\n我是会谈笑风生的%@",self.clsStr);
}

+ (NSString *)clsStr{
    return _clsStr;
}

+ (void)setClsStr:(NSString *)clsStr{
    _clsStr = clsStr;
}

- (NSString *)otherName{
    return _otherName;
}

- (void)setOtherName:(NSString *)otherName{
    _otherName = otherName;
}

- (NSString *)otherName2{
    return objc_getAssociatedObject(self, @selector(otherName2));
}

- (void)setOtherName2:(NSString *)otherName2{
    objc_setAssociatedObject(self, @selector(otherName2), otherName2, OBJC_ASSOCIATION_COPY);
}




@end
