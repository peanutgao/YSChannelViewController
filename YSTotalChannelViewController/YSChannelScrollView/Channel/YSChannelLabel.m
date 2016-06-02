//
//  YSLabel.m
//
//  Created by Joseph on 15/10/26.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSChannelLabel.h"

@implementation YSChannelLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        self.scale = 0.0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    CGFloat minScale = 1;
    CGFloat trueScale = minScale * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
