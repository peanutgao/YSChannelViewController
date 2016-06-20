//
//  YSDemo2ViewController.m
//  水平滚动菜单
//
//  Created by Joseph Gao on 16/5/24.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "Tab2ViewController.h"
#import "YSTotalChannelViewController.h"
#import "YSDemoViewController.h"
#import "Masonry.h"
#import "YSDemoTableViewController.h"

@interface Tab2ViewController ()<YSTotalChannelVCDelegate>

@property (nonatomic, strong) YSTotalChannelViewController *totalChannelVC;

@end

@implementation Tab2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"tabbar点击";
    
    [self.view addSubview:self.totalChannelVC.view];
    
    // 测试masonry自动布局
    [self.totalChannelVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    self.totalChannelVC.view.frame = self.view.bounds;
}


#pragma mark - Lazy Loading

- (YSTotalChannelViewController *)totalChannelVC {
    if (!_totalChannelVC) {
        _totalChannelVC = [[YSTotalChannelViewController alloc] init];
        
        _totalChannelVC.delegate = self;
        _totalChannelVC.scrollAnimTime = 0.5;
        _totalChannelVC.allowDrag = YES;        // 允许内容拖拽滚动
        _totalChannelVC.textScaleEnable = YES;  // 文字放大效果
        _totalChannelVC.channelTitilesData = @[@"这里是首页",
                                               @"hehe",
//                                               @"前面是傻缺",
//                                               @"顶三楼",
//                                               @"三楼威武",
//                                               @"楼上都是二缺",
//                                               @"我是七楼",
//                                               @"八王爷",
                                               @"九二格"];
        
        // 1. 如果用同一个控制器,直接传入控制器的类名即可
//        _totalChannelVC.vcClass = [YSDemoViewController class];
        
        // 2. 如果里面是不同的控制器,传入控制器数组数组集合即可. \
              但是, 控制器集合数量必须和channelsData一样
        NSMutableArray *arrayM = [NSMutableArray array];
        
        [arrayM addObject:[[YSDemoTableViewController alloc] init]];
        for (int i = 0; i < 2; i++) {
            [arrayM addObject:[[YSDemoViewController alloc] init]];
        }
        _totalChannelVC.channelControllers = arrayM;
    }
    
    return _totalChannelVC;
}


#pragma mark - YSTotalChannelVC Delegate

- (void)totalChannelVC:(YSTotalChannelViewController *)totalChannelVC channelLabel:(YSChannelLabel *)channelLable clickedAtIndex:(NSInteger)index {
    NSLog(@"======================");
}

@end
