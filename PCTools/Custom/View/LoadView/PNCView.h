//
//  PNCView.h
//  PNCLibrary
//
//  Created by 张瑞 on 14-7-28.
//  Copyright (c) 2014年 张瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	@brief  View基类, 默认无背景色.
 */
@interface PNCView : UIView{
    @private
    id _userinfo;
    UIEdgeInsets _inset;
}
@property (weak, nonatomic) UIView *receiver;
/**
 *	@brief	自定义数据.
 */
@property (nonatomic, strong) id userinfo;

/**
 *	@brief  内填充 ,默认UIEdgeInsetsZero.
 */
@property (nonatomic, assign) UIEdgeInsets inset;


@end
