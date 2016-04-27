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

@interface YSTotalChannelViewController : UIViewController

/** 所有频道数据集合, NSString * */
@property (nonatomic, strong) NSArray *channelNamesData;

/** 要显示的频道索引 */
@property (nonatomic, assign) NSInteger showIndex;

/** 滚动时间, 单位:秒, 默认0.3秒 */
@property (nonatomic, assign) CGFloat scrollAnimTime;

/** 是否允许拖拽 */
@property (nonatomic, assign, getter=isAllowDrag) BOOL allowDrag;

/** 频道控制器名称 */
@property (nonatomic, strong) Class vcClass;

/** 频道控制器集合 */
@property (nonatomic, strong) NSArray *channelControllers;
@end
