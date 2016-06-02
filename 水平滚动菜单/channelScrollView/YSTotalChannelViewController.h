//
//  YSTotalChannelViewController.h
//
//  Created by Joseph Gao on 15/11/24.
//  Copyright © 2015年 Joseph. All rights reserved.
//
/*!
 @brief  水平滚动导航
 */

#import <UIKit/UIKit.h>

@class YSChannelLabel;
@class YSTotalChannelViewController;
@protocol YSTotalChannelVCDelegate <NSObject>

@optional
/*!
 @brief TotalChannelVC代理方法,label被点击后会调用
 @param totalChannelVC TotalChannelViewController
 @param channelLable   被点击的label
 @param index          点击的索引
 */
- (void)totalChannelVC:(YSTotalChannelViewController *)totalChannelVC
          channelLabel:(YSChannelLabel *)channelLable
        clickedAtIndex:(NSInteger)index;

@end



@interface YSTotalChannelViewController : UIViewController

/*!
 @brief  所有频道标题数据集合, NSString *
 */
@property (nonatomic, strong) NSArray *channelTitilesData;
/*!
 @brief  要显示的频道索引
 */
@property (nonatomic, assign) NSInteger channelIndex;
/*!
 @brief 滚动时间, 单位:秒, 默认0.3秒
 */
@property (nonatomic, assign) CGFloat scrollAnimTime;
/*!
 @brief 频道背景颜色, 默认:白色
 */
@property (nonatomic, strong) UIColor *channelBgColor;
/*!
 @brief 上下分割线颜色,默认:无颜
 */
@property (nonatomic, strong) UIColor *dividingLineColor;
/*!
 @brief 底部指示线颜色,默认:红色
 */
@property (nonatomic, strong) UIColor *buttomLineColor;
/*!
 @brief 选中文字颜色
 */
@property (nonatomic, strong) UIColor *selectedTextColor;
/*!
 @brief 未选择时显示的颜色
 */
@property (nonatomic, strong) UIColor *normalTextColor;
/*!
 @brief 是否允许
 */
@property (nonatomic, assign, getter=isAllowDrag) BOOL allowDrag;
/*!
 @brief 频道控制器名称
 */
@property (nonatomic, strong) Class vcClass;
/*!
 @brief 频道控制器集合
 */
@property (nonatomic, strong) NSArray *channelControllers;

/*!
 @brief 代理
 */
@property (nonatomic, weak) id<YSTotalChannelVCDelegate> delegate;


@end



