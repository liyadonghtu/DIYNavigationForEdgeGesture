//
//  DiyNavigation.h
//  DIYNavigation
//
//  Created by 李亚东 on 16/11/25.
//  Copyright © 2016年 李亚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#define KWHC_Nav_Main_VC_Name (@"ViewController")     //主控制器类名
#define KWHC_Nav_Touch_Back_Rate (0.4)            //触摸拖拽可以返回条件比例
#define KWHC_Nav_Pop_Form_Border (-1)             //note > 0 from border pull < 0 any where pull diatancex > 30

@interface DiyNavigation : UINavigationController

//单例默认用KWHC_Nav_Main_VC_Name作为主控制器
+ (instancetype)sharedInstance;

//单例自定义主控制器
+ (instancetype)sharedInstanceWithMainVC:(UIViewController*)mainVC;





@end
