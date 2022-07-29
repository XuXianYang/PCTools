//
//  HQPickerView.h
//  HQPickerView
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 judian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EUTPickerViewDelegate <NSObject>

- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text Index:(NSInteger)num;

@end

@interface EUTPickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *customArr;
@property (nonatomic, weak) id <EUTPickerViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *defaultStr;

@end
