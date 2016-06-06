//
//  YSTotalChannelViewController.m
//
//  Created by Joseph Gao on 15/11/24.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSTotalChannelViewController.h"
#import "YSChannelScrollView.h"
#import "UIView+FrameExt.h"

@interface YSTotalChannelViewController ()<YSChannelScrollViewDelegate,UIScrollViewDelegate>

/** 顶部导航栏 */
@property (nonatomic, strong) YSChannelScrollView *channelScrollView;
/** 容器scrollView */
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation YSTotalChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];

    [self setupChannelScrollView];
    [self setupContentScrollView];
    [self setupChannelControllers];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self channelScrollView:self.channelScrollView
       didClickChannelLabel:[self getLabelWithIndex:self.channelIndex]
                    atIdnex:self.channelIndex];
}


#pragma mark - setup UI

- (void)setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] init];
    
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.channelScrollView.frame) + 5;    // 5是间距
    CGFloat w = YS_SCREEN_HIGHT;
    CGFloat h = YS_SCREEN_HIGHT;
    _contentScrollView.frame = CGRectMake(x, y, w, h);
    _contentScrollView.delegate = self;
    _contentScrollView.contentSize = CGSizeMake(w * self.channelTitilesData.count, 0);
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.scrollEnabled = self.isAllowDrag;
    
    [self.view addSubview:_contentScrollView];
}


- (void)setupChannelControllers {
    if (self.channelTitilesData && self.channelControllers) {
        NSAssert(self.channelTitilesData.count == self.channelControllers.count, @"channelTitilesData's count have to equel to channelControllers' count if you set them both");
    }


    if (self.vcClass && self.channelTitilesData) {
        [self.channelTitilesData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:[[self.vcClass alloc] init]];
        }];
        
    } else if (self.channelControllers) {
        [self.channelControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:obj];
        }];
    }

}


/// 设置水平滚动视图,数据赋值
- (void)setupChannelScrollView {
    CGFloat channelSVX = 0;
    CGFloat channelSVY = 64 + 5;    // 5是间距
    CGFloat channelSVW = YS_SCREEN_WIDTH;
    CGFloat channelSVH = 41;
    _channelScrollView = [[YSChannelScrollView alloc] initChannelScrollViewWithFrame:CGRectMake(channelSVX,
                                                                                                channelSVY,
                                                                                                channelSVW,
                                                                                                channelSVH)
                                                                        channelsData:self.channelTitilesData];
    _channelScrollView.animTime          = self.scrollAnimTime;
    _channelScrollView.channelBgColor    = self.channelBgColor;
    _channelScrollView.dividingLineColor = self.dividingLineColor;
    _channelScrollView.buttomLineColor   = self.buttomLineColor;
    _channelScrollView.normalTextColor   = self.normalTextColor;
    _channelScrollView.selectedTextColor = self.selectedTextColor;
    _channelScrollView.channelsData      = self.channelTitilesData;
    _channelScrollView.scaleEnable       = self.textScaleEnable;
    
    _channelScrollView.channelScrollViewDelegate = self;
    

    [self.view addSubview:_channelScrollView];
}


- (void)creatContentView:(NSInteger)index {
    if (!self.channelControllers || self.channelControllers.count == 0) {
        return;
    }
    
    UIViewController *channelVC = self.channelControllers[index];
    CGFloat x = self.contentScrollView.ys_width * index;
    
    if (!channelVC.view.superview) {
        CGFloat y = 0;
        CGFloat w = self.contentScrollView.ys_width;
        CGFloat h = self.contentScrollView.ys_height;
        [channelVC.view setFrame:CGRectMake(x, y, w, h)];
        [self.contentScrollView addSubview:channelVC.view];
    }
}



#pragma mark - Action

- (void)update {
    [self.channelScrollView update];
    [self.contentScrollView layoutIfNeeded];
    
    [self channelScrollView:self.channelScrollView
       didClickChannelLabel:[self getLabelWithIndex:self.channelIndex]
                    atIdnex:self.channelIndex];
}


- (void)doContentScrollViewActionWithIndex:(NSInteger)index {
    if (self.channelTitilesData == nil || self.channelTitilesData.count == 0) {
        return;
    }
    self.navigationItem.title = self.channelTitilesData[index];
    
    [self creatContentView:index];
    
    CGFloat x = self.contentScrollView.ys_width * index;
    [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}


#pragma mark - YSChannelScrollView Delegate Method

- (void)channelScrollView:(YSChannelScrollView *)channelScrollView
     didClickChannelLabel:(YSChannelLabel *)channelLabel
                  atIdnex:(NSInteger)index {
    
    [self.channelScrollView updateShowingChannel:index];
    [self doContentScrollViewActionWithIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(totalChannelVC:channelLabel:clickedAtIndex:)]) {
        [self.delegate totalChannelVC:self channelLabel:channelLabel clickedAtIndex:index];
    }
}


#pragma mark - ScrollView Delegate Method

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / self.contentScrollView.ys_width;
    
    [self channelScrollView:self.channelScrollView didClickChannelLabel:[self getLabelWithIndex:index] atIdnex:index];
}



#pragma mark - 

- (YSChannelLabel *)getLabelWithIndex:(NSInteger)index {
    NSInteger tag = index  + 100 + 1;
    YSChannelLabel *channelLabel = (YSChannelLabel *)[self.contentScrollView viewWithTag:tag];
    return channelLabel;
}


- (void)setChannelTitilesData:(NSArray *)channelTitilesData {
    _channelTitilesData = channelTitilesData;
    
    if (self.channelScrollView) {
        self.channelScrollView.channelsData = channelTitilesData;
    }
}


@end




