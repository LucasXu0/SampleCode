//
//  ViewController+HookOriginMethod.m
//  category
//
//  Created by TsuiYuenHong on 2016/9/12.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "ViewController+HookOriginMethod.h"
#import <objc/runtime.h>

@implementation ViewController (HookOriginMethod)

- (void)viewDidLoad {
    NSLog(@"HOOK SUCCESS! \n--%@-- DidLoad !",[self class]);
    IMP imp = [self getOriginMethod:@"viewDidLoad"];
    ((void (*)(id, SEL))imp)(self, @selector(viewDidLoad));
}

- (void)testForHook:(NSString *)str1{
    NSLog(@"HOOK SUCCESS \n--%s-- 执行",_cmd);
    IMP imp = [self getOriginMethod:@"testForHook:"];
    ((void (*)(id, SEL, ...))imp)(self, @selector(testForHook:), str1);
}

- (IMP)getOriginMethod:(NSString *)originMethod{
    // 获取 Person 的方法列表
    unsigned int methodCount;
    // 获取实例方法
    Method *VCMethodList = class_copyMethodList([self class], &methodCount);

    IMP imp = NULL;
    
    // 这里是倒序获取，所以 mArr 第一个方法对应的是 Person 类中最后一个方法
    for (int i = methodCount - 1; i >= 0; i--) {

        Method method = VCMethodList[i];
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method))
                                                  encoding:NSUTF8StringEncoding];

        if ([originMethod isEqualToString:methodName]) {
            imp = method_getImplementation(method);
            break;
        }
    }
    
    free(VCMethodList);
    return imp;
}

@end
