//
//  YSDemoTableViewController.m
//  水平滚动菜单
//
//  Created by Joseph Gao on 16/5/24.
//  Copyright © 2016年 Joseph. All rights reserved.
//

#import "YSDemoTableViewController.h"

@interface YSDemoTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArayM;

@end

@implementation YSDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"APPLE";
    
    _dataArayM = [NSMutableArray array];
    for (int i = 0; i < 40; i++) {
        [_dataArayM addObject:@"Apple"];
    };
    
    self.tableView.showsVerticalScrollIndicator = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"REUSE_ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"REUSE_ID"];
    }
    if (self.tempInfo == nil) {
        cell.textLabel.text = self.dataArayM[indexPath.row];
    } else {
        cell.textLabel.text = self.tempInfo;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
