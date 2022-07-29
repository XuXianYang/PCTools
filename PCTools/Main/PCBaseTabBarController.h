//
//  PCBaseTabBarController.h
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCCustomTabBar.h"

@interface PCBaseTabBarController : UITabBarController
{
    PCCustomTabBar* customTabBar;
}
- (void)selectItemAtIndex:(NSInteger)index;

@end
