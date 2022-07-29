//
//  RequestTool.h
//  OTwoONative
//
//  Created by 鸿朔 on 2018/9/26.
//  Copyright © 2018年 huoshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCNetWorkSingleton.h"

typedef void(^requestSuccess)(id successData);
typedef void(^requestFail)(id FailData);

typedef void(^netWorkStatus)(NSInteger status);


typedef void(^requestFail)(id FailData);

@interface PCRequestTool : NSObject

+(instancetype)shareInstance;

-(void)PostWithUrl:(NSString *)url parm:(NSDictionary *)parm successCallBack:(requestSuccess)postRequestSuccess FailCallBack:(requestFail)postRequestFail;

-(void)GetWithUrl:(NSString *)url parm:(NSDictionary *)parm successCallBack:(requestSuccess)postRequestSuccess FailCallBack:(requestFail)postRequestFail;

+ (void)getAllUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)postAllUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//检查网络状态: -1:未知 , 0:未连接 , 1: 3G , 2:无线连接
-(void)CheckNetWorkStatus:(netWorkStatus)netWorkStatus;


@end
