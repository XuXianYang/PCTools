//
//  PCBaseTabBarController.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCBaseTabBarController.h"
#import "PCHomeViewController.h"
#import "EUTHomeViewController.h"

@interface PCBaseTabBarController ()<PCCustomTabBarDelegate>


@end

@implementation PCBaseTabBarController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.tabBar.hidden = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildControllers];
    [self setupCustomTabBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//添加子控制器
-(void)addChildControllers {
    //首页
    PCHomeViewController * homeVC = [[PCHomeViewController alloc]init];
    PCBaseNavigationController*homeNav = [[PCBaseNavigationController alloc]initWithRootViewController:homeVC];
    //生活
    EUTHomeViewController * menuVC = [[EUTHomeViewController alloc] init];
    PCBaseNavigationController *menuNav = [[PCBaseNavigationController alloc]initWithRootViewController:menuVC];
    
    self.viewControllers = @[homeNav,menuNav];
    
}
//添加自定义tabBar
-(void)setupCustomTabBar
{
    customTabBar = [[PCCustomTabBar alloc]init];
    [self.view addSubview:customTabBar];
    customTabBar.delegate = self;
    [customTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(PCTabbarHeight);
    }];
    
}
//双击刷新
-(void)tabBarButtonRepeatCliked:(NSInteger)index
{
}
-(void)tabBarButtonCliked:(NSInteger)index
{
    self.selectedIndex = index;
}
- (void)selectItemAtIndex:(NSInteger)index
{
    if (index > self.viewControllers.count - 1) {
        return;
    }
    [customTabBar selectedItems:index];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
