//
//  PCBaseViewController.h
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QueryPageType){
    EUTQueryNumType = 1,//查询手机号归属地
    EUTQueryIPType = 2,//查询IP
    EUTQueryLJFLType = 3,//查询垃圾分类
    EUTQueryDXZMType = 4,//转换成大写字母
    EUTQueryHBHCXType = 5,//航班号查询
    EUTQueryHXCXType = 6,//航线查询
    EUTQueryWDWZType = 7,//我的位置
    EUTQuerySBXXType = 8,//设备信息
    EUTQueryWLCSType = 9,//网络测速
    EUTQueryXJJNRType = 10,//新建纪念日
    EUTQueryBJJNRType = 11//编辑纪念日
};
NS_ASSUME_NONNULL_BEGIN

@interface PCBaseViewController : UIViewController

@property(nonatomic,assign)QueryPageType pageType;

-(void)openPageWithIndex:(NSInteger)index andTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
