//
//  CommonTool.m
//  OTwoONative
//
//  Created by 鸿朔 on 2018/9/26.
//  Copyright © 2018年 huoshuo. All rights reserved.
//

#import "CommonTool.h"
#import "AppDelegate.h"
#import <CoreTelephony/CTCellularData.h>
#import "BCMCacheManger.h"
@implementation CommonTool
static CommonTool * _commonTool = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _commonTool = [[super allocWithZone:NULL] init] ;
    }) ;
    return _commonTool ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [CommonTool shareInstance] ;
}
-(id) copyWithZone:(struct _NSZone *)zone
{
    return [CommonTool shareInstance] ;
}
//获取跟视图控制器
-(UINavigationController *)getMainController {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return  (UINavigationController *)appDelegate.window.rootViewController;
}

//获取view的父视图控制器
- (UIViewController *)getViewControllerWithView:(UIView *)view {
    while ((view = [view superview])) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
//获取当前显示的ViewController
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    if ([window subviews].count>0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }
        else{
            result = window.rootViewController;
        }
    }
    else{
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [((UITabBarController*)result) selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) visibleViewController];
    }
    return result;
}
//通过16进制获取color
- (UIColor *) stringTOColor:(NSString *)str {
    if (!str || [str isEqualToString:@""]||str.length!=7) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    
    return color;
}

//计算单行文本的size
-(CGSize)calculateSingleLineTextWidth:(NSString*)text Font:(CGFloat)font
{
    CGSize size =[text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    return size;
}
//计算多行文本的高
-(CGFloat)calculateMoreLineTextHeight:(NSString*)text Font:(CGFloat)font Wtdth:(CGFloat)width
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.height;
}
//获取不同屏幕尺寸文字的大小
-(CGFloat)getMetabolicFontFormScreen:(CGFloat)Five :(CGFloat)Six :(CGFloat)P :(CGFloat)X
{
    if(kScreenH==568)
    {
        return Five;
    }else if (kScreenH==667)
    {
        return Six;
    }
    else if (kScreenH==736)
    {
        return P;
    }
    else if (kScreenH>=812)
    {
        return X;
    }
    return Five;
}

//弹框 确认取消按钮
-(void)showAlertTitle:(NSString*)title sureBtnTitle:(NSString *)sureBtnTitle WithSureBlock:(void (^)(void))sureBlock
{
    UIAlertController*alertConntroller = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    [alertConntroller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertConntroller addAction:[UIAlertAction actionWithTitle:sureBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sureBlock) {
            sureBlock();
        }
    }]];
    
    UIViewController * currentVC = [[CommonTool shareInstance] getCurrentVC];
    [currentVC presentViewController:alertConntroller animated:YES completion:^{
    }];
}

//弹框 我知道了按钮
-(void)showAlertMessage:(NSString*)message
{
    UIAlertController*alertConntroller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertConntroller addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    UIViewController * currentVC = [[CommonTool shareInstance] getCurrentVC];
    [currentVC presentViewController:alertConntroller animated:YES completion:^{
    }];
}

-(void)showAlert:(NSString*)title :(NSString*)btnTitle
{
    UIAlertController*alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertCon addAction:action1];
    
    UIViewController * currentVC = [[CommonTool shareInstance] getCurrentVC];
    [currentVC presentViewController:alertCon animated:YES completion:^{
    }];
}


- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth
{
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(void)toastMessage:(NSString *)message{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView *tempToastView =[window viewWithTag:2017888999];
    if (tempToastView) {
        [tempToastView removeFromSuperview];
        tempToastView =nil;
    }
    UIFont *contentFont =[UIFont systemFontOfSize:14];
    CGSize mainSize =[[UIScreen mainScreen] bounds].size;
    
    CGSize contentSize =[message boundingRectWithSize:CGSizeMake(mainSize.width-60, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentFont} context:nil].size;
    CGRect frame =CGRectMake((mainSize.width-contentSize.width-20)/2, (mainSize.height-contentSize.height)/2, contentSize.width+20, contentSize.height+20);
    
    UIView *baseView =[[UIView alloc]initWithFrame:frame];
    baseView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.9];
    baseView.tag =2017888999;
    baseView.layer.cornerRadius =5.0f;
    [window addSubview:baseView];
    
    UILabel *textLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, contentSize.width, contentSize.height)];
    textLabel.font =contentFont;
    textLabel.text =message;
    textLabel.numberOfLines =0;
    textLabel.textColor =[UIColor whiteColor];
    textLabel.textAlignment =NSTextAlignmentCenter;
    [baseView addSubview:textLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            baseView.alpha=0.2;
        } completion:^(BOOL finished) {
            [baseView removeFromSuperview];
        }];
    });
}

// 蓝色Loading图片
- (NSArray *)loadBlueImgArr {
    
    if (!_loadBlueImgArr) {
        _loadBlueImgArr = [BCMCacheManger shared].refreshBlueLoadingArray;
    }
    return _loadBlueImgArr;
}

// 白色Loading图片
- (NSArray *)loadWhiteImgArr {
    if (!_loadWhiteImgArr) {
        _loadWhiteImgArr = [BCMCacheManger shared].refreshWhiteLoadingArray;
    }
    return _loadWhiteImgArr;
}
+(NSString *)safeString:(NSString *)string{
    
    if(!string||[string isKindOfClass:[NSNull class]]){
        return @"";
    }
    NSString *strResult =@"";
    if (string) {
        if ([string isKindOfClass:NSString.class]) {
            strResult =string;
        }else{
            strResult =[NSString stringWithFormat:@"%@",string];
        }
    }
    return strResult;
}
//YYYY-MM-dd HH:mm:ss
+(NSString*)getCurrentTimesWithFormatter:(NSString*)formatterStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:formatterStr];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}
+ (BOOL)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(17[0-9])|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3){
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
//            NSRange resultRange = [firstMatch rangeAtIndex:0];
//            NSString *result=[ipAddress substringWithRange:resultRange];
//            //输出结果
//            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
//获取指定格式的时间戳
+(NSString*)getTimeStr:(NSString*)dateStr andFormatter:(NSString*)formatter{
    NSDateFormatter *nextformatter = [[NSDateFormatter alloc] init] ;
    [nextformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[nextformatter dateFromString:dateStr];
    [nextformatter setDateFormat:formatter];
    return [nextformatter stringFromDate:date];
}
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    //NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
    
}

/*
 n天以前是什么日期,返回时间戳字符串
 */
+(NSString*)computationDaysAgo:(NSInteger)days withType:(NSInteger)type
{
    NSDate *currentDate =[NSDate date];
    NSDate *appointDate; // 指定日期声明
    if(days!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天长度
        appointDate = [currentDate initWithTimeIntervalSinceNow: -oneDay *days];
    }else {appointDate = currentDate;}
    //转字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    switch (type) {
        case 0:
        {
            [formatter setDateFormat:@"yyyy-MM-dd"];
        }
            break;
        case 1:
        {
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
            break;
    }
    NSString *dateStr = [formatter stringFromDate:appointDate];
    return dateStr;
}

//获取当前时间若干年、月、日之后的时间
+ (NSDate *)dateWithFromDate:(NSDate *)date years:(NSInteger)years months:(NSInteger)months days:(NSInteger)days{
    NSDate  * latterDate;
    if (date) {
        latterDate = date;
    }else{
        latterDate = [NSDate date];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                          fromDate:latterDate];
    [comps setYear:years];
    [comps setMonth:months];
    [comps setDay:days];
    
    return [calendar dateByAddingComponents:comps toDate:latterDate options:0];
}
/**
  * @method
  *
  * @brief 获取两个日期之间的天数
  * @param fromDate       起始日期
  * @param toDate         终止日期
  * @return    总天数
  */
//获取两个日期之间的天数
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate
                                               toDate:toDate options:NSCalendarWrapComponents];
    return comp.day;
}


@end
