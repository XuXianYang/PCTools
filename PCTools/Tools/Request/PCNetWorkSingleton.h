//
//  NetWorkSingleton.h
//  OTwoONative
//
//  Created by 鸿朔 on 2018/9/26.
//  Copyright © 2018年 huoshuo. All rights reserved.
//

#import "AFNetworking.h"
@interface PCNetWorkSingleton : AFHTTPSessionManager

+(AFHTTPSessionManager *)shareManager;

@end
