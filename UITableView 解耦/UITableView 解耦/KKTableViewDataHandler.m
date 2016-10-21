//
//  KKTableViewDataSource.m
//  DataSource 解耦
//
//  Created by TsuiYuenHong on 2016/10/13.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "KKTableViewDataHandler.h"

@implementation KKTableViewDataHandler

- (instancetype)init{
    self = [super init];
    
    if (self) {
        _datas = @[];
        _reuseID = @"";
        _configCell = nil;
        
        _configRowBlock = nil;
        _configSectionBlock = nil;
        _configCellBlock = nil;
        
        _cellDidSelectBlock = nil;
    }
    
    return self;
}

- (instancetype)initWithDatas:(NSArray *)datas
                      reuseID:(NSString *)reuseID
                   configCell:(KKTableViewCellConfigBlock)configCell{
    self = [super init];
    
    if (self) {
        _datas = datas;
        _reuseID = reuseID;
        _configCell = [configCell copy];
    }
    
    return self;
}

#pragma mark - 链式操作实现

- (KKTableViewDataHandler *)configSection:(SectionConfigBlock)block{
    _configSectionBlock = [block copy];
    return self;
}

-(KKTableViewDataHandler *)configRow:(RowConfigBlock)block{
    _configRowBlock = [block copy];
    return self;
}

- (KKTableViewDataHandler *)configCell:(CellConfigBlock)block{
    _configCellBlock = [block copy];
    return self;
}

- (KKTableViewDataHandler *)didSelectCell:(CellDidSelectBlock)block{
    _cellDidSelectBlock = [block copy];
    return self;
}

- (KKTableViewDataHandler *(^)(SectionConfigBlock))configSection{
    
    return ^KKTableViewDataHandler *(SectionConfigBlock block){
        self.configSectionBlock = block;
        return self;
    };
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_configSectionBlock) {
        return _configSectionBlock(tableView);
    }
    
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_configRowBlock) {
        return _configRowBlock(tableView, section);
    }
    
    NSArray *rows = _datas[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_configCellBlock) {
        return _configCellBlock(tableView, indexPath);
    }
    
    id cell = [tableView dequeueReusableCellWithIdentifier:_reuseID];
    id data = _datas[(NSUInteger) indexPath.section];
    _configCell(cell, data[indexPath.row]);
    return cell;
}

#pragma mark - TableView Delegata

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return _cellDidSelectBlock(tableView, indexPath);
}

@end
