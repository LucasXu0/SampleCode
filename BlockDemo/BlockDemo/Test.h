//
//  Test.h
//  BlockDemo
//
//  Created by TsuiYuenHong on 2017/2/27.
//  Copyright © 2017年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NormalBlock)(NSString *string);
typedef void(^TargetBlock)(id target, NSString *string);

@interface Test : NSObject

@property (nonatomic, copy) TargetBlock targetBlock;
@property (nonatomic, copy) NormalBlock normalBlock;

- (void)excuteNormalBlockWithParameter:(NSString *)string
                     CompletedBlock:(NormalBlock )completedBlock;

- (void)excuteTargetBlockWithTarget:(id )target
                          Parameter:(NSString *)string
                     CompletedBlock:(TargetBlock )completedBlock;

@end
