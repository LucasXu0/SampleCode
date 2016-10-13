//
//  UIButton+Category.m
//  category
//
//  Created by TsuiYuenHong on 2016/9/11.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>

static const void *kk_actionHandlerBlock = &kk_actionHandlerBlock;

@implementation UIButton (Category)

- (void)kk_addActionHandler:(ActionHandlerBlock)actionHandler ForControlEvents:(UIControlEvents)controlEvents{

    // 关联 actionHandler
    objc_setAssociatedObject(self, kk_actionHandlerBlock, actionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // 设置点击事件
    [self addTarget:self action:@selector(handleAction) forControlEvents:controlEvents];
}

// 处理点击事件
- (void)handleAction{
    
    ActionHandlerBlock actionHandlerBlock = objc_getAssociatedObject(self, kk_actionHandlerBlock);
    
    if (actionHandlerBlock) {
        actionHandlerBlock();
    }
}

- (ActionHandlerBlock)actionHandlerBlock{
    return objc_getAssociatedObject(self, @selector(actionHandlerBlock));
}

- (void)setActionHandlerBlock:(ActionHandlerBlock)actionHandlerBlock{
    objc_setAssociatedObject(self, @selector(actionHandlerBlock), actionHandlerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
