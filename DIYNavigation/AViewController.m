//
//  AViewController.m
//  DIYNavigation
//
//  Created by 李亚东 on 2016/12/3.
//  Copyright © 2016年 李亚东. All rights reserved.
//

#import "AViewController.h"
#import "BViewController.h"


@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"A控制器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *clickButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 50)];
    [clickButton setTitle:@"下一页" forState:UIControlStateNormal];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
