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
//#define MARGIN (18 * [UIScreen mainScreen].bounds.size.width / 375 + 0.1)
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

@property (nonatomic, strong) NSMutableArray *labelArrayM;

/// 内容总宽度 + 间距
@property (nonatomic, assign) CGFloat totalWidth;

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
        self.backgroundColor = self.channelBgColor;
        //        self.bounces = NO;
        
        self.channelMargin = 10;
        if (self.leftMargin == 0) {
            self.leftMargin = 30;
        }
        
        [self setupSubviewsWithFrame:frame];
        [self setupDividingLine];

    }
    
    return self;
}


#pragma mark - Setup UI

- (void)setupSubviewsWithFrame:(CGRect)frame {
    [self setupScrollViewWithFrame:frame index:0];
    [self setupLineViewWithWithFrame:frame index:0];
}

/// line View
- (void)setupLineViewWithWithFrame:(CGRect)frame index:(NSInteger)index {
    if (self.channelsData == nil || self.channelsData.count == 0) {
        return;
    }
    CGSize fontSize = [self calculateSizeOfString:self.channelsData[index]];
    
    
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
    }
    
    if (self.lineWidth <= 0) {
        _lineView.frame = CGRectMake(self.leftMargin, frame.size.height * 0.9, fontSize.width, 5);
    }
    else {
        _lineView.bounds = CGRectMake(0, 0, self.lineWidth, 5);
        _lineView.ys_y = frame.size.height * 0.9;
    }
    
    _lineView.backgroundColor = self.buttomLineColor;
    [self addSubview:_lineView];
    
}

/// Dividing Line,上下分割线
- (void)setupDividingLine {
    _topDividingLine    = [self creatDividingLineViewWithYRect:LineRectTypeTop];
    _bottomDividingLine = [self creatDividingLineViewWithYRect:LineRectTypeBottom];
    [self addSubview:_topDividingLine];
    [self addSubview:_bottomDividingLine];
}


- (UIView *)creatDividingLineViewWithYRect:(LineRectType)lineRectType {
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
    CGFloat contentSizeWidth = [self creatChannelLabelWithTextColor:nil inView:self];
    self.contentSize = CGSizeMake(contentSizeWidth, 0);
    self.showsHorizontalScrollIndicator = NO;
}


- (CGFloat)creatChannelLabelWithTextColor:(UIColor *)color inView:(UIView *)view{
    if (self.channelsData == nil || self.channelsData.count == 0) {
        return 0;
    }
    
    CGFloat channelLabelY = 1;
    CGFloat channelLabelH = self.channelSVFrame.size.height - 2;
    __block CGFloat channelLabelX = self.leftMargin;
    __block CGFloat channelLabelW = 0;
    __block YSChannelLabel *lastLabel = nil;
    __block NSMutableArray *fontWidthM = [NSMutableArray arrayWithCapacity:self.channelsData.count];    // 保存文字宽度
    [self.channelsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        CGFloat fontWidth = [self calculateSizeOfString:title].width;
        [fontWidthM addObject:[NSNumber numberWithFloat:fontWidth]];
        
        channelLabelW =  fontWidth + self.channelMargin;
        
        CGRect frame = CGRectMake(channelLabelX, channelLabelY, channelLabelW, channelLabelH);
        YSChannelLabel *channelLabel = [self creatChannelLabelWithFrame:frame
                                                                    tag:idx * 100 + 1  // lebel的tag是(索引 * 100 + 1)
                                                                   text:title];
        channelLabel.textColor = color;
        channelLabel.scale = 1.;
        channelLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:channelLabel];
        
        channelLabelX += fontWidth + self.channelMargin;
        lastLabel = channelLabel;
        
        [self.labelArrayM addObject:channelLabel];
    }];
    
    
    // 均分
    // 返回 contentSize Width
    return [self contentSizeW:channelLabelX OfAverageMarginWithFontWidths:fontWidthM];
}


/// 均分间距, 重新布局间距
- (CGFloat)contentSizeW:(CGFloat)contentSizeW OfAverageMarginWithFontWidths:(NSArray *)fontWidths {

    YSChannelLabel *lastLabel = [self.labelArrayM lastObject];
    CGFloat totalWidth = CGRectGetMaxX(lastLabel.frame);
    if (totalWidth < YS_SCREEN_WIDTH) {
        if (self.channelsData.count == 1) {
            lastLabel.ys_centerX = self.ys_centerX;
        }
        else {
            __block CGFloat allFontWidth = 0;
            [fontWidths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                allFontWidth += [obj floatValue];
            }];
            
            CGFloat averageMargin = (YS_SCREEN_WIDTH - allFontWidth - self.leftMargin * 2)/(self.channelsData.count - 1);
            
            __weak typeof(self) weakSelf = self;
            [self.labelArrayM enumerateObjectsUsingBlock:^(YSChannelLabel *channelLabel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    channelLabel.ys_x = weakSelf.leftMargin;
                }
                else {
                    YSChannelLabel *preLabel = weakSelf.labelArrayM[idx - 1];
                    CGFloat x = averageMargin + CGRectGetMaxX(preLabel.frame);
                    channelLabel.ys_x = x;
                }
            }];
        }
        
        // contentSize width
        contentSizeW = CGRectGetMaxX(lastLabel.frame) + self.leftMargin;
    }
    
    return contentSizeW;
}


- (CGSize)calculateSizeOfString:(NSString *)aString{
    return [aString boundingRectWithSize:self.frame.size
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}
                                 context:nil].size;
}


- (YSChannelLabel *)creatChannelLabelWithFrame:(CGRect)frame tag:(NSInteger)tag text:(NSString *)text {
    YSChannelLabel *channelLabel = [[YSChannelLabel alloc] initWithFrame:frame];
    
    channelLabel.userInteractionEnabled = YES;
    channelLabel.text = text;
    channelLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    channelLabel.tag = tag;
    [channelLabel sizeToFit];
    
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
    [self updateLineLocationWithIndex:index];
    [self updateTextDisplayWithIndex:index];
}


/// 更新下横线位置
- (void)updateLineLocationWithIndex:(NSInteger)index {
    if (self.channelsData == nil || self.channelsData.count == 0) {
        return;
    }
    
    CGFloat offsetX = 0;
    __block CGFloat lineOffsetX = 0;
    CGSize currentFontSize = [self calculateSizeOfString:self.channelsData[index]];
    
    YSChannelLabel *currentLabel = self.labelArrayM[index];

    
    __block CGFloat preMarge = 0;
    __weak typeof(self) weakSelf = self;
    if (index > 0) {
        [self.channelsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            preMarge += [weakSelf calculateSizeOfString:obj].width + self.channelMargin;
            if (idx == index - 1) {
                *stop = YES;
            }
        }];
        
        
        // line offset
        lineOffsetX = preMarge + self.channelMargin * 0.5;
        
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
            
            self.lineView.ys_width = self.lineWidth == 0 ? currentFontSize.width : self.lineWidth;
//            self.lineView.ys_width = currentFontSize.width;
            self.lineView.ys_centerX = currentLabel.ys_centerX;
        }];

        
    } else {
        [UIView animateWithDuration:self.animTime animations:^{
            [self setContentOffset:CGPointMake(0, 0)];
            self.lineView.ys_width = self.lineWidth == 0 ? currentFontSize.width : self.lineWidth;
//            self.lineView.ys_width = currentFontSize.width;

            
            lineOffsetX += (currentFontSize.width - self.lineView.ys_width) * 0.5;
//            [self.lineView setYs_x:lineOffsetX + self.leftMargin];
            self.lineView.ys_centerX = currentLabel.ys_centerX;
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

- (void)setLineWidth:(CGFloat)lineWidth {
    if (lineWidth < 0) {
        lineWidth = 80;
    }
    
    _lineWidth= lineWidth;
}


- (NSMutableArray *)labelArrayM {
    if (!_labelArrayM) {
        _labelArrayM = [NSMutableArray array];
    }
    return _labelArrayM;
}

@end





