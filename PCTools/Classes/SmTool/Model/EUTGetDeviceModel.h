//
//  EUTGetDeviceModel.h
//  EUTTools
//
//  Created by apple on 2020/1/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface EUTGetDeviceModel : NSObject
//获取应用名称
+(NSString*)getAppName;
//获取设备型号
+(NSString *)deviceModel;
+(NSString *)platformName;
//获取设备名称
+(NSString *)deviceName;
//获取系统名称
+ (NSString *)systemName;//osType, e.g. @"iOS"
//获取设备系统平台
+(NSString *)systemPlatform;

//获取设备系统版本
+(NSString *)systemVersion;

//获取剩余电量
+(NSString*)getCurrentBatteryLevel;
//获取总内存
+(NSString*)getTotalMemory;
//获取已用内存
+(NSString*)getUsedMemory;
//获取剩余存储空间
+ (NSString *)freeDiskSpaceInBytes;
//获取总存储空间
+ (NSString *)totalDiskSpaceInBytes;


//获取国家
+(NSString*)getLocalCountry;
//获取语言
+(NSString*)getLocalLanguage;
//获取当前时区
+(NSString*)getLocalZone;
//获取本机电话号码
+(NSString*)getPhoneNum;
//判断是否是12小时制
+(BOOL)is12Hours;
+(BOOL)isIpad;

//获取运营商名称
+ (NSString *)deviceCarrierName;
//获取sim卡国家代码
+ (NSString *)mobileCountryCode;
//获取sim卡网络代码（标准）
+(NSString *)mobileNetworkCode;
//ISO国家编码
+(NSString *)isoCountryCode;
//获取ip地址---仅wifi下
+ (NSString *)deviceIPAdress;
//获取ip地址
+(NSString *)getIPAddress:(BOOL)preferIPv4;
//获取wifi基本信息
+ (NSDictionary *)SSIDInfo;
//获取手机总存储空间
+(NSString *)getTotalSpace;
//获取手机可用存储空间
+(NSString *)getFreeSpace;

//获取WiFi 信息，返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
+(NSDictionary *)fetchSSIDInfo;
//网速测试
+(NSMutableDictionary *)getDataCounters;

+ (NSString *)getNetworkIPAddress;

@end

NS_ASSUME_NONNULL_END
