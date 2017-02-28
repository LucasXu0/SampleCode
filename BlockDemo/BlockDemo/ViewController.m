//
//  ViewController.m
//  BlockDemo
//
//  Created by TsuiYuenHong on 2017/2/27.
//  Copyright © 2017年 TsuiYuenHong. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (IBAction)clickToSecondVC:(UIButton *)button {
    SecondViewController *secondVC = [SecondViewController new];
    [self.navigationController pushViewController:secondVC animated:NO];
}


@end
