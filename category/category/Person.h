//
//  Perosn.h
//  category
//
//  Created by TsuiYuenHong on 2016/9/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

+ (void)run;
- (void)talk;

@end
