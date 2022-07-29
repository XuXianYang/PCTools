//
//  PCQueryRecreationController.h
//  PCTools
//
//  Created by apple on 2019/12/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RecreationPageType){
    PCQueryZGJMType = 1,//周公解梦
    PCQuerySJHJXType = 2//手机号吉凶
};

@interface PCQueryRecreationController : PCBaseViewController

@property(nonatomic,assign)RecreationPageType pageType;

@end

NS_ASSUME_NONNULL_END
