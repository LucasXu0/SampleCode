//
//  CZCell.h
//  SDWbeImage
//
//  Created by xukk on 15-7-27.
//  Copyright (c) 2015年 徐kk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZCell : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *download;
@property (nonatomic,strong) UIImage *image;

+ (instancetype) cellWithDic: (NSDictionary *) dic;

+ (NSArray *) cellsList;


@end
