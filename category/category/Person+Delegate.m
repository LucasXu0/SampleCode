//
//  Person+Delegate.m
//  category
//
//  Created by TsuiYuenHong on 2016/9/11.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "Person+Delegate.h"
#import <objc/runtime.h>

@implementation Person (Delegate)

- (id<PersonDelegate>)delegate{
    return objc_getAssociatedObject(self, @selector(delegate));
}

- (void)setDelegate:(id<PersonDelegate>)delegate{
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

// 谈笑风生完就要上电视了
- (void)tanxiaofengsheng{
    for (int i = 0 ; i < 10; i ++) {
        NSLog(@"谈笑风生...");
    }
    
    if ([self.delegate respondsToSelector:@selector(showInTV)]) {
        [self.delegate showInTV];
    }
}

@end
