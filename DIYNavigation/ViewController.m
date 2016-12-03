//
//  ViewController.m
//  DIYNavigation
//
//  Created by 李亚东 on 16/11/25.
//  Copyright © 2016年 李亚东. All rights reserved.
//

#import "ViewController.h"
#import "DiyNavigation.h"
#import "BViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *clickButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, 100, 30)];
    [clickButton setTitle:@"点击跳转" forState:UIControlStateNormal];
    [clickButton setBackgroundColor:[UIColor greenColor]];
    
    [clickButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickButton];
    

}


- (void)handleAction:(id)sender {
    
    NSLog(@"sssssssssssssss");
    BViewController *bvc = [[BViewController alloc] init];
    
    [self.navigationController pushViewController:bvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
