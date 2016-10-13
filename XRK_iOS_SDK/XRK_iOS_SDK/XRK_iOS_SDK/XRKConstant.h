//
//  XRKConstant.h
//  XRK_iOS_SDK
//
//  Created by TsuiYuenHong on 2016/9/3.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

// 一些常用的宏定义

// Debug 控制台打印
#ifdef DEBUG
#define DLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)
#endif

// NSUserDefaults
#define XRK_UserDefaults [NSUserDefaults standardUserDefaults]

// NSNotificationCenter
#define XRK_NotificationCenter [NSNotificationCenter defaultCenter]

// 屏幕
# define XRK_SCREEN_WITCH [UIScreen mainScreen].bounds.size.width
# define XRK_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 状态栏
#define XRK_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define XRK_StatusBarWidth [[UIApplication sharedApplication] statusBarFrame].size.width

//
