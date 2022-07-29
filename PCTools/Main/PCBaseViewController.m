//
//  PCBaseViewController.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCBaseViewController.h"
//我的位置
#import "PCLifeLocationController.h"
//火车票查询
#import "PCTicketQueryController.h"
//吉凶查看
#import "PCQueryRecreationController.h"
//今日禁忌
#import "PCTodayTabooController.h"
//壁纸
#import "PCWallpaperController.h"
//文字识别
#import "PCIdentifyTextController.h"
//房贷计算器
#import "PCHouseViewController.h"
//存款计算
#import "EUTDepositCalculatorController.h"
//纪念日计算
#import "EUTMemorialDayController.h"
//设备信息 & 网络测速
#import "EUTQueryLocationAndDeviceController.h"
//全屏计时器
#import "EUTTheTimerController.h"
//手持弹幕
#import "EUTBulletScreenController.h"
//拼长图
#import "EUTSpellLongFigureController.h"
//城市列表
#import "PCCityVC.h"
//IP、手机号、垃圾分类、大写数字
#import "EUTQueryNumAndIPController.h"
//票据识别
#import "EUTIdentifyTicketController.h"


@interface PCBaseViewController ()

@end

@implementation PCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainBgColor;
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    [self addCustomBackButtonWithImage:@"fanhui"];
}
-(void)openPageWithIndex:(NSInteger)index andTitle:(NSString*)title{
    
    if([title isEqualToString:@"房贷计算"]){
        PCHouseViewController *houseVC = [[PCHouseViewController alloc]init];
        [APPDELEGATE.baseNav pushViewController:houseVC animated:YES];
    }else if([title isEqualToString:@"存款计算"]){
        EUTDepositCalculatorController *depositVC = [[EUTDepositCalculatorController alloc]init];
        [APPDELEGATE.baseNav pushViewController:depositVC animated:YES];
    }else if([title isEqualToString:@"纪念日计算"]){
        EUTMemorialDayController *memorialVC = [[EUTMemorialDayController alloc]init];
        [APPDELEGATE.baseNav pushViewController:memorialVC animated:YES];
    }
    
    else if([title isEqualToString:@"设备信息"]){
        EUTQueryLocationAndDeviceController *locationAndDeviceVC = [[EUTQueryLocationAndDeviceController alloc]init];
        locationAndDeviceVC.pageType = EUTQuerySBXXType;
        [APPDELEGATE.baseNav pushViewController:locationAndDeviceVC animated:YES];
    }else if([title isEqualToString:@"网络测速"]){
        EUTQueryLocationAndDeviceController *locationAndDeviceVC = [[EUTQueryLocationAndDeviceController alloc]init];
        locationAndDeviceVC.pageType = EUTQueryWLCSType;
        [APPDELEGATE.baseNav pushViewController:locationAndDeviceVC animated:YES];
    }else if([title isEqualToString:@"手持弹幕"]){
        EUTBulletScreenController *bulletVC = [[EUTBulletScreenController alloc]init];
        [APPDELEGATE.baseNav pushViewController:bulletVC animated:YES];
    }else if([title isEqualToString:@"全屏计时器"]){
        EUTTheTimerController *theTimerVC = [[EUTTheTimerController alloc]init];
        [APPDELEGATE.baseNav pushViewController:theTimerVC animated:YES];
    }else if([title isEqualToString:@"拼长图"]){
        EUTSpellLongFigureController *spellVC = [[EUTSpellLongFigureController alloc]init];
        [APPDELEGATE.baseNav pushViewController:spellVC animated:YES];
    }else if([title isEqualToString:@"城市"]){
        PCCityVC *cityVC = [[PCCityVC alloc]init];
        [APPDELEGATE.baseNav pushViewController:cityVC animated:YES];
    }
    
    
    else if([title isEqualToString:@"周公解梦"]){
        PCQueryRecreationController *zgjmVC = [[PCQueryRecreationController alloc]init];
        zgjmVC.pageType = PCQueryZGJMType;
        [APPDELEGATE.baseNav pushViewController:zgjmVC animated:YES];
    }else if([title isEqualToString:@"手机号吉凶"]){
        PCQueryRecreationController *numVC = [[PCQueryRecreationController alloc]init];
        numVC.pageType = PCQuerySJHJXType;
        [APPDELEGATE.baseNav pushViewController:numVC animated:YES];
    }else if([title isEqualToString:@"今日禁忌"]){
        PCTodayTabooController *todayTabooVC = [[PCTodayTabooController alloc]init];
        [APPDELEGATE.baseNav pushViewController:todayTabooVC animated:YES];
    }
    
    
    else if([title isEqualToString:@"IP地址"]){
        EUTQueryNumAndIPController *queryVC = [[EUTQueryNumAndIPController alloc]init];
        queryVC.pageType = EUTQueryIPType;
        [APPDELEGATE.baseNav pushViewController:queryVC animated:YES];
    }else if([title isEqualToString:@"手机归属地"]){
        EUTQueryNumAndIPController *queryVC = [[EUTQueryNumAndIPController alloc]init];
        queryVC.pageType = EUTQueryNumType;
        [APPDELEGATE.baseNav pushViewController:queryVC animated:YES];
    }else if([title isEqualToString:@"垃圾分类查询"]){
        EUTQueryNumAndIPController *queryVC = [[EUTQueryNumAndIPController alloc]init];
        queryVC.pageType = EUTQueryLJFLType;
        [APPDELEGATE.baseNav pushViewController:queryVC animated:YES];
    }else if([title isEqualToString:@"大写数字"]){
        EUTQueryNumAndIPController *queryVC = [[EUTQueryNumAndIPController alloc]init];
        queryVC.pageType = EUTQueryDXZMType;
        [APPDELEGATE.baseNav pushViewController:queryVC animated:YES];
    }
    
    
    else if([title isEqualToString:@"我的位置"]){
       PCLifeLocationController *locationVC = [[PCLifeLocationController alloc]init];
       [APPDELEGATE.baseNav pushViewController:locationVC animated:YES];
   }else if([title isEqualToString:@"文字识别"]){
       PCIdentifyTextController *textVC = [[PCIdentifyTextController alloc]init];
       [APPDELEGATE.baseNav pushViewController:textVC animated:YES];
   }else if([title isEqualToString:@"票据识别"]){
       EUTIdentifyTicketController *identifyVC = [[EUTIdentifyTicketController alloc]init];
       [APPDELEGATE.baseNav pushViewController:identifyVC animated:YES];
   }else if([title isEqualToString:@"火车票查询"]){
       PCTicketQueryController *ticketVC = [[PCTicketQueryController alloc]init];
       [APPDELEGATE.baseNav pushViewController:ticketVC animated:YES];
   }else if([title isEqualToString:@"天天壁纸"]){
       PCWallpaperController *wallpaperVC = [[PCWallpaperController alloc]init];
       [APPDELEGATE.baseNav pushViewController:wallpaperVC animated:YES];
   }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
