//
//  CommonTool.h
//  OTwoONative
//
//  Created by 鸿朔 on 2018/9/26.
//  Copyright © 2018年 huoshuo. All rights reserved.
//

//调用比较频繁的工具类

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

+(instancetype)shareInstance;

//等待层图片
@property(strong, nonatomic)NSArray *loadBlueImgArr;
@property (nonatomic, strong) NSArray *loadWhiteImgArr;

/**
 @brief 返回最底层的控制器,是一个UINavigationController
 用于一级页面push跳转二级页面,其他页面的push跳转用self.navigationController即可
 **/
-(UINavigationController *)getMainController;
/**
 @brief 通过view获取该view的父视图控制器
 **/
- (UIViewController *)getViewControllerWithView:(UIView *)view ;

//获取当前显示的ViewController
- (UIViewController *)getCurrentVC;
//通过16进制获取color 传入的字符串必须是 #F34799 格式的
- (UIColor *) stringTOColor:(NSString *)str;
//计算单行文本的size
-(CGSize)calculateSingleLineTextWidth:(NSString*)text Font:(CGFloat)font;
//计算多行文本的高
-(CGFloat)calculateMoreLineTextHeight:(NSString*)text Font:(CGFloat)font Wtdth:(CGFloat)width;
//获取不同屏幕尺寸文字的大小
-(CGFloat)getMetabolicFontFormScreen:(CGFloat)Five :(CGFloat)Six :(CGFloat)P :(CGFloat)X;
//显示弹框
-(void)showAlert:(NSString*)title :(NSString*)btnTitle;
-(void)showAlertTitle:(NSString*)title sureBtnTitle:(NSString *)sureBtnTitle WithSureBlock:(void (^)(void))sureBlock;
-(void)showAlertMessage:(NSString*)message;
- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

+(void)toastMessage:(NSString *)message;

+(nonnull NSString *)safeString:(nullable NSString *)string;
+(nonnull NSString *)getCurrentTimesWithFormatter:(nullable NSString *)formatterStr;
//判断是否是电话号码
+ (BOOL)valiMobile:(nullable NSString *)mobile;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

//当前日期的时间戳
+(nonnull NSString*)getCurrentTimesWithFormatter:(nullable NSString*)formatterStr;

//获取指定格式的时间戳
+(nonnull NSString*)getTimeStr:(nullable NSString*)dateStr andFormatter:(nullable NSString*)formatter;
+(nonnull NSString*)getCurrentTimes;
/*
 n天以前是什么日期,返回时间戳字符串
 */
+(nonnull NSString*)computationDaysAgo:(NSInteger)days withType:(NSInteger)type;

//获取当前时间若干年、月、日之后的时间
+ (nonnull NSDate *)dateWithFromDate:(nullable NSDate *)date years:(NSInteger)years months:(NSInteger)months days:(NSInteger)days;
+ (NSInteger)numberOfDaysWithFromDate:(nullable NSDate *)fromDate toDate:(nullable NSDate *)toDate;
@end
