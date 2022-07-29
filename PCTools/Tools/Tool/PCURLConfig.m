//
//  PCURLConfig.m
//  HXQYBank
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 Alibaba. All rights reserved.
//

//热更新版本号
NSString * const PCApp_Version = @"20191224";


//BaseUrl
NSString * const PCBaseUrl = @"http://zs.5988cai.com";
//天天壁纸
NSString * const PCWallpaperUrl = @"search/getImg?goods=壁纸";
//查询车次
NSString * const PCQueryStationUrl = @"search/getByStationToStation";
//查询手机号吉凶
NSString * const PCLuckyByMobileUrl = @"search/getLuckyByMobile";
//周公解梦
NSString * const PCQueryDreamUrl = @"search/getDream";
//今日禁忌
NSString * const PCQueryCalendarUrl = @"search/getCalendar";
//文字识别
NSString * const PCTextIdentifyUrl = @"search/getDentifierByImgData";
//我的位置
NSString * const PCMyLocationUrl = @"search/getGeocoder";
//IP查询
NSString * const EUTQueryIPUrl = @"search/getiP";
//手机号归属地查询
NSString * const EUTQueryMoboleNumUrl = @"search/getMobile";
//垃圾分类查询
NSString * const EUTQueryLJFLUrl = @"search/getCategoryByGoods";
//票据识别
NSString * const EUTTicketIdentifyUrl = @"search/getReceiptImg";

#import "PCURLConfig.h"
@implementation PCURLConfig
@end


