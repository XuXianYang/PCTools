//
//  PCURLConfig.h
//  HXQYBank
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 Alibaba. All rights reserved.
//

//热更新版本号
extern NSString * const PCApp_Version;

//BaseUrl
extern NSString * const PCBaseUrl;
//天天壁纸
extern NSString * const PCWallpaperUrl;
//查询车次
extern NSString * const PCQueryStationUrl;
//查询手机号吉凶
extern NSString * const PCLuckyByMobileUrl;
//周公解梦
extern NSString * const PCQueryDreamUrl;
//今日禁忌
extern NSString * const PCQueryCalendarUrl;
//文字识别
extern NSString * const PCTextIdentifyUrl;
//我的位置
extern NSString * const PCMyLocationUrl;
//IP查询
extern NSString * const EUTQueryIPUrl;
//手机号归属地查询
extern NSString * const EUTQueryMoboleNumUrl;
//垃圾分类查询
extern NSString * const EUTQueryLJFLUrl;
//票据识别
extern NSString * const EUTTicketIdentifyUrl;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCURLConfig : NSObject

@end

NS_ASSUME_NONNULL_END
