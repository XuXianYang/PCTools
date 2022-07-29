//
//  PCBaseNavigationController.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCBaseNavigationController.h"

@interface PCBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation PCBaseNavigationController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self reconfigure];
    }
    return self;
}
-(void)reconfigure {
    
    //设置导航栏字体颜色
    CGFloat font=17;
    if(kScreenH==667){
        font=18;
    }else if(kScreenH>667){
        font=19;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font],NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)}];
    // 导航栏黑线 设置透明
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundColor:MainColor];
    //取消半透明效果
    //self.navigationBar.translucent = NO;
    //设置导航栏背景
    [self.navigationBar setBarTintColor: MainColor];
 
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc]init];
        barAppearance.backgroundColor = MainColor;
        [barAppearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font],NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)}];
        self.navigationBar.scrollEdgeAppearance = barAppearance;
        self.navigationBar.standardAppearance = barAppearance;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //默认开启系统自带的手势 导航栏透明时需要加这两行代码
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
}
//解决滑动返回上一页与scrollView冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    //    NSLog(@"otherGestureRecognizer.view==%@",otherGestureRecognizer.view);
    // 首先判断otherGestureRecognizer是不是系统pop手势
    //    NSLog(@"otherGestureRecognizer.view=%@",otherGestureRecognizer.view);
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UIScrollView")]) {
        UIScrollView*scroview = (UIScrollView*)otherGestureRecognizer.view;
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && scroview.contentOffset.x == 0)
        {
            return YES;
        }
    }
    return NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer*pan = (UIPanGestureRecognizer *)gestureRecognizer;
        ;
        if ([pan translationInView:self.view].y>0||[pan translationInView:self.view].y<0)
        {
            return NO;
        }
    }
    return self.childViewControllers.count == 1?NO:YES;
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
