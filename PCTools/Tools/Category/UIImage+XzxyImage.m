//
//  UIImage+XzxyImage.m
//  xzxyNativeTest
//
//  Created by apple on 2018/7/21.
//  Copyright © 2018年 clong. All rights reserved.
//

#import "UIImage+XzxyImage.h"

@implementation UIImage (XzxyImage)
// 颜色转为图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 开启上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(ref, color.CGColor);
    // 渲染上下文
    CGContextFillRect(ref, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)dc_stretchLeftAndRightWithContainerSize:(CGSize)imageViewSize
{
    CGSize imageSize = self.size;
    CGSize bgSize = CGSizeMake(floorf(imageViewSize.width), floorf(imageViewSize.height)); //imageView的宽高取整，否则会出现横竖两条缝
    UIImage *image = [self stretchableImageWithLeftCapWidth:imageSize.width *0.8 topCapHeight:imageSize.height * 0.5];
    CGFloat tempWidth = (bgSize.width)/2 + (imageSize.width)/2;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, bgSize.height), NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, tempWidth, bgSize.height)];
    
    UIImage *firstStrechImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *secondStrechImage = [firstStrechImage stretchableImageWithLeftCapWidth:imageSize.width *0.2 topCapHeight:imageSize.height*0.5];
    return secondStrechImage;
}
- (UIImage *)drawCircleImage:(CGRect) rect andRadius:(CGFloat)radius{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}
@end
