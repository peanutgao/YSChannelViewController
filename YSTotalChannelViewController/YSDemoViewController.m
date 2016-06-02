//
//  YSDemoViewController.m
//  水平滚动菜单
//
//  Created by Joseph Gao on 15/12/27.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSDemoViewController.h"

@interface YSDemoViewController ()

@end

@implementation YSDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0
                                                green:arc4random_uniform(256)/255.0
                                                 blue:arc4random_uniform(256)/255.0
                                                alpha:1.0];
}


@end
