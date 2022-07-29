//
//  UILabel+ChangeLineSpaceAndWordSpace.h
//  xzxyNativeTest
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018年 clong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChangeLineSpaceAndWordSpace)
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;
//计算高度
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

//给文字加阴影
-(void)addTextShadowColor:(UIColor*)color and:(CGFloat)blurRadius andSize:(CGSize)size andText:(NSString*)text;
@end
