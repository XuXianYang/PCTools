//
//  Plugin_SDK_iOS.h
//  Plugin_SDK_iOS
//
//  Created by he on 2018/11/22.
//  Copyright © 2018 HeFengTianQi. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Plugin_SDK_iOS.
FOUNDATION_EXPORT double Plugin_SDK_iOSVersionNumber;

//! Project version string for Plugin_SDK_iOS.
FOUNDATION_EXPORT const unsigned char Plugin_SDK_iOSVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Plugin_SDK_iOS/PublicHeader.h>
/* 当前版本 2018-11-22 2.0.0 */

/*
 1.请将frameWork加入项目中，导入头文件#import <Plugin_SDK_iOS/Plugin_SDK_iOS.h>
 */

/*
 2.本项目依赖于 'SDWebImage' 请确保您的项目中已经安装此库
 */

/*
 3.sdk需要开启定位权限，请在工程plist.info文件中添加NSLocationAlwaysAndWhenInUseUsageDescription和NSLocationWhenInUseUsageDescription
 */

/*
 4.请在info.plist文件添加一个Allow Arbitrary Loads元素，同时设为 YES
 */
#import <Plugin_SDK_iOS/SynopticNetworkCustomView.h>

