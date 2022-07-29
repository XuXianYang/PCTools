//
//  EUTDatePickerView.h
//  EUTTools
//
//  Created by apple on 2020/1/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^WYBirthdayPickerViewBlock)(NSString *selectedDate);

@interface EUTDatePickerView : UIView

@property (strong, nonatomic) WYBirthdayPickerViewBlock confirmBlock;

- (instancetype)initWithInitialDate:(NSString *)initialDate;


@end

NS_ASSUME_NONNULL_END
