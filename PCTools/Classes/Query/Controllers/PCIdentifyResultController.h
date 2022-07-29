//
//  NCHelperTextController.h
//  NCCalculator
//
//  Created by 陈凯 on 2019/12/16.
//  Copyright © 2019 NongCai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PCIdentifyResultController : PCBaseViewController

/** 识别数据 */
@property (nonatomic,strong) NSMutableArray *dataArray;
/** 拍摄识别的图片 */
@property (nonatomic,strong) UIImage *showImage;

@end

NS_ASSUME_NONNULL_END
