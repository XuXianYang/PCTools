//
//  UIViewController+animation.h
//  xzxyNativeTest
//
//  Created by 3304331246@qq.com  on 2018/3/26.
//  Copyright © 2018年 clong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (animation)
/**
 @brief 模态跳转的动画改为和push一样的
 **/
- (void)presentViewControllerWithAnimation:(UIViewController*)controller;
- (void)dismissViewControllerWithAnimation;
//导航栏左侧返回按钮
-(void)addCustomBackButton;
-(void)addCustomBackButtonWithImage:(NSString*)imageName;

//导航返回按钮点击事件:特殊情况可以重写
-(void)goBackAction;
//删除导航栏左侧按钮
-(void)removeBackButton;

@end
