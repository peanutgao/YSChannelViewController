//
//  YSScrollTitleView.m
//
//  Created by Joseph on 15/9/29.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSChannelScrollView.h"

#define FONT_SIZE 16
#define MARGIN (18 * [UIScreen mainScreen].bounds.size.width / 375)


@interface YSChannelLabel: UILabel

@end

@implementation YSChannelLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    }
    
    return self;
}
@end

@interface YSChannelScrollView()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YSChannelLabel *currentLabel;

@end

@implementation YSChannelScrollView


#pragma mark - Creat

- (instancetype)initChannelScrollViewWithFrame:(CGRect)frame channelsData:(NSArray *)channelsData {
    if (self = [super initWithFrame:frame]) {
        self.channelNamesData = channelsData;
        
        [self setupScrollViewWithFrame:frame];
        [self setupLineViewWithWithFrame:frame index:0];
        
        self.bounces = NO;
        self.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    }
    
    return self;
}

/// line View
- (void)setupLineViewWithWithFrame:(CGRect)frame index:(NSInteger)index {
    CGSize fontSize = [self calculateSizeOfString:self.channelNamesData[index]];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN * 0.5, frame.size.height * 0.9, fontSize.width, 5)];
    _lineView.backgroundColor = [UIColor redColor];
    [self addSubview:_lineView];
    
}

- (void)setupScrollViewWithFrame:(CGRect)frame {
    CGFloat channelLabelY = 1;
    CGFloat channelLabelH = frame.size.height - 2;
    
    // creat labels
    __block CGFloat channelLabelX = 0;
    [self.channelNamesData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        CGSize fontSize = [self calculateSizeOfString:title];
        CGFloat channelLabelW = fontSize.width + MARGIN;
        CGRect frame = CGRectMake(channelLabelX, channelLabelY, channelLabelW, channelLabelH);
        YSChannelLabel *channelLabel = [self creatChannelLabelWithFrame:frame
                                                                    tag:idx * 100 + 1  // lebel的tag是(索引 * 100 + 1)
                                                                   text:title];
        channelLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:channelLabel];
        
        channelLabelX += fontSize.width + MARGIN;
    }];
    
    self.contentSize = CGSizeMake(channelLabelX, 0);
    self.showsHorizontalScrollIndicator = NO;
}

- (CGSize)calculateSizeOfString:(NSString *)aString{
    return [aString boundingRectWithSize:self.frame.size
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}
                                 context:nil].size;
}

- (YSChannelLabel *)creatChannelLabelWithFrame:(CGRect)frame tag:(NSInteger)tag text:(NSString *)text {
    YSChannelLabel *channelLabel = [[YSChannelLabel alloc] initWithFrame:frame];
    
    channelLabel.userInteractionEnabled = YES;
    channelLabel.text = text;
    channelLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    channelLabel.tag = tag;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapChannelLabel:)];
    [channelLabel addGestureRecognizer:tapGesture];
    
    return channelLabel;
}


#pragma mark - Action

- (void)tapChannelLabel:(UITapGestureRecognizer *)tapGesture {
    UIView *view = tapGesture.view;
    
    NSInteger index = (view.tag - 1) / 100;
    [self updateShowingChannel:index];
    
    if (self.channelScrollViewDelegate &&
        [self.channelScrollViewDelegate respondsToSelector:@selector(channelScrollView:didClickedChannelLabelAtIdnex:)]) {
        [self.channelScrollViewDelegate channelScrollView:self didClickedChannelLabelAtIdnex:index];
    }
}

- (void)updateShowingChannel:(NSInteger)index {
    CGFloat offsetX = 0;
    CGFloat lineOffsetX = 0;
    CGSize currentFontSize = [self calculateSizeOfString:self.channelNamesData[index]];
    CGRect frame = self.lineView.frame;

    __block CGFloat preMarge = 0;
    __weak typeof(self) weakSelf = self;
    if (index > 0) {
        [self.channelNamesData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            preMarge += [weakSelf calculateSizeOfString:obj].width + MARGIN;
            if (idx == index - 1) {
                *stop = YES;
            }
        }];
        
        // line offset
        lineOffsetX = preMarge + MARGIN * 0.5;
        
        // title offset
        if ((preMarge + currentFontSize.width * 0.5) < ScreenWidth * 0.5) {
            offsetX = 0;
        }
        else if ((preMarge + currentFontSize.width * 0.5) >= ScreenWidth * 0.5 &&
                   (self.contentSize.width - (preMarge + currentFontSize.width * 0.5) > ScreenWidth * 0.5)) {
            offsetX = preMarge  + currentFontSize.width * 0.5 - ScreenWidth * 0.5;
        }
        else if ((self.contentSize.width - (preMarge + currentFontSize.width * 0.5) <= ScreenWidth * 0.5)) {
            offsetX = self.contentSize.width - ScreenWidth;
        }
        
        
        [UIView animateWithDuration:self.animTime animations:^{
            [self setContentOffset:CGPointMake(offsetX, 0)];
            self.lineView.frame = CGRectMake(lineOffsetX,
                                             frame.origin.y,
                                             currentFontSize.width,
                                             frame.size.height);
        }];
        
    } else {
        [UIView animateWithDuration:self.animTime animations:^{
            [self setContentOffset:CGPointMake(0, 0)];
            self.lineView.frame = CGRectMake((lineOffsetX + MARGIN * 0.5),
                                             frame.origin.y,
                                             currentFontSize.width,
                                             frame.size.height);
        }];
    }
    
    [self updateTextColor:index];
}

- (void)updateTextColor:(NSInteger)index {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[YSChannelLabel class]]) {
            YSChannelLabel *label = (YSChannelLabel *)subView;
            if (label.tag == (index * 100 + 1)) {
                label.textColor = [UIColor redColor];
            } else {
                label.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            }
        }
        
    }

}

@end


#pragma mark -
//
//@interface YSChannelLabel: UILabel
//
//@end
//
//@implementation YSChannelLabel
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.textAlignment = NSTextAlignmentCenter;
//        self.font = [UIFont systemFontOfSize:14];
//        self.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
//    }
//    
//    return self;
//}
//
//@end


