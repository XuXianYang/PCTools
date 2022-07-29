//
//  BCMCacheManger.h
//  BankOfCommunications
//
//  Created by konghao on 2017/11/7.
//  Copyright © 2017年 P&C Information. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCMCacheManger : NSObject

singleton_interface(BCMCacheManger);

// 松手刷新循环
@property (nonatomic, strong) NSArray * mjPulling2Array;

// 松手刷新状态
@property (nonatomic, strong) NSArray * mjPullingArray;

// mj header
@property (nonatomic, strong) NSArray * mjHeaderArray;
// mj footer
@property (nonatomic, strong) NSArray * mjFooterArray;
// 下啦 数组
@property (nonatomic, strong) NSArray * mjDragArray;
// 刷新 数组
@property (nonatomic, strong) NSArray * refreshBlueLoadingArray;

@property (nonatomic, strong) NSArray * refreshWhiteLoadingArray;


@end
