//
//  ViewController.m
//  YSChannelViewController
//
//  Created by Joseph Gao on 15/11/26.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "ViewController.h"
#import "YSTotalChannelViewController.h"
#import "YWDemoViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)show:(id)sender {
    YSTotalChannelViewController *totalChannelVC = [[YSTotalChannelViewController alloc] init];
    totalChannelVC.showIndex = [self.textField.text integerValue];   // 启动时立即显示的索引
    totalChannelVC.scrollAnimTime = 0.25;
    totalChannelVC.allowDrag = YES; // 是否允许内容拖拽滚动
    totalChannelVC.channelNamesData = @[@"这里是首页",
                                    @"hehe",
                                    @"前面是傻缺",
                                    @"顶三楼",
                                    @"三楼威武",
                                    @"楼上都是二缺",
                                    @"我是七楼",
                                    @"八王爷",
                                    @"九宫格"];
    
    // 1. 如果用同一个控制器,直接传入控制器的类名即可
    totalChannelVC.vcClass = [YWDemoViewController class];
    
    // 2. 如果里面是不同的控制器,传入控制器数组数组集合即可. 控制器集合数量必须和channelsData一样
    // 模拟插入多条数据
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        [arrayM addObject:[[YWDemoViewController alloc] init]];
        // 设置vc属性
    }
    totalChannelVC.channelControllers = arrayM;
    
    [self.navigationController pushViewController:totalChannelVC animated:YES];
}

@end
