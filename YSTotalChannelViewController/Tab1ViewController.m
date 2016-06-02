//
//  ViewController.m
//  水平滚动菜单
//
//  Created by Joseph Gao on 15/11/26.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "Tab1ViewController.h"
#import "YSTotalChannelViewController.h"
#import "YSDemoViewController.h"

@interface Tab1ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation Tab1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"push传值";
}


- (IBAction)show:(id)sender {
    YSTotalChannelViewController *totalChannelVC = [[YSTotalChannelViewController alloc] init];
    totalChannelVC.channelIndex = [self.textField.text integerValue];
    totalChannelVC.scrollAnimTime = 0.5;
    totalChannelVC.allowDrag = YES;        // 允许内容拖拽滚动
    totalChannelVC.textScaleEnable = YES;  // 文字放大效果
    totalChannelVC.channelTitilesData = @[@"这里是首页",
                                           @"hehe",
                                           @"前面是傻缺",
                                           @"顶三楼",
                                           @"三楼威武",
                                           @"楼上都是二缺",
                                           @"我是七楼",
                                           @"八王爷",
                                           @"九二格"];
    // 设置上下分割线颜色
    totalChannelVC.dividingLineColor = [UIColor colorWithWhite:0.855 alpha:1.000];

    
    
    // 1. 如果用同一个控制器,直接传入控制器的类名即可
    totalChannelVC.vcClass = [YSDemoViewController class];
    
    // 2. 如果里面是不同的控制器,传入控制器数组数组集合即可. 控制器集合数量必须和channelsData一样
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        [arrayM addObject:[[YSDemoViewController alloc] init]];
    }
    totalChannelVC.channelControllers = arrayM;
    
    [self.navigationController pushViewController:totalChannelVC animated:YES];
}



@end
