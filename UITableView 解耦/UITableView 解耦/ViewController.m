//
//  ViewController.m
//  DataSource 解耦
//
//  Created by TsuiYuenHong on 2016/10/13.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "ViewController.h"
#import "KKTableViewDataHandler.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) KKTableViewDataHandler *dataHander;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 创建显示数组
    NSArray *section1 = @[@"一百块",@"都不给我"];
    NSArray *section2 = @[@"你真的",@"很坏的"];
    _datas = @[section1,section2];
    
    // 创建TableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    NSString *reuseID = NSStringFromClass([UITableViewCell class]);
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID];
    [self.view addSubview:tableView];
    
    __weak typeof(self) weakSelf = self;
    
     //创建数据源 适用于普通模式的 TableView
    _dataHander = [[[KKTableViewDataHandler alloc] initWithDatas:_datas reuseID:reuseID configCell:^(UITableViewCell *cell, NSString *data) {
        cell.textLabel.text = data;
    }] didSelectCell:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSLog(@"%ld",(long)indexPath.row);
        [weakSelf.navigationController pushViewController:[ViewController new] animated:NO];
    }];
    
     // 创建数据源 适用于自定义模式的 TableView
    _dataHander = [[[[[KKTableViewDataHandler alloc] init] configSection:^NSInteger(UITableView *tableView) {
        return _datas.count;
    }] configRow:^NSInteger(UITableView *tableView, NSInteger section) {
        NSArray *rows = _datas[section];
        return rows.count;
    }] configCell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        id data = _datas[(NSUInteger) indexPath.section];
        cell.textLabel.text = data[indexPath.row];
        return cell;
    }];
    
    
    // 组合使用
    _dataHander = [[KKTableViewDataHandler alloc] init];
    _dataHander.datas = _datas;
    _dataHander.reuseID = reuseID;
    [[_dataHander configCell:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.textLabel.text = @"666";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }] didSelectCell:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSLog(@"%ld",(long)indexPath.row);
        [weakSelf.navigationController pushViewController:[ViewController new] animated:NO];
    }];
    
    // 指定数据源和代理
    tableView.dataSource = _dataHander;
    tableView.delegate = _dataHander;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"dealloc");
}

@end
