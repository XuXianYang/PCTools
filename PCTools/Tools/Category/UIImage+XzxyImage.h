//
//  UIImage+XzxyImage.h
//  xzxyNativeTest
//
//  Created by apple on 2018/7/21.
//  Copyright © 2018年 clong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XzxyImage)
// 颜色转为图片
+ (UIImage *)imageWithColor:(UIColor *)color;
//两边拉伸图片
- (UIImage *)dc_stretchLeftAndRightWithContainerSize:(CGSize)imageViewSize;
//给图片绘制圆角
- (UIImage *)drawCircleImage:(CGRect) rect andRadius:(CGFloat)radius;
@end
