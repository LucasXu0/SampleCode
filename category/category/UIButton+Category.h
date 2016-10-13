//
//  UIButton+Category.h
//  category
//
//  Created by TsuiYuenHong on 2016/9/11.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionHandlerBlock)(void);

@interface UIButton (Category)

// 点击响应的 block
@property (nonatomic, copy) ActionHandlerBlock actionHandlerBlock;

// 设置 UIButton 的点击事件
- (void)kk_addActionHandler: (ActionHandlerBlock )actionHandlerBlock ForControlEvents:(UIControlEvents )controlEvents;

@end
