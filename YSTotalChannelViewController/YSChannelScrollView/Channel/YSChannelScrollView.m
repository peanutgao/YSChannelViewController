//
//  YSScrollTitleView.m
//
//  Created by Joseph on 15/9/29.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSChannelScrollView.h"
#import "YSChannelLabel.h"
#import "UIView+FrameExt.h"

#define FONT_SIZE 16
#define MARGIN (18 * [UIScreen mainScreen].bounds.size.width / 375 + 0.1)
#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

typedef NS_ENUM(NSInteger, LineRectType) {
    LineRectTypeTop,
    LineRectTypeBottom,
};

@interface YSChannelScrollView()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YSChannelLabel *currentLabel;

@property (nonatomic, assign) CGRect channelSVFrame;

@property (nonatomic, strong) UIView *topDividingLine;
@property (nonatomic, strong) UIView *bottomDividingLine;

@end

@implementation YSChannelScrollView

#pragma mark - Init Method

- (instancetype)initChannelScrollViewWithFrame:(CGRect)frame channelsData:(NSArray *)channelsData {
    if (self = [super initWithFrame:frame]) {
        self.channelsData = channelsData;
        self.channelSVFrame = frame;
        
        if (self.channelBgColor == nil) {
            self.channelBgColor = [UIColor whiteColor];
        }
        
        [self setupSubviewsWithFrame:frame];
//        self.bounces = NO;
        self.backgroundColor = self.channelBgColor;

    }
    
    return self;
}


#pragma mark - Setup UI

- (void)setupSubviewsWithFrame:(CGRect)frame {
    [self setupScrollViewWithFrame:frame index:0];
    [self setupLineViewWithWithFrame:frame index:0];
    [self setupDividingLine];
}

/// line View
- (void)setupLineViewWithWithFrame:(CGRect)frame index:(NSInteger)index {
    if (self.channelsData == nil || self.channelsData.count == 0) {
        return;
    }
    CGSize fontSize = [self calculateSizeOfString:self.channelsData[index]];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN * 0.5, frame.size.height * 0.9, fontSize.width, 5)];
    _lineView.backgroundColor = self.buttomLineColor;
    [self addSubview:_lineView];
    
}

/// Dividing Line
- (void)setupDividingLine {
    _topDividingLine    = [self creatLineViewWithYRect:LineRectTypeTop];
    _bottomDividingLine = [self creatLineViewWithYRect:LineRectTypeBottom];
    [self addSubview:_topDividingLine];
    [self addSubview:_bottomDividingLine];
}


- (UIView *)creatLineViewWithYRect:(LineRectType)lineRectType {
    CGFloat Y = 0;
    switch (lineRectType) {
        case LineRectTypeTop:
            Y = 0;
            break;
        case LineRectTypeBottom:
            Y = self.channelSVFrame.size.height - 1;
            break;
        default:
            break;
    }
    // 设置上下分割线宽度, 随意设的, 宽度够长即可
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(- self.contentSize.width, Y, self.contentSize.width * 3, 1)];
    view.backgroundColor = self.dividingLineColor;
   
    return view;
}


- (void)setupScrollViewWithFrame:(CGRect)frame index:(NSInteger)index{
    // creat labels
    CGFloat contentSizeWidth = [self creatChannelLabelWithFrame:frame textColor:nil inView:self];
    self.contentSize = CGSizeMake(contentSizeWidth, 0);
    self.showsHorizontalScrollIndicator = NO;
}


- (CGFloat)creatChannelLabelWithFrame:(CGRect)frame textColor:(UIColor *)color inView:(UIView *)view{
    CGFloat channelLabelY = 1;
    CGFloat channelLabelH = frame.size.height - 2;
    __block CGFloat channelLabelX = 0;
    __block CGFloat channelLabelW = 0;
    
    if (self.channelsData == nil || self.channelsData.count == 0) {
        return 0;
    }
    
    [self.channelsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        CGSize fontSize = [self calculateSizeOfString:title];
        channelLabelW =  fontSize.width + MARGIN;
        
        CGRect frame = CGRectMake(channelLabelX, channelLabelY, channelLabelW, channelLabelH);
        YSChannelLabel *channelLabel = [self creatChannelLabelWithFrame:frame
                                                                    tag:idx * 100 + 1  // lebel的tag是(索引 * 100 + 1)
                                                                   text:title];
        channelLabel.textColor = color;
        channelLabel.scale = 1.;
        channelLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:channelLabel];
        
        channelLabelX += fontSize.width + MARGIN;
    }];
    
    return channelLabelX;
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


#pragma mark - Tap Action

- (void)tapChannelLabel:(UITapGestureRecognizer *)tapGesture {
    YSChannelLabel *view = (YSChannelLabel *)tapGesture.view;
    
    NSInteger index = (view.tag - 1) / 100;
    [self updateShowingChannel:index];

    
    if (self.channelScrollViewDelegate && [self.channelScrollViewDelegate respondsToSelector:@selector(channelScrollView:didClickChannelLabel:atIdnex:)]) {
        [self.channelScrollViewDelegate channelScrollView:self didClickChannelLabel:view atIdnex:index];
    }
}

/// 更新
- (void)updateShowingChannel:(NSInteger)index {
    [self updateFrameWithIndex:index];
    [self updateTextDisplayWithIndex:index];
}


///
- (void)updateFrameWithIndex:(NSInteger)index {
    if (self.channelsData == nil || self.channelsData.count == 0) {
        return;
    }
    
    CGFloat offsetX = 0;
    CGFloat lineOffsetX = 0;
    CGSize currentFontSize = [self calculateSizeOfString:self.channelsData[index]];
    
    __block CGFloat preMarge = 0;
    __weak typeof(self) weakSelf = self;
    if (index > 0) {
        [self.channelsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            preMarge += [weakSelf calculateSizeOfString:obj].width + MARGIN;
            if (idx == index - 1) {
                *stop = YES;
            }
        }];
        
        // line offset
        lineOffsetX = preMarge + MARGIN * 0.5;
        
        // title offset
        if ((preMarge + currentFontSize.width * 0.5) < YS_SCREEN_WIDTH * 0.5) {
            offsetX = 0;
            
        } else if ((preMarge + currentFontSize.width * 0.5) >= YS_SCREEN_WIDTH * 0.5 &&
                   (self.contentSize.width - (preMarge + currentFontSize.width * 0.5) > YS_SCREEN_WIDTH * 0.5)) {
            offsetX = preMarge  + currentFontSize.width * 0.5 - YS_SCREEN_WIDTH * 0.5;
            
        } else if ((self.contentSize.width - (preMarge + currentFontSize.width * 0.5) <= YS_SCREEN_WIDTH * 0.5)) {
            offsetX = self.contentSize.width - YS_SCREEN_WIDTH;
        }
        
        
        if (self.animTime <= 0) {
            self.animTime = .3f;
        }
        [UIView animateWithDuration:self.animTime animations:^{
            [self setContentOffset:CGPointMake(offsetX, 0)];
            [self.lineView setYs_width:currentFontSize.width];
            [self.lineView setYs_x:lineOffsetX];
        }];
        
    } else {
        [UIView animateWithDuration:self.animTime animations:^{
            [self setContentOffset:CGPointMake(0, 0)];
            [self.lineView setYs_x:lineOffsetX + MARGIN * 0.5];
            self.lineView.ys_width = currentFontSize.width;
        }];
    }
}


- (void)updateTextDisplayWithIndex:(NSInteger)index {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[YSChannelLabel class]]) {
            YSChannelLabel *label = (YSChannelLabel *)subView;
            
            [UIView animateWithDuration:0.25 animations:^{
                if (label.tag == (index * 100 + 1)) {
                    label.textColor = self.selectedTextColor == nil ? [UIColor redColor] : self.selectedTextColor;
                    label.scale = self.scaleEnable ? 1.1 : 1.;
                } else {
                    label.textColor = self.normalTextColor == nil ? RGB(80, 80, 80) : self.normalTextColor;
                    label.scale = 1.;
                }
            }];

        }
    }
}


#pragma mark -

- (void)update {
    [self setupSubviewsWithFrame:self.channelSVFrame];
    [self layoutIfNeeded];
}

- (void)setDividingLineColor:(UIColor *)dividingLineColor {
    _dividingLineColor = dividingLineColor;
    
    _topDividingLine.backgroundColor    = dividingLineColor;
    _bottomDividingLine.backgroundColor = dividingLineColor;
}

- (void)setChannelBgColor:(UIColor *)channelBgColor {
    if (channelBgColor == nil) {
        channelBgColor = [UIColor whiteColor];
    }
    
    _channelBgColor = channelBgColor;
    self.backgroundColor = channelBgColor;
}

- (void)setButtomLineColor:(UIColor *)buttomLineColor {
    if (!buttomLineColor) {
        buttomLineColor = [UIColor redColor];
    }
    _buttomLineColor = buttomLineColor;
    self.lineView.backgroundColor = buttomLineColor;
}

@end





