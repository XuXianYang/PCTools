//
//  UIViewController+animation.m
//  xzxyNativeTest
//
//  Created by 3304331246@qq.com  on 2018/3/26.
//  Copyright © 2018年 clong. All rights reserved.
//

#import "UIViewController+animation.h"

@implementation UIViewController (animation)

- (void)presentViewControllerWithAnimation:(UIViewController*)controller
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.4];
    [animation setType: kCATransitionPush];
    [animation setSubtype: kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self presentViewController:controller animated:NO completion:nil];
    [self.view.window.layer addAnimation:animation forKey:nil];
    
}
- (void)dismissViewControllerWithAnimation
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.4];
    [animation setType: kCATransitionPush];
    [animation setSubtype: kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.view.window.layer addAnimation:animation forKey:nil];
}

/**
 *  导航栏返回按钮
 */
-(void)addCustomBackButton
{
    //ios7+ 因为ios7以后leftBarButtonItem往右移了大概10px
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44,44);
    [leftBtn setImage:[UIImage imageNamed:@"cancleBtn"] forState:UIControlStateNormal];
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
    [leftBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    self.navigationItem.leftBarButtonItems = @[leftBarBtn];
}

-(void)addCustomBackButtonWithImage:(NSString*)imageName
{
    //ios7+ 因为ios7以后leftBarButtonItem往右移了大概10px
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44,44);
    [leftBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
    [leftBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    self.navigationItem.leftBarButtonItem=leftBarBtn;
}

-(void)goBackAction
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  删除返回按钮
 */
-(void)removeBackButton
{
	self.navigationItem.leftBarButtonItems = @[];
}
@end
