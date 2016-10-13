//
//  KKTableViewDataSource.h
//  DataSource 解耦
//
//  Created by TsuiYuenHong on 2016/10/13.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^KKTableViewCellConfigBlock)(id cell, id data);

// UITableViewDataSource
typedef UITableViewCell *(^CellConfigBlock)(UITableView *tableView, NSIndexPath *indexPath);
typedef NSInteger (^RowConfigBlock)(UITableView *tableView, NSInteger section);
typedef NSInteger (^SectionConfigBlock)(UITableView *tableView);

// UITableViewDelegate
typedef void (^CellDidSelectBlock)(UITableView *tableView, NSIndexPath *indexPath);


@interface KKTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>


/**
 TableView 的展示数据
 */
@property (nonatomic, strong) NSArray *datas;


/**
 cell 的配置
 */
@property (nonatomic, copy) KKTableViewCellConfigBlock configCell;


/**
 cell 的重用标记
 */
@property (nonatomic, copy) NSString *reuseID;


/**
 初始化 data source

 @param datas      展示数据
 @param reuseID    重用标记
 使用 reuseID 前必须调用 ***registerNib*** 或 ***registerClass*** 方法
 @param configCell 配置 cell 的方法

 @return data source
 */
- (instancetype) initWithDatas: (NSArray *)datas
                       reuseID: (NSString *)reuseID
                    configCell: (KKTableViewCellConfigBlock )configCell;




/**
 如果以下 block 存在
 则不会调用默认的初始方法
 */

@property (nonatomic, copy) CellConfigBlock configCellBlock;
@property (nonatomic, copy) RowConfigBlock configRowBlock;
@property (nonatomic, copy) SectionConfigBlock configSectionBlock;

@property (nonatomic, copy) CellDidSelectBlock cellDidSelectBlock;

/**
 ******* 提供链式赋值方法
 ******* 使代码集中易看
 ******* 避免 delegate 的分散
 *******
 ******* demo: [[[self configcell:block] configRow:block] configSection:block]...
 */

- (KKTableViewDataSource *)configCell: (CellConfigBlock )block;
- (KKTableViewDataSource *)configRow: (RowConfigBlock )block;
- (KKTableViewDataSource *)configSection: (SectionConfigBlock )block;


/**
 如在此进行 push & present 跳转
 记得要使用 weakSelf
 */
- (KKTableViewDataSource *)didSelectCell: (CellDidSelectBlock )block;

@end
