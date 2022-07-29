//
//  RequestTool.m
//  OTwoONative
//
//  Created by 鸿朔 on 2018/9/26.
//  Copyright © 2018年 huoshuo. All rights reserved.
//

#import "PCRequestTool.h"
@interface PCRequestTool()

@end

@implementation PCRequestTool
static PCRequestTool * _requestTool = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _requestTool = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _requestTool ;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [PCRequestTool shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [PCRequestTool shareInstance] ;
}
-(void)PostWithUrl:(NSString *)url parm:(NSDictionary *)parm successCallBack:(requestSuccess)postRequestSuccess FailCallBack:(requestFail)postRequestFail{
   
    //url和参数再这里进行封装或者拼接
    if (url == nil) {
        return;
    }
    url = [NSString stringWithFormat:@"%@/%@",PCBaseUrl,url];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //请求数据
    AFHTTPSessionManager * manager = [PCNetWorkSingleton shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //NSLog(@"POST:%@",url);
    
    [manager POST:url parameters:parm progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        postRequestSuccess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        postRequestFail(error);
    }];
}

-(void)GetWithUrl:(NSString *)url parm:(NSDictionary *)parm successCallBack:(requestSuccess)postRequestSuccess FailCallBack:(requestFail)postRequestFail{
    
    //url和参数再这里进行封装或者拼接
    if (url == nil) {
        return;
    }
    
    url = [NSString stringWithFormat:@"%@/%@",PCBaseUrl,url];
   url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //请求数据
    AFHTTPSessionManager * manager = [PCNetWorkSingleton shareManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:url parameters:parm progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        postRequestSuccess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        postRequestFail(error);
    }];
}

+ (void)getAllUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if(url == nil) return;
    
    NSMutableDictionary *addParamsDict;
    addParamsDict = [NSMutableDictionary dictionaryWithDictionary:params];
    url = [NSString stringWithFormat:@"%@/%@",PCBaseUrl,url];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
#ifdef DEBUG
    NSMutableString * urlParamString = [NSMutableString stringWithFormat:@"%@?",url];
    [addParamsDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [urlParamString appendFormat:@"%@=%@&",key,obj];
    }];
    if ([urlParamString hasSuffix:@"&"]||[urlParamString hasSuffix:@"?"])
    {
        [urlParamString deleteCharactersInRange:NSMakeRange(urlParamString.length-1, 1)];
    }
    NSLog(@"post ---- %@", urlParamString);
#endif
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObjects:@"text/xml",@"application/xml",@"application/json", @"text/json",@"text/html", @"text/plain",@"application/x-javascript",nil];
    if (set != nil && [set isKindOfClass:[NSSet class]])
    {
        manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = set;
    }
    NSLog(@"urlurlurl==%@,%@",url,params);
    
    [manager GET:url parameters:addParamsDict progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success) {
            if ([responseObject isKindOfClass:[NSData class]]){
                id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                success(response);
            }else{
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
+ (void)postAllUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if(url == nil) return;
    
    NSMutableDictionary *addParamsDict;
    addParamsDict = [NSMutableDictionary dictionaryWithDictionary:params];
   
    url = [NSString stringWithFormat:@"%@/%@",PCBaseUrl,url];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //    [RequestTool getUrl:url addParamsDict:addParamsDict];
#ifdef DEBUG
    NSMutableString * urlParamString = [NSMutableString stringWithFormat:@"%@?",url];
    [addParamsDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [urlParamString appendFormat:@"%@=%@&",key,obj];
    }];
    if ([urlParamString hasSuffix:@"&"]||[urlParamString hasSuffix:@"?"])
    {
        [urlParamString deleteCharactersInRange:NSMakeRange(urlParamString.length-1, 1)];
    }
    NSLog(@"post ---- %@", urlParamString);
#endif
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObjects:@"text/xml",@"application/xml",@"application/json", @"text/json",@"text/html", @"text/plain",@"application/x-javascript",nil];
    if (set != nil && [set isKindOfClass:[NSSet class]])
    {
        manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = set;
    }
    [manager POST:url parameters:addParamsDict progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            if ([responseObject isKindOfClass:[NSData class]]){
                id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                success(response);
            }else{
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
/**
 *  获取接口连接
 */
-(void)getUrl:(NSString *)url addParamsDict:(NSDictionary *)addParamsDict
{
#ifdef DEBUG
    NSMutableString * urlParamString = [NSMutableString stringWithFormat:@"%@?",url];
    [addParamsDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [urlParamString appendFormat:@"%@=%@&",key,obj];
    }];
    if ([urlParamString hasSuffix:@"&"]||[urlParamString hasSuffix:@"?"])
    {
        [urlParamString deleteCharactersInRange:NSMakeRange(urlParamString.length-1, 1)];
    }
    NSLog(@"post ---- %@", urlParamString);
#endif
}

-(void)CheckNetWorkStatus:(netWorkStatus)netWorkStatus
{
    //网络监控句柄
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //status:
        //AFNetworkReachabilityStatusUnknown          = -1,  未知
        //AFNetworkReachabilityStatusNotReachable     = 0,   未连接
        //AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
        //AFNetworkReachabilityStatusReachableViaWiFi = 2,   无线连接
        netWorkStatus(status);
    }];
}



@end
