//
//  PNCGifWaitView.m
//  BankOfCommunications
//
//  Created by Mac on 15-11-22.
//  Copyright (c) 2015年 P&C. All rights reserved.
//


#import "PNCGifWaitView.h"

@interface PNCGifWaitView ()

@property(strong,nonatomic)UIView *supView;
@property(strong,nonatomic)UIImageView *WaitImgView;
@property (nonatomic, assign) BOOL isRotate;

@end

@implementation PNCGifWaitView

#pragma  mark -  等待层覆盖在 UIViewController 上导航栏以下部分
+(void)showWaitViewInController:(UIViewController *)vc style:(PNCGifWaitingStyle)style
{
    PNCGifWaitView *waitView = (PNCGifWaitView *)[vc.view viewWithTag:9001];
   
    if (waitView==nil) {
        PNCGifWaitView *waitView = [[PNCGifWaitView alloc]initWithSuperViewController:vc style:style];
        [waitView show];
    }
  
}

#pragma  mark -  等待层覆盖在 UIViewController 上导航栏以下部分 __旋转90度
+(void)showWaitViewInController:(UIViewController *)vc style:(PNCGifWaitingStyle)style isRotate:(BOOL)rotate
{
    PNCGifWaitView *waitView = (PNCGifWaitView *)[vc.view viewWithTag:9001];
    
    if (waitView==nil) {
        PNCGifWaitView *waitView = [[PNCGifWaitView alloc]initWithSuperViewController:vc style:style isRotate:YES];
        [waitView show];
    }
    waitView.isRotate = YES;
}

#pragma  mark -  等待层全屏覆盖在 View上 带提示语 及 是否旋转
+(void)showWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style isRotate:(BOOL)isRotate
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView =[[PNCGifWaitView alloc]initWithSuperView:superView style:style isRotate:isRotate];
    [waitView show];
}


+(void)hideWaitViewInController:(UIViewController *)vc
{
    PNCGifWaitView *waitView = (PNCGifWaitView *)[vc.view viewWithTag:9001];
    if (waitView != nil) {
        [waitView hide];
    }
}


#pragma  mark -  等待层全屏覆盖在 View上

+(UIView *)bcmShowWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView =[[PNCGifWaitView alloc]initWithSuperView:superView style:style];
    [waitView show];
    return waitView;
}

+(void)showWaitViewInView:(UIView *)view style:(PNCGifWaitingStyle)style
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView =[[PNCGifWaitView alloc]initWithSuperView:superView style:style];
    [waitView show];
}

+(void)hideWaitViewInView:(UIView *)view
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView=(PNCGifWaitView *)[superView viewWithTag:9001];
    [waitView hide];
}
#pragma 隐藏刷新加载的透明蒙版
+ (void)hideRefreshWaitView:(UIView *)view
{
    UIView *superView=view;
    
    if(superView==nil){
        UIWindow *window=[[UIApplication sharedApplication]keyWindow];
        superView=window;
    }
    
    PNCGifWaitView *waitView=(PNCGifWaitView *)[superView viewWithTag:9003];
    [waitView hide];
}
#pragma 为了配合长登录 增加倒8
+ (void)hideLongLoginWaitView {
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    PNCGifWaitView * waitView = (PNCGifWaitView *)[window viewWithTag:9002];
    if (waitView) {
        [waitView hide];
    }
}

-(id)initWithSuperView:(UIView *)superView style:(PNCGifWaitingStyle)style{
    
    if (self = [super init]) {
        _supView = superView;
        self.frame = superView.bounds;
        [self drawFrame:style];
    }
    return self;
}


-(id)initWithSuperViewController:(UIViewController *)viewController style:(PNCGifWaitingStyle)style
{
    if (self = [super init]) {
      
        _supView = viewController.view;
        self.size = CGSizeMake(kScreenW, kScreenH - PCNaviBarHeight);
        self.origin = CGPointMake(0, PCNaviBarHeight);

        [self drawFrame:style];
    
    }
    return self;
}

-(id)initWithSuperViewController:(UIViewController *)viewController style:(PNCGifWaitingStyle)style isRotate:(BOOL)rotate
{
    if (self = [super init]) {
        
        _supView = viewController.view;
        self.size=CGSizeMake(kScreenW,kScreenH-PCNaviBarHeight);
        self.origin=CGPointMake(0, PCNaviBarHeight);
        self.isRotate = rotate;
        [self drawFrame:style];
        
    }
    return self;
}

-(id)initWithSuperView:(UIView *)superView style:(PNCGifWaitingStyle)style isRotate:(BOOL)isRotate{
    
    if (self = [super init]) {
        _supView = superView;
        self.frame = superView.bounds;
        self.isRotate = isRotate;
        [self drawFrame:style];
    }
    return self;
}

-(void)setIsRotate:(BOOL)isRotate
{
    _isRotate = isRotate;
}

- (void)drawFrame:(PNCGifWaitingStyle)style {
    
    if (style == DefaultWaitStyle || style == LongLoginWaitStyle) { //灰底白色转圈样式
        
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake((self.width - kAutoScale(75))/2, self.height*0.4 - kAutoScale(75)/2, kAutoScale(75), kAutoScale(75))];
        
        if(self.height == kScreenH - PCNaviBarHeight) {
            mainview.origin = CGPointMake((self.width - kAutoScale(75))/2, kScreenH*0.4 - kAutoScale(75)/2 - PCNaviBarHeight);
        }
        if (self.isRotate) {
            //旋转90度
            mainview.transform = CGAffineTransformRotate(mainview.transform, M_PI*0.5);
            mainview.center = CGPointMake(self.width/2, self.height/2);
        }
        [mainview setBackgroundColor:[UIColor blackColor]];
        mainview.layer.cornerRadius = 12;
        mainview.alpha = 0.5;
        
        self.WaitImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAutoScale(55), kAutoScale(55))];
        [self.WaitImgView setCenter:CGPointMake(mainview.width/2, mainview.height/2)];
        
        self.WaitImgView.animationImages = [CommonTool shareInstance].loadWhiteImgArr;
        self.WaitImgView.animationDuration = 1;
        self.WaitImgView.animationRepeatCount = 0;
        [self.WaitImgView startAnimating];
        
        [mainview addSubview:self.WaitImgView];
        
        self.tag = 9001;
        if (style == LongLoginWaitStyle){
            self.tag = 9002;
        }
        [self addSubview:mainview];
        
        [_supView addSubview:self];
        
    } else if (style == ClearColorStyle) {
        self.tag = 9003;
        [_supView addSubview:self];
    }else { //无底色蓝色转圈样式
        
        CGFloat scale = 0.4;
        if (style == PartLoadWaitStyle) {
            scale = 0.5;
        }
        
        UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake((self.width - kAutoScale(55))/2, self.height*scale - kAutoScale(55)/2, kAutoScale(55), kAutoScale(55))];
        mainview.centerX = self.width/2;

        if(style != PartLoadWaitStyle && self.height == kScreenH - PCNaviBarHeight) {
            mainview.origin = CGPointMake((self.width - kAutoScale(55))/2, kScreenH*0.4 - kAutoScale(55)/2 - PCNaviBarHeight);
        }
        if (self.isRotate) {
            //旋转90度
            mainview.transform = CGAffineTransformRotate(mainview.transform, M_PI*0.5);
            mainview.center = CGPointMake(self.width/2, self.height/2);
        }
        [mainview setBackgroundColor:[UIColor clearColor]];
        
        self.WaitImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAutoScale(55), kAutoScale(55))];
        [self.WaitImgView setCenter:CGPointMake(mainview.width/2, mainview.height/2)];
        
        self.WaitImgView.animationImages = [CommonTool shareInstance].loadBlueImgArr;
        self.WaitImgView.animationDuration = 1;
        self.WaitImgView.animationRepeatCount = 0;
        [self.WaitImgView startAnimating];
        
        [mainview addSubview:self.WaitImgView];
        
        self.tag = 9001;
        [self addSubview:mainview];
        [_supView addSubview:self];
        
    }
}

-(void)show
{
     [_supView bringSubviewToFront:self];
}

-(void)hide{
    
    [self.WaitImgView stopAnimating];
    [self removeFromSuperview];
}

@end
