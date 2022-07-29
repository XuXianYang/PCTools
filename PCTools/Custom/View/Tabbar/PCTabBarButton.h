//
//  PCTabBarButton.h
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCTabBarButton : UIButton
@property(nonatomic,strong)UIImageView*btnImageView;

@property(nonatomic,strong)UILabel*btnTitleLabel;

@property(nonatomic, assign)BOOL isSelected;//是否选中状态
@property(nonatomic, copy)NSString* defaultImage;//未选中状态图片
@property(nonatomic, strong)UIColor* defaultTextColor;//未选中状态文字颜色
@property(nonatomic, copy)NSString* selectedImage;//选中状态图片
@property(nonatomic, strong)UIColor* selectedTextColor;//选中状态文字颜色
@property(nonatomic, copy)NSString* defaultText;//标题

@property(nonatomic, assign)BOOL isHiddenText;//是否隐藏文字
@end

NS_ASSUME_NONNULL_END
