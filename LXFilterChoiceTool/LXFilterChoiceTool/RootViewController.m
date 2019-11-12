//
//  RootViewController.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/12.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.navigationItem.title = @"根";
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ViewController* vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
