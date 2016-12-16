//
//  BViewController.m
//  DIYNavigation
//
//  Created by 李亚东 on 16/11/26.
//  Copyright © 2016年 李亚东. All rights reserved.
//

#import "BViewController.h"
#import "CViewController.h"
@interface BViewController ()

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"B控制器";
    
    
    UIButton *clickButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 50)];
    [clickButton setTitle:@"下一页" forState:UIControlStateNormal];
    [clickButton setBackgroundColor:[UIColor greenColor]];
    
    [clickButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickButton];


    
}
- (void)handleAction:(id)sender {
    
     CViewController *cVC = [[CViewController alloc] init];
    [self.navigationController pushViewController:cVC animated:YES];
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
