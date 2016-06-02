//
//  YWDemoViewController.m
//  YSChannelViewController
//
//  Created by Joseph Gao on 15/12/27.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YWDemoViewController.h"

@interface YWDemoViewController ()

@end

@implementation YWDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0
                                                green:arc4random_uniform(256)/255.0
                                                 blue:arc4random_uniform(256)/255.0
                                                alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
