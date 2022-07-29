//
//  NSString+Handle.m
//  BankOfCommunications
//
//  Created by zhaoyang on 2018/1/10.
//  Copyright © 2018年 P&C Information. All rights reserved.
//

#import "NSString+Handle.h"

@implementation NSString (Handle)

//是否包含对应字符
- (BOOL)isContainStr:(NSString *)subString {
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}
#pragma mark - 数字金额转大写
//数字金额转大写方法1
-(NSString *)toCapitalLetters{
    //首先转化成标准格式        “200.23”
    NSMutableString *tempStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[self doubleValue]]];
    //位
    NSArray *carryArr1=@[@"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *carryArr2=@[@"分",@"角"];
    //数字
    NSArray *numArr=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSArray *temarr = [tempStr componentsSeparatedByString:@"."];
    //小数点前的数值字符串
    NSString *firstStr=[NSString stringWithFormat:@"%@",temarr[0]];
    //小数点后的数值字符串
    NSString *secondStr=[NSString stringWithFormat:@"%@",temarr[1]];
    
    //是否拼接了“零”，做标记
    bool zero=NO;
    //拼接数据的可变字符串
    NSMutableString *endStr=[[NSMutableString alloc] init];
    /**
     *  首先遍历firstStr，从最高位往个位遍历    高位----->个位
     */
    for(int i=(int)firstStr.length;i>0;i--){
        //取最高位数
        NSInteger MyData=[[firstStr substringWithRange:NSMakeRange(firstStr.length-i, 1)] integerValue];
        
        if ([numArr[MyData] isEqualToString:@"零"]) {
            
            if ([carryArr1[i-1] isEqualToString:@"万"]||[carryArr1[i-1] isEqualToString:@"亿"]||[carryArr1[i-1] isEqualToString:@"元"]||[carryArr1[i-1] isEqualToString:@"兆"]) {
                //去除有“零万”
                if (zero) {
                    endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:(endStr.length-1)]];
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }else{
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }
                
                //去除有“亿万”、"兆万"的情况
                if ([carryArr1[i-1] isEqualToString:@"万"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"亿"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                }
                //去除“兆亿”
                if ([carryArr1[i-1] isEqualToString:@"亿"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                }
            }else{
                if (!zero) {
                    [endStr appendString:numArr[MyData]];
                    zero=YES;
                }
            }
        }else{
            //拼接数字
            [endStr appendString:numArr[MyData]];
            //拼接位
            [endStr appendString:carryArr1[i-1]];
            //不为“零”
            zero=NO;
        }
    }
    /**
     *  再遍历secondStr    角位----->分位
     */
    if ([secondStr isEqualToString:@"00"]) {
        [endStr appendString:@"整"];
    }else{
        for(int i=(int)secondStr.length;i>0;i--){
            //取最高位数
            NSInteger MyData=[[secondStr substringWithRange:NSMakeRange(secondStr.length-i, 1)] integerValue];
            
            [endStr appendString:numArr[MyData]];
            [endStr appendString:carryArr2[i-1]];
        }
    }
    return endStr;
}
//数字金额转大写方法2
-(NSString *)getCnMoneyByString{
    NSString *string = [NSString stringWithFormat:@"%.2f",[self floatValue]];
    // 设置数据格式
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    // NSLocale的意义是将货币信息、标点符号、书写顺序等进行包装，如果app仅用于中国区应用，为了保证当用户修改语言环境时app显示语言一致，则需要设置NSLocal（不常用）
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 全拼格式
    [numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
    // 小数点后最少位数
    [numberFormatter setMinimumFractionDigits:2];
    // 小数点后最多位数
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[string doubleValue]]];
    //通过NSNumberFormatter转换为大写的数字格式 eg:一千二百三十四
    //替换大写数字转为金额
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"一" withString:@"壹"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"二" withString:@"贰"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"三" withString:@"叁"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"四" withString:@"肆"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"五" withString:@"伍"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"六" withString:@"陆"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"七" withString:@"柒"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"八" withString:@"捌"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"九" withString:@"玖"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"〇" withString:@"零"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"千" withString:@"仟"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"百" withString:@"佰"];
    formattedNumberString = [formattedNumberString stringByReplacingOccurrencesOfString:@"十" withString:@"拾"];
    
    // 对小数点后部分单独处理
    // rangeOfString 前面的参数是要被搜索的字符串，后面的是要搜索的字符
    if ([formattedNumberString rangeOfString:@"点"].length>0){
        // 将“点”分割的字符串转换成数组，这个数组有两个元素，分别是小数点前和小数点后
        NSArray* arr = [formattedNumberString componentsSeparatedByString:@"点"];
        // 如果对一不可变对象复制，copy是指针复制（浅拷贝）和mutableCopy就是对象复制（深拷贝）。如果是对可变对象复制，都是深拷贝，但是copy返回的对象是不可变的。
        
        // 这里指的是深拷贝
        NSMutableString* lastStr = [[arr lastObject] mutableCopy];
        //NSLog(@"---%@---长度%ld", lastStr, lastStr.length);
        if (lastStr.length>=2){
            // 在最后加上“分”
            [lastStr insertString:@"分" atIndex:lastStr.length];
        }
        
        if (![[lastStr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"零"]){
            // 在小数点后第一位后边加上“角”
            [lastStr insertString:@"角" atIndex:1];
        }
        // 在小数点左边加上“元”
        formattedNumberString = [[arr firstObject] stringByAppendingFormat:@"元%@",lastStr];
    }else // 如果没有小数点
    {
        formattedNumberString = [formattedNumberString stringByAppendingString:@"元"];
    }
    return formattedNumberString;
}
@end
