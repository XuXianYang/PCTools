//
//  PCCustomTabBar.h
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PCCustomTabBarDelegate<NSObject>

@optional
-(void)tabBarButtonRepeatCliked:(NSInteger)index;

-(void)tabBarButtonCliked:(NSInteger)index;

@end
@interface PCCustomTabBar : UIView

@property(nonatomic,weak)id<PCCustomTabBarDelegate>delegate;

@property(nonatomic, strong) NSMutableArray *buttonArray;
@property(nonatomic, strong) NSMutableArray *selectButtonArray;


-(void)selectedItems:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
