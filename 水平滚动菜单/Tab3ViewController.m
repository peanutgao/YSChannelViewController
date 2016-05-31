//
//  Tab3ViewController.m
//  水平滚动菜单
//
//  Created by Joseph Gao on 16/5/31.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "Tab3ViewController.h"
#import "YSTotalChannelViewController.h"
#import "YSDemoTableViewController.h"
#import "YSDemoViewController.h"
#import "Masonry.h"


@interface YSData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *otherInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@implementation YSData

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end


@interface Tab3ViewController ()

@property (nonatomic, strong) NSMutableArray *dataArrayM;
@property (nonatomic, strong) YSTotalChannelViewController *totalChannelVC;


@end

@implementation Tab3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestData];
}




- (void)setChannelControllerParams {
    NSMutableArray *titelArrayM = [NSMutableArray array];
    NSMutableArray *vcArrayM = [NSMutableArray array];
    for (YSData *data in self.dataArrayM) {
        [titelArrayM addObject:data.title];
        
        YSDemoTableViewController *vc = [[YSDemoTableViewController alloc] init];
        vc.tempInfo = data.otherInfo;
        
        [vcArrayM addObject:vc];
    }
    
    self.totalChannelVC.channelControllers = vcArrayM;
    self.totalChannelVC.channelTitilesData = titelArrayM;
    
    [self.view addSubview:self.totalChannelVC.view];
    
    // 测试masonry自动布局
    [self.totalChannelVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



#pragma mark - Lazy Loading

- (YSTotalChannelViewController *)totalChannelVC {
    if (!_totalChannelVC) {
        _totalChannelVC = [[YSTotalChannelViewController alloc] init];
        
        _totalChannelVC.scrollAnimTime = 0.5;
        _totalChannelVC.allowDrag = YES; // 允许内容拖拽滚动
//        _totalChannelVC.channelTitilesData = @[@"这里是首页", @"hehe", @"前面是傻缺", @"顶三楼", @"三楼威武", @"楼上都是二缺", @"我是七楼", @"八王爷", @"九二格"];
        
//        // 1. 如果用同一个控制器,直接传入控制器的类名即可
//        //        _totalChannelVC.vcClass = [YSDemoViewController class];
//        
//        // 2. 如果里面是不同的控制器,传入控制器数组数组集合即可. \
//        但是, 控制器集合数量必须和channelsData一样
//        NSMutableArray *arrayM = [NSMutableArray array];
//        
//        [arrayM addObject:[[YSDemoTableViewController alloc] init]];
//        for (int i = 0; i < 8; i++) {
//            [arrayM addObject:[[YSDemoViewController alloc] init]];
//        }
//        _totalChannelVC.channelControllers = arrayM;
    }
    
    return _totalChannelVC;
}


- (void)requestData {
    NSArray *array = @[
                       @{
                           @"title": @"这里是首页",
                           @"otherInfo": @"1111"
                           },
                       @{
                           @"title": @"hehe",
                           @"otherInfo": @"2222"
                           },
                       @{
                           @"title": @"前面是傻缺",
                           @"otherInfo": @"3333"
                           },
                       @{
                           @"title": @"顶三楼",
                           @"otherInfo": @"4444"
                           },
                       @{
                           @"title": @"三楼威武",
                           @"otherInfo": @"5555"
                           },
                       @{
                           @"title": @"楼上都是二缺",
                           @"otherInfo": @"6666"
                           },
                       @{
                           @"title": @"我是七楼",
                           @"otherInfo": @"7777"
                           },
                       @{
                           @"title": @"八王爷",
                           @"otherInfo": @"8888"
                           },
                       @{
                           @"title": @"九二格",
                           @"otherInfo": @"9999"
                           }
                       ];
    
    // 模拟网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YSData *data = [[YSData alloc] initWithDict:obj];
                [self.dataArrayM addObject:data];
            }];
            
            [self setChannelControllerParams];
            
        });
    });
    
}


- (NSMutableArray *)dataArrayM {
    if (_dataArrayM == nil) {
        _dataArrayM = [NSMutableArray array];
    }
    return _dataArrayM;
}


@end
