//
//  EUTGetDeviceModel.m
//  EUTTools
//
//  Created by apple on 2020/1/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTGetDeviceModel.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AddressBook/AddressBook.h>
#import <objc/runtime.h>
#import <mach/mach.h>
#include <sys/param.h>
#include <sys/mount.h>

#import <netinet/in.h>
#include <net/if.h>
#include <sys/socket.h>

//设备唯一号存取key值
#define kDeviceUniqueIdentifier @"kDeviceUniqueIdentifier"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation EUTGetDeviceModel
#pragma mark - 获取应用名称
+(NSString*)getAppName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return appName;
}
+(NSString *)platformName{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}
#pragma mark - 设备型号
+(NSString *)deviceModel{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]||
        [platform isEqualToString:@"iPhone3,2"]||
        [platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]||
        [platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]||
        [platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]||
        [platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]||
        [platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]||
        [platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7Plus";
    if ([platform isEqualToString:@"iPhone10,1"])  return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])  return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])  return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])  return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])  return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])  return @"iPhone X";
    //2018年10月发布：
    if ([platform isEqualToString:@"iPhone11,8"])  return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"])  return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])  return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])  return @"iPhone XS Max";
    if([platform isEqualToString:@"iPhone12,1"])  return @"iPhone 11";
    if([platform isEqualToString:@"iPhone12,3"])  return @"iPhone 11 Pro";
    if([platform isEqualToString:@"iPhone12,5"])  return @"iPhone 11 Pro Max";
    //iPod
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod touch 1";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod touch 2";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod touch 3";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod touch 4";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod touch 5";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod touch 6";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]||
        [platform isEqualToString:@"iPad2,2"]||
        [platform isEqualToString:@"iPad2,3"]||
        [platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"]||
        [platform isEqualToString:@"iPad2,6"]||
        [platform isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([platform isEqualToString:@"iPad3,1"]||
        [platform isEqualToString:@"iPad3,2"]||
        [platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"]||
        [platform isEqualToString:@"iPad3,5"]||
        [platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"]||
        [platform isEqualToString:@"iPad4,2"]||
        [platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"]||
        [platform isEqualToString:@"iPad4,5"]||
        [platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"]||
        [platform isEqualToString:@"iPad4,8"]||
        [platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad5,1"]||
        [platform isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,3"]||
        [platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"]||
        [platform isEqualToString:@"iPad6,4"]) return @"iPad Pro(9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"]||
        [platform isEqualToString:@"iPad6,8"]) return @"iPad Pro(12.9 inch)";
    if ([platform isEqualToString:@"iPad6,11"]||
        [platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,1"]||
        [platform isEqualToString:@"iPad7,2"]) return @"iPad Pro(12.9 inch)";
    if ([platform isEqualToString:@"iPad7,3"]||
        [platform isEqualToString:@"iPad7,4"]) return @"iPad Pro(10.5 inch)";
    //iOS Simulator
    if ([platform isEqualToString:@"i386"]||[platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return platform;
}
#pragma mark - 设备昵称
+(NSString *)deviceName{
    
    return [[UIDevice currentDevice] name];
}

#pragma mark - 设备系统平台

+(NSString *)systemPlatform{
    
    return [[UIDevice currentDevice] systemName];
}

#pragma mark - 设备系统版本

+(NSString *)systemVersion{
    
    return [[UIDevice currentDevice] systemVersion];
}
#pragma mark - 获取剩余电量
+(NSString*)getCurrentBatteryLevel{
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel;
    return [NSString stringWithFormat:@"%d%%",(int)(deviceLevel*100)];
}
//获取总运行内存
+ (NSString*)getTotalMemory {
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return [NSString stringWithFormat:@"%lldG",totalMemory/1024/1024/1024];
}
// 已使用的运行内存空间
+ (NSString*)getUsedMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return @"-1";
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return @"-1";
    
    int64_t sizeS = page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
            
    return [NSString stringWithFormat:@"%lldG",sizeS/1024/1024/1024];
}

//获取剩余存储空间
+ (NSString *)freeDiskSpaceInBytes{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    NSString *str = [NSString stringWithFormat:@"%0.2lld G",freeSpace/1024/1024/1024];
    
    return str;
}
+(void)usedSpaceAndfreeSpace{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    NSString *stttttt = [NSString stringWithFormat:@"已占用%0.1fG/剩余%0.1fG",([totalSpace longLongValue] - [freeSpace longLongValue])/1024.0/1024.0/1024.0,[freeSpace longLongValue]/1024.0/1024.0/1024.0];
    
    NSLog(@"stttttt = %@",stttttt);
}

- (float)getTotalDiskSpace{
    float totalsize = 0.0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
       NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
       totalsize = [_total unsignedLongLongValue]*1.0;
    } else
    {
       NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return totalsize;
}
//获取总存储空间
+ (NSString *)totalDiskSpaceInBytes{
    /// 总大小
    unsigned long long totalsize = 0.0;
    /// 剩余大小
    unsigned long long freesize = 0.0;
    /// 是否登录
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue];
        
        NSLog(@"剩余存储空间 === %@", [NSString stringWithFormat:@"%0.2lld G",freesize/1024/1024/1024]);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue];
    } else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    NSString *str = [NSString stringWithFormat:@"%0.2lld G",totalsize/1024/1024/1024];
    return str;
}
//获取国家
+(NSString*)getLocalCountry{
    NSLocale*locale = [NSLocale currentLocale];
    NSString*country = [locale localeIdentifier];
    return country;
}
//获取语言
+(NSString*)getLocalLanguage{
    //当前手机使用的语言数组
    NSArray*languageArray = [NSLocale preferredLanguages];
    NSString*language = [languageArray objectAtIndex:0];
    return language;
}
//获取当前时区
+(NSString*)getLocalZone{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    // 获取指定时区的名称
    NSString *strZoneName = [zone name];
    return strZoneName;
}
//获取本机电话号码
+(NSString*)getPhoneNum{
    NSString *num =  [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    if(!num||num.length==0)return @"";
    return num;
}
//判断是否是12小时制
+(BOOL)is12Hours{
    NSString*formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    
    NSRange containsA =[formatStringForHours rangeOfString:@"a"];
    //hasAMPM==TURE为12小时制，否则为24小时制
    BOOL hasAMPM =containsA.location != NSNotFound;
    return hasAMPM;
    
}

+(BOOL)isIpad{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        //该设备为手机
        return NO;
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return YES;
    }else{
        return NO;
    }
}

//获取运营商名称
+ (NSString *)deviceCarrierName{
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    //    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    
    if (mCarrier == nil || [mCarrier isEqualToString:@"(null)"]) {
        mCarrier = @"无";
    }
    return mCarrier;
}
//获取sim卡国家代码
+ (NSString *)mobileCountryCode
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier mobileCountryCode]];
    //    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    
    if (mCarrier == nil || [mCarrier isEqualToString:@"(null)"]) {
        mCarrier = @"";
    }
    return mCarrier;
}

//获取sim卡网络代码（标准）
+(NSString *)mobileNetworkCode
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier mobileNetworkCode]];
    //    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    
    if (mCarrier == nil || [mCarrier isEqualToString:@"(null)"]) {
        mCarrier = @"";
    }
    return mCarrier;
}

//ISO国家编码
+(NSString *)isoCountryCode
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier isoCountryCode]];
    //    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    
    if (mCarrier == nil || [mCarrier isEqualToString:@"(null)"]) {
        mCarrier = @"";
    }
    return mCarrier;
}
+ (NSString *)getNetworkIPAddress {
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //PCRequestIPStr = dict[@"cip"] ? dict[@"cip"] : @"";
        return dict[@"cip"] ? dict[@"cip"] : @"";
    }
    return @"";
}
//获取ip地址---- 仅限wifi环境下
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    return address;
}
//获取ip地址---- 任意环境下
+(NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ];
    
    NSDictionary *addresses = [self getIPAddresses];
    //    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         //         address = addresses[key];
         //         if(address) *stop = YES;
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            //NSRange resultRange = [firstMatch rangeAtIndex:0];
            //NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            //            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

//获取wifi信息
+ (NSDictionary *)SSIDInfo
{
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    
    NSDictionary *info = nil;
    
    for (NSString *ifnam in ifs) {
        
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            
            break;
            
        }
    }
    return info;
}
//获取总的存储空间
+(NSString *)getTotalSpace
{
    NSString *totalSpaceString;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    totalSpaceString = [NSString stringWithFormat:@"%0.1fG",[totalSpace longLongValue]/1024.0/1024.0/1024.0];
    return totalSpaceString;
    
}
//获取可用存储空间
+(NSString *)getFreeSpace
{
    NSString *freeSpaceString;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    //    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    freeSpaceString = [NSString stringWithFormat:@"%0.1fG",[freeSpace longLongValue]/1024.0/1024.0/1024.0];
    return freeSpaceString;
    
}
//osType
+ (NSString *)systemName{
    return [[UIDevice currentDevice] systemName];// e.g. @"iOS"
}


//获取WiFi 信息，返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
+(NSDictionary *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}
//网速测试
+(NSMutableDictionary *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    NSMutableDictionary *wifiDic = [[NSMutableDictionary alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            //            NSLog(@"ifa_name %s == %@n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    // NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    //NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    // NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                    //NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                    
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    NSLog(@"nwifiSend:%.2f MBn wifiReceived:%.2f MBn wwansend:%.2f MBn wwanreceived:%.2f MBn",WiFiSent/1024.0/1024.0,WiFiReceived/1024.0/1024.0,WWANSent/1024.0/1024.0,WWANReceived/1024.0/1024.0);
    [wifiDic setValue:[NSString stringWithFormat:@"%.f",(unsigned)WiFiSent/1024.0/1024.0] forKey:@"nwifiSend"];
    [wifiDic setValue:[NSString stringWithFormat:@"%.f",(unsigned)WiFiReceived/1024.0/1024.0] forKey:@"wifiReceived"];
    [wifiDic setValue:[NSString stringWithFormat:@"%.f",(unsigned)WWANSent/1024.0/1024.0] forKey:@"wwansend"];
    [wifiDic setValue:[NSString stringWithFormat:@"%.f",(unsigned)WWANReceived/1024.0/1024.0] forKey:@"wwanreceived"];
    return wifiDic;
}
@end
