//
//  CityVC.h
//  WagesCalculator
//
//  Created by 鸿朔 on 2017/12/18.
//  Copyright © 2017年 鸿朔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedCityBlock)(NSString *city,NSString *pinyin);

@interface PCCityVC : PCBaseViewController

//传值
@property (nonatomic, copy) SelectedCityBlock selectedCityBlock;

@end
