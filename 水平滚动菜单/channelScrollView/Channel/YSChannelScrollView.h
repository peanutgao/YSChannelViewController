//
//  YSScrollTitleView.h
//
//  Created by Joseph on 15/9/29.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YS_ScreenHeight [UIScreen mainScreen].bounds.size.height
#define YS_ScreenWidth [UIScreen mainScreen].bounds.size.width

@class YSChannelScrollView;
@protocol YSChannelScrollViewDelegate <NSObject>

/*!
 @brief  频道点击代理方法
 
 @param channelScrollView 水平滚动菜单对象
 @param index             点击的频道索引
 */
- (void)channelScrollView:(YSChannelScrollView *)channelScrollView didClickedChannelLabelAtIdnex:(NSInteger)index;

@end


@interface YSChannelScrollView : UIScrollView
/*!
 *  频道数据集合
 */
@property (nonatomic, strong) NSArray *channelsData;
/*!
 @brief  切换动画时长
 */
@property (nonatomic, assign) CGFloat animTime;
/*!
 @brief 频道背景颜色
 */
@property (nonatomic, strong) UIColor *channelBgColor;
/*!
 @brief 选中文字颜色
 */
@property (nonatomic, strong) UIColor *selectedTextColor;
/*!
 @brief 未选择时显示的颜色
 */
@property (nonatomic, strong) UIColor *normalTextColor;
/*!
 @brief 上下分割线颜色
 */
@property (nonatomic, strong) UIColor *dividingLineColor;
/*!
 @brief 底部指示横线颜色
 */
@property (nonatomic, strong) UIColor *buttomLineColor;
/*!
 @brief 文字大小
 */
@property (nonatomic, assign) NSInteger textFontSize;
/*!
 *  titleScrollView 代理属性
 */
@property (nonatomic, weak) id<YSChannelScrollViewDelegate> channelScrollViewDelegate;
/*!
 @brief  创建水平滚动菜单
 
 @param frame        水平滚动菜单的frame
 @param channelsData 所有频道的名称集合
 
 @return instance
 */
- (instancetype)initChannelScrollViewWithFrame:(CGRect)frame channelsData:(NSArray *)channelsData;
/*!
 @brief  更新显示的频道
 
 @param index 显示的频道索引
 */
- (void)updateShowingChannel:(NSInteger)index;

@end
