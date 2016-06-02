//
//  YSTotalChannelViewController.m
//
//  Created by Joseph Gao on 15/11/24.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSTotalChannelViewController.h"
#import "YSChannelScrollView.h"
//#import "UIView+FrameExt.h"

static const CGFloat kDefaultAnimTime = 0.3f;

@interface YSTotalChannelViewController ()<YSChannelScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) YSChannelScrollView *channelScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation YSTotalChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupChannelControllers];
    [self setupChannelScrollView];
    [self setupContentScrollView];
    
    [self channelScrollView:self.channelScrollView didClickedChannelLabelAtIdnex:[self modifedShowIndex:_showIndex]];
}


#pragma mark - setup UI

- (void)setupContentScrollView {
    _contentScrollView = [[UIScrollView alloc] init];
    
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.channelScrollView.frame) + 5;    // 5是间距
    CGFloat w = ScreenWidth;
    CGFloat h = ScreenHeight;
    _contentScrollView.frame = CGRectMake(x, y, w, h);
    _contentScrollView.delegate = self;
    _contentScrollView.contentSize = CGSizeMake(w * self.channelControllers.count, 0);
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.scrollEnabled = self.isAllowDrag;
    
    [self.view addSubview:_contentScrollView];
}

- (void)setupChannelControllers {
//    if (self.channelNamesData && self.channelControllers) {
//        NSAssert(self.channelNamesData.count == self.channelControllers.count, @"channelsData's count need equel to channelControllers' count if you set them both");
//    }

    if (self.vcClass && self.channelNamesData) {
        [self.channelNamesData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:[[self.vcClass alloc] init]];
        }];
    }
    else if (self.channelControllers) {
        [self.channelControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:obj];
        }];
    }

}

/// 设置水平滚动视图
- (void)setupChannelScrollView {
    CGFloat channelSVX = 0;
    CGFloat channelSVY = 64 + 5;    // 5是间距
    CGFloat channelSVW = ScreenWidth;
    CGFloat channelSVH = 41;
    _channelScrollView = [[YSChannelScrollView alloc] initChannelScrollViewWithFrame:CGRectMake(channelSVX,
                                                                                                channelSVY,
                                                                                                channelSVW,
                                                                                                channelSVH)
                                                                        channelsData:self.channelNamesData];
    _channelScrollView.animTime = self.scrollAnimTime;
    _channelScrollView.channelScrollViewDelegate = self;

    [self.view addSubview:_channelScrollView];
}


#pragma mark - delegate method

- (void)channelScrollView:(YSChannelScrollView *)channelScrollView didClickedChannelLabelAtIdnex:(NSInteger)index {
    self.navigationItem.title = self.channelNamesData[index];
    [self.channelScrollView updateShowingChannel:index];
    [self creatContentView:index];

    [UIView animateWithDuration:self.scrollAnimTime animations:^{
        CGFloat x = CGRectGetWidth(self.contentScrollView.frame) * index;
        self.contentScrollView.contentOffset = CGPointMake(x, 0);
    }];
}

- (void)creatContentView:(NSInteger)index {
    UIViewController *channelVC = self.childViewControllers[index];
    CGRect frame = self.contentScrollView.frame;
    CGFloat x = CGRectGetWidth(frame) * index;
    
    if (!channelVC.view.superview) {
        CGFloat y = 0;
        CGFloat w = CGRectGetWidth(frame);
        CGFloat h = CGRectGetHeight(frame);
        [channelVC.view setFrame:CGRectMake(x, y, w, h)];
        [self.contentScrollView addSubview:channelVC.view];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / CGRectGetWidth(self.contentScrollView.frame);
    [self channelScrollView:self.channelScrollView didClickedChannelLabelAtIdnex:index];
}


#pragma mark - Setter

- (void)setChannelNamesData:(NSArray *)channelNamesData {
    if (!_channelNamesData) {
        _channelNamesData = [NSArray array];
    }
    
    _channelNamesData = channelNamesData;
}

- (void)setScrollAnimTime:(CGFloat)scrollAnimTime {
    if (scrollAnimTime <= 0) {
        scrollAnimTime = kDefaultAnimTime;
    }
    
    _scrollAnimTime = scrollAnimTime;
    _channelScrollView.animTime = _scrollAnimTime;
}

- (NSInteger)modifedShowIndex:(NSInteger)showIndex {
    if (showIndex < 0 ) {
        showIndex = 0;
    } else if (showIndex > self.channelNamesData.count - 1) {
        showIndex = self.channelNamesData.count - 1;
    }
    _showIndex = showIndex;
    
    return showIndex;
}

@end




