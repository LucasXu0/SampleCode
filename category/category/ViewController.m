//
//  ViewController.m
//  category
//
//  Created by TsuiYuenHong on 2016/9/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Person+OtherSkills.h"
#import "Person+Delegate.h"

#import <objc/runtime.h>

#import "UIButton+Category.h"

typedef id (*_IMP)(id, SEL, ...);

static char *key1; //SDWebImage & AFNetworking
static const char * const key2 = "key2";
static const void *key3 = &key3;

int i = 0;

@interface ViewController ()<PersonDelegate>

@property (nonatomic, copy) NSString *name;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testForHook:@"Hello World"];
    NSLog(@"执行原方法");

    //[self test];
    
    //key2 = "key3";
    key3 = "key2";
    NSLog(@"%s",key1);
    self.name = @"小白";
    NSString *hi = @"hi";
   // [Person run];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 150, 100)];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 150, 100)];
    button2.backgroundColor = [UIColor redColor];
    __weak typeof(self) weakSelf = self;
    [button2 kk_addActionHandler:^{
        button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];

    } ForControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button2];
  
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 550, 150, 100)];
    button3.backgroundColor = [UIColor redColor];
    button3.actionHandlerBlock = ^{
        button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
    };
    [button3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    Person *p1 = [[Person alloc] init];
    p1.delegate = self;
    
    // 开始谈笑风生了
    [p1 tanxiaofengsheng];
    
    //p1.otherName = @"江";
//    [p1 talk];
    
//    p1.otherName2 = @"小东";
    
//    p1.name = @"小明";
    
//    // 实例属性
//    p1.otherName = @"小花";
//    [p1 logInstProp];
//    
//    p1.otherName = @"小明";
//    [p1 logInstProp];
//    
//    // 类属性
//    Person.clsStr = @"小东";
//    [Person logClsProp];
    
    // 此时调用的是 Category 的 talk ,即使没有 import "Person+OtherSkills.h"
    //[p1 talk];
    
//    // 获取 Person 的方法列表
//    unsigned int personMCount;
//    // 获取实例方法
//    Method *personMList = class_copyMethodList([Person class], &personMCount);
//    // 获取类方法
//    //Method *personMList = class_copyMethodList(object_getClass([Person class]), &personMCount);
//    NSMutableArray *mArr = [NSMutableArray array];
//    
//    // 这里是倒序获取，所以 mArr 第一个方法对应的是 Person 类中最后一个方法
//    for (int i = personMCount - 1; i >= 0; i--) {
//        
//        SEL sel = NULL;
//        IMP imp = NULL;
//        
//        Method method = personMList[i];
//        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method))
//                                                  encoding:NSUTF8StringEncoding];
//        [mArr addObject:methodName];
//        
//        if ([@"talk" isEqualToString:methodName]) {
//            imp = method_getImplementation(method);
//            sel = method_getName(method);
//            ((void (*)(id, SEL))imp)(p1, sel);
//            //break;
//        }
//    }
//    
//    free(personMList);
//    
//    NSLog(@"%@",mArr);

    
}

- (void)testForHook:(NSString *)str1{
    NSLog(@"%@",str1);
}


- (void)click:(UIButton *)button{
    [self dismissViewControllerAnimated:YES  completion:nil];

//    if (button.actionHandlerBlock) {
//        button.actionHandlerBlock();
//    }
}

- (void)test{
    i ++;
    NSLog(@"%d",i);
    if (i != 5) {
        [self test];
        return ;
    }
}

- (void)showInTV{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    imageView.image = [UIImage imageNamed:@"naive.jpg"];
    [self.view addSubview:imageView];
}

- (void)dealloc{
    NSLog(@"...");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
