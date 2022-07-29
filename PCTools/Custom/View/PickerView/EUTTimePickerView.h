//
//  EUTTimePickerView.h
//  EUTTools
//
//  Created by apple on 2020/1/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol EUTTimePickerDelegate <NSObject>

- (void)pickerView:(UIPickerView *)pickerView didSelectHour:(NSString *)hour min:(NSString*)min sec:(NSString*)sec;

@end

@interface EUTTimePickerView : UIView

@property(nonatomic,retain)NSArray *selArr;

@property (nonatomic, weak) id <EUTTimePickerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
