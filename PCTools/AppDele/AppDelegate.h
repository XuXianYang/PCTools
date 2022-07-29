//
//  AppDelegate.h
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCBaseTabBarController.h"
#import "PCBaseNavigationController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PCBaseNavigationController *baseNav;
@property (strong, nonatomic) PCBaseTabBarController *baseTabBar;
-(void)startApp;
@end

