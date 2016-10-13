//
//  Person+Delegate.h
//  category
//
//  Created by TsuiYuenHong on 2016/9/11.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "Person.h"

// 添加协议
@protocol PersonDelegate <NSObject>

- (void)showInTV;

@end

@interface Person (Delegate)

// 添加 delegate
@property (nonatomic, weak) id<PersonDelegate> delegate;

- (void)tanxiaofengsheng;

@end
