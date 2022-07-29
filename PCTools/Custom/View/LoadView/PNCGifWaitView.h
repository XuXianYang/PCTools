//
//  PNCGifWaitView.h
//  BankOfCommunications
//
//  Created by Mac on 15-11-22.
//  Copyright (c) 2015年 P&C. All rights reserved.
// 等待层

#import "PNCView.h"


typedef NS_ENUM(NSUInteger, PNCGifWaitingStyle) {
    DefaultWaitStyle, // 灰底白色转圈
    BlueWaitStyle,    // 无底色蓝色转圈
    LongLoginWaitStyle,   // 长登录专用
    PartLoadWaitStyle,     // 局部加载专用
    ClearColorStyle
};

@interface PNCGifWaitView : PNCView

//等待层显示在viewController
+(void)showWaitViewInController:(UIViewController *)vc style:(PNCGifWaitingStyle)style;
+(void)hideWaitViewInController:(UIViewController *)vc;
//是否旋转90度
+(void)showWaitViewInController:(UIViewController *)vc style:(PNCGifWaitingStyle)style isRotate:(BOOL)rotate;

//等待层显示在 UIView上
+(void)showWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style;
+(void)hideWaitViewInView:(UIView *)view;
//唤醒长登录时用
+ (void)hideLongLoginWaitView;
// 隐藏下拉刷新的蒙版
+ (void)hideRefreshWaitView:(UIView *)view;

//等待层全屏覆盖在 View上 带提示语 是否旋转
+(void)showWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style isRotate:(BOOL)isRotate;

+(UIView *)bcmShowWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style;

@end





