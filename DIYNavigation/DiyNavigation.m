//
//  DiyNavigation.m
//  DIYNavigation
//
//  Created by 李亚东 on 16/11/25.
//  Copyright © 2016年 李亚东. All rights reserved.
//

#import "DiyNavigation.h"

#define KWHC_NAV_LEFT_VIEW_TAG (203994850)                         //左边view的tag
#define KWHC_NAV_LEFT_PUSH_VIEW_TAG (KWHC_NAV_LEFT_VIEW_TAG + 1)   //左边pushView的tag
#define KWHC_NAV_NAVBAR_TAG (KWHC_NAV_LEFT_VIEW_TAG + 2)           //导航条的tag
#define KWHC_NAV_ANIMATION_DURING (0.3)                            //pop或者push动画周期
#define KWHC_NAV_POP_VIEW_CENTERX_OFFSET (0)                       //popView中心x轴偏移 （禁止修改值）
#define KWHC_NAV_PUSH_VIEW_CENTERX_OFFSET (0)                      //pushView中心x偏移  (禁止修改值)
#define KWHC_NAV_POP_VIEW_ALPHA (0.5)                              //popview透明系数
#define KWHC_NAV_ALLOW_PULL_DISTANCE (30.0)                        //可以拉开允许的距离


@interface DiyNavigation ()
{
UIPanGestureRecognizer           *   _panGesture;              //手势
CGFloat                              _currentTx;               //存储当前触摸x值
NSMutableArray                   *   _snapshootList;           //快照数组
UIView                           *   _popView;                 //弹出view
UIView                           *   _pushView;                //压站view
UIView                           *   _topView;                 //顶部视图
BOOL                                 _willOpen;                //是否将要拉开
BOOL                                 _didOpen;                 //是否已经拉开
BOOL                                 _isTouchPop;              //是否触摸弹出
}

@end

static DiyNavigation *whc_navigation;

@implementation DiyNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//单例实现
+ (instancetype)sharedInstance{
    UIViewController  * rootVC = [[NSClassFromString(KWHC_Nav_Main_VC_Name) alloc]init];
    //        UIViewController  * rootVC = [[NSClassFromString(KWHC_Side_Menu_N_Main_VC_Name) alloc]initWithNibName:KWHC_Nav_Main_VC_Name bundle:nil];
    return [DiyNavigation sharedInstanceWithMainVC:rootVC];
}

+ (instancetype)sharedInstanceWithMainVC:(UIViewController*)mainVC{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        whc_navigation = [[DiyNavigation alloc]initWithRootViewController:mainVC];
        whc_navigation.delegate = whc_navigation;
    });
    return whc_navigation;
}
#pragma mark - initMothed

//重载父类初始化方法
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if(self){
        [self registPanGesture:YES];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self != nil){
        [self registPanGesture:YES];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if(self != nil){
        [self registPanGesture:YES];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self registPanGesture:YES];
    }
    return self;
}
#pragma mark - gestureMothed
//注册手势事件
- (void)registPanGesture:(BOOL)b{
    self.interactivePopGestureRecognizer.enabled = NO;
    if(b){
        if(_panGesture == nil){
            _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
            [_panGesture delaysTouchesBegan];
            [self.view addGestureRecognizer:_panGesture];
        }
    }else{
        if(_panGesture != nil){
            [self.view removeGestureRecognizer:_panGesture];
            _panGesture = nil;
        }
    }
}

#pragma mark - handleGesture
- (void)handlePanGesture:(UIPanGestureRecognizer*)panGesture{
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            _currentTx = self.view.transform.tx;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGFloat  moveDistance = [panGesture translationInView:panGesture.view].x;
            if(!_willOpen){
                if(KWHC_Nav_Pop_Form_Border < (0)){
                    if(moveDistance < KWHC_NAV_ALLOW_PULL_DISTANCE){
                        return;
                    }
                }else{
                    CGFloat touchX = [panGesture locationInView:panGesture.view].x;
                    if(touchX > KWHC_Nav_Pop_Form_Border){
                        return;
                    }
                }
            }
            CGFloat  oriX = [panGesture velocityInView:panGesture.view].x;
            CGFloat  rate = moveDistance / CGRectGetWidth(self.view.frame);
            if(oriX > 0){//open door
                [self popView];
                if(!_willOpen && _popView != nil){
                    
                    UIView * oldPopView = [self.view.superview viewWithTag:KWHC_NAV_LEFT_VIEW_TAG];
                    if(oldPopView){
                        [oldPopView removeFromSuperview];
                    }
                    [self.view.superview insertSubview:_popView belowSubview:self.view];
                    _willOpen = YES;
                    
                }
                if(_willOpen && moveDistance >= 0.0){
                    
                    self.view.transform = [self initAffineTransform:moveDistance + _currentTx];
                    _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET + rate * CGRectGetWidth(_popView.frame) / 2.0, _popView.center.y);
                    _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA * (rate + 1.0);
                    
                }
                
            }else if(oriX < 0 && _willOpen && moveDistance >= 0.0){//close door
                
                self.view.transform = [self initAffineTransform:moveDistance + _currentTx];
                _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET + rate * CGRectGetWidth(_popView.frame) / 2.0, _popView.center.y);
                _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA * (rate + 1.0);
                
            }else if(_willOpen){
                
                if(moveDistance < 0.0 && self.view.transform.tx > 0){
                    self.view.transform = [self initAffineTransform:0.0];
                    _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET, _popView.center.y);
                    _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA;
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            if(_willOpen){
                if(self.view.transform.tx / CGRectGetWidth(self.view.frame) < KWHC_Nav_Touch_Back_Rate){
                    [self closeLeftView:YES];
                }else{
                    [self closeLeftView:NO];
                }
            }
        }
            break;
        default:
            break;
    }
}

//偏移变换
- (CGAffineTransform)initAffineTransform:(CGFloat)x{
    return  CGAffineTransformMakeTranslation(x, 0.0);
}

//对当前控制器进行快照
- (UIImage*)snapshootNavBar:(UIViewController*)vc{
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage  * snapshootImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshootImage;
}

//获取要弹出view的快照view
- (UIView*)popView{
    if(_snapshootList != nil && _snapshootList.count > 1){
        _popView = [_snapshootList lastObject];
        _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET, _popView.center.y);
        _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA;
    }else{
        _popView = nil;
    }
    return _popView;
}

//获取已经push的快照view
- (UIView*)pushView{
    if(_snapshootList != nil && _snapshootList.count > 0){
        _pushView = [_snapshootList lastObject];
        _pushView.center = CGPointMake(KWHC_NAV_PUSH_VIEW_CENTERX_OFFSET, _pushView.center.y);
        _pushView.alpha = 1.0;
    }else{
        _pushView = nil;
    }
    return _pushView;
}

//pop或者取消pop操作
- (void)closeLeftView:(BOOL)isClose{
    [self registPanGesture:NO];
    _willOpen = NO;
    UIView * mainView = self.view;
    __weak  typeof(self) sf = self;
    if(isClose){
        [UIView animateWithDuration:KWHC_NAV_ANIMATION_DURING delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET, _popView.center.y);
            _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA;
            mainView.transform = [sf initAffineTransform:0.0];
        } completion:^(BOOL finished) {
            [sf registPanGesture:YES];
            [_popView  removeFromSuperview];
            _popView = nil;
        }];
    }else{//pop opeartion
        [UIView animateWithDuration:KWHC_NAV_ANIMATION_DURING delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            mainView.transform = [sf initAffineTransform:CGRectGetWidth(mainView.frame)];
            _popView.center = CGPointMake(CGRectGetWidth(_popView.frame) / 2.0, _popView.center.y);
            _popView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [sf registPanGesture:YES];
            _isTouchPop = YES;
            mainView.transform = [sf initAffineTransform:0];
            [sf popViewControllerAnimated:NO];
        }];
    }
}

#pragma mark - viewLoad
//重载父类push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(_snapshootList == nil){
        _snapshootList = [NSMutableArray array];
    }
    [_snapshootList addObject:[[UIImageView alloc]initWithImage:[self snapshootNavBar:viewController]]];
    [self pushView];
    //忽略第一次push操作
    if(_pushView && animated && _snapshootList != nil){
        
        __weak  typeof(self) sf = self;
        //防止重复push
        _topView = self.topViewController.view;
        _topView.userInteractionEnabled = NO;
        [super pushViewController:viewController animated:NO];
        self.view.transform = [self initAffineTransform:CGRectGetWidth(self.view.frame)];
        UIView * oldPushView = [self.view.superview viewWithTag:KWHC_NAV_LEFT_PUSH_VIEW_TAG];
        if(oldPushView){
            [oldPushView removeFromSuperview];
            oldPushView = nil;
        }
        _pushView.center = CGPointMake(CGRectGetWidth(_pushView.frame) / 2.0, _pushView.center.y);
        [self.view.superview insertSubview:_pushView belowSubview:self.view];
        [UIView animateWithDuration:KWHC_NAV_ANIMATION_DURING delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _pushView.center = CGPointMake(-CGRectGetWidth(_pushView.frame) / 2.0, _pushView.center.y);
            _pushView.alpha = KWHC_NAV_POP_VIEW_ALPHA;
            sf.view.transform = [sf initAffineTransform:0];
        } completion:^(BOOL finished) {
            [_pushView removeFromSuperview];
            _pushView = nil;
        }];
        
    }else{
        
        [super pushViewController:viewController animated:animated];
    }
}

//重写父类pop方法
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    UIViewController  * viewController = nil;
    if(!_isTouchPop){
        //不是触摸弹出操作
        __weak  typeof(self) sf = self;
        __block UIView  * popView = [[UIImageView alloc]initWithImage:[self snapshootNavBar:nil]];
        viewController = [super popViewControllerAnimated:NO];
        if(popView){
            self.view.transform = [self initAffineTransform:-CGRectGetWidth(self.view.frame)];
            self.view.alpha = KWHC_NAV_POP_VIEW_ALPHA;
            UIView  * oldPopView = [self.view.superview viewWithTag:KWHC_NAV_LEFT_VIEW_TAG];
            if(oldPopView){
                [oldPopView removeFromSuperview];
                oldPopView = nil;
            }
            popView.center = CGPointMake(CGRectGetWidth(popView.frame) / 2.0, popView.center.y);
            [self.view.superview insertSubview:popView belowSubview:self.view];
            [UIView animateWithDuration:KWHC_NAV_ANIMATION_DURING delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                popView.center = CGPointMake(CGRectGetWidth(popView.frame) * 1.5, popView.center.y);
                sf.view.transform = [sf initAffineTransform:0];
                sf.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                [popView removeFromSuperview];
                popView = nil;
                [_snapshootList removeLastObject];
            }];
        }
    }else{
        //清除popview的快照存储
        [_snapshootList removeLastObject];
        [_popView removeFromSuperview];
        _popView = nil;
        viewController = [super popViewControllerAnimated:animated];
    }
    _isTouchPop = NO;
    return viewController;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(_topView != nil){
        _topView.userInteractionEnabled = YES;
    }
}
@end
