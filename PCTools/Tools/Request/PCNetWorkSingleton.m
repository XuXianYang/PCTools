//
//  NetWorkSingleton.m
//  OTwoONative
//
//  Created by 鸿朔 on 2018/9/26.
//  Copyright © 2018年 huoshuo. All rights reserved.
//

#import "PCNetWorkSingleton.h"
#import "AFNetworking.h"
@implementation PCNetWorkSingleton

+(AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.operationQueue.maxConcurrentOperationCount = 5;//最大并发请求数量
        manager.requestSerializer.timeoutInterval = 30.f;//超时
        //设置返回值类型
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml",@"application/xml",@"application/json", @"text/json",@"text/html", @"text/plain",@"application/x-javascript",nil];
        [manager.requestSerializer setValue:@"application/json,charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"gzip,deflate,br" forHTTPHeaderField:@"Accept-Encoding"];
    });
    return manager;
}

@end
