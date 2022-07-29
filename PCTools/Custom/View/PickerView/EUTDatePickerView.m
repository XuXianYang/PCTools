//
//  EUTDatePickerView.m
//  EUTTools
//
//  Created by apple on 2020/1/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTDatePickerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface EUTDatePickerView ()

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;

@property (strong, nonatomic) NSString *initialDate;// 初始化显示日期
@property (strong, nonatomic) NSString *selectedDate;// 选中日期

@end

@implementation EUTDatePickerView

- (instancetype)initWithInitialDate:(NSString *)initialDate {
    
    if ([super init]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfTapAction)];
        [self addGestureRecognizer:tap];
        
        self.initialDate = initialDate;
        self.selectedDate = initialDate;
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
        
        [self drawView];
        
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216 + 44);
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, kScreenHeight - 216 - 44, kScreenWidth, 216 + 44);
            [self.bottomView layoutIfNeeded];
        }];
    }
    return self;
}
#pragma mark - drawView

- (void)drawView {
    [self addSubview:self.bottomView];
}
#pragma mark - action

- (void)cancelButtonAction:(UIButton *)button {
    [self selfTapAction];
}
- (void)confirmButtonAction:(UIButton *)button {
    self.confirmBlock(self.selectedDate);
    [self selfTapAction];
}
-(void)selfTapAction{
    self.bottomView.frame = CGRectMake(0, kScreenHeight - 216 - 44, kScreenWidth, 216 + 44);
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 216 + 44);
        [self.bottomView layoutIfNeeded];
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)datePickerDidChanged:(UIDatePicker *)datePicker {
    // 直接获取的时间, 时区不对, 经过格式转换后得到的一个字符串, 时间就对了
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.selectedDate = [dateFormatter stringFromDate:datePicker.date];
}
#pragma mark - 懒加载
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.cancelButton];
        [_bottomView addSubview:self.confirmButton];
        [_bottomView addSubview:self.datePicker];
    }
    return _bottomView;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 12, 44, 20)];
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitleColor:[UIColor colorWithRed:195 / 255.0 green:195 / 255.0 blue:195 / 255.0 alpha:1] forState:(UIControlStateNormal)];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 44 - 20, 12, 44, 20)];
        _confirmButton.backgroundColor = [UIColor clearColor];
        [_confirmButton setTitle:@"完成" forState:(UIControlStateNormal)];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmButton setTitleColor:MainColor forState:(UIControlStateNormal)];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmButton;
}
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 216)];// 默认高度 216
        _datePicker.backgroundColor = [UIColor clearColor];
        /**
         datePicker 的显示模式
         
         UIDatePickerModeTime           显示时间
         UIDatePickerModeDate           显示日期
         UIDatePickerModeDateAndTime    显示日期和时间
         */
        _datePicker.datePickerMode = UIDatePickerModeDate;
        
        /**
         minimumDate 和 maximumDate
         这两个值控制的是用户可用的有效时间范围, 默认值都是nil, nil 意味着没有最小和最大使用的时间约束, 也就是说用户可以随便滚动滚轮选择时间
         如果设置了 minimumDate 和 maximumDate 的值, 那么当用户滚动超出 minimumDate 时会自动回滚到 minimumDate, 当用户滚动超出 maximumDate 时会自动回滚到 maximumDate
         实际开发中根据具体情况来设定这两个值即可, 此处为生日选择, 所以可以是过去的任意时间和当前日期
         */
        //        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
        _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
        
        // datePicker 当前显示的日期 : 默认显示的是 datePicker 创建时的日期
        if (self.initialDate.length == 0) {
            _datePicker.date = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            self.selectedDate = [dateFormatter stringFromDate:[NSDate date]];
        }else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd";
            _datePicker.date = [dateFormatter dateFromString:self.initialDate];
        }
        [_datePicker addTarget:self action:@selector(datePickerDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}
@end
