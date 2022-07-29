//
//  NSString+Handle.h
//  BankOfCommunications
//
//  Created by zhaoyang on 2018/1/10.
//  Copyright © 2018年 P&C Information. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 字符串处理 */
@interface NSString (Handle)
//是否包含对应字符
- (BOOL)isContainStr:(NSString *)subString;
//数字金额转大写方法1
-(NSString *)toCapitalLetters;
//数字金额转大写方法2
-(NSString *)getCnMoneyByString;

@end
