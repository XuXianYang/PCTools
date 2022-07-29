//
//  HQPickerView.m
//  HQPickerView
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 judian. All rights reserved.
//

#import "EUTPickerView.h"

@interface EUTPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *completionBtn;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIView* line;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, copy) NSString *selectedStr;

@end

@implementation EUTPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        self.backgroundColor = self.backgroundColor = RGBA(51, 51, 51, 0.3);
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, SP(220))];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        
        UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-SP(225))];
        headV.backgroundColor = [UIColor clearColor];
        [self addSubview:headV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [headV addGestureRecognizer:tap];
        
        //显示动画
        [self showAnimation];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(44);
        }];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:SP(17)];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, kScreenW - 110, 44)];
        self.titleLb.font = [UIFont systemFontOfSize:SP(17)];
        self.titleLb.textColor = UIColorFromRGB(0x000000);
        self.titleLb.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.titleLb];
        
        self.completionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:self.completionBtn];
        [self.completionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(44);
        }];
        self.completionBtn.titleLabel.font = [UIFont systemFontOfSize:SP(17)];
        [self.completionBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.completionBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [self.completionBtn addTarget:self action:@selector(completionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //线
        UIView *line = [UIView new];
        [self.bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.cancelBtn.mas_bottom).offset(0);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenW);
            make.height.mas_equalTo(0.5);
            
        }];
        line.backgroundColor = RGBA(224, 224, 224, 1);
        self.line = line ;
    }
    return self;
}
// 标题
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLb.text = title;
}
// 默认选项
- (void)setDefaultStr:(NSString *)defaultStr {
    _defaultStr = defaultStr;
    if (defaultStr.length) {
        NSInteger selectRow = [self.customArr indexOfObject:self.defaultStr];
        [self.pickerView selectRow:selectRow inComponent:0 animated:NO];
    }
}

#pragma mark-----UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.customArr.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.customArr[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedStr = self.customArr[row];
}

- (void)setCustomArr:(NSArray *)customArr {
    _customArr = customArr;
    self.pickerView = [UIPickerView new];
    [self.bgView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.line);
        make.left.right.mas_equalTo(0);
    }];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.array addObject:customArr];
}

- (void)tapAction {
    [self hideAnimation];
}

#pragma mark-----取消
- (void)cancelBtnClick{
    [self hideAnimation];
}

#pragma mark-----取消
- (void)completionBtnClick{
    NSString *str = [self.customArr objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:didSelectText:Index:)]) {
        [self.delegate pickerView:self.pickerView didSelectText:str Index:[self.pickerView selectedRowInComponent:0]];
    }
    [self hideAnimation];
}

#pragma mark-----隐藏的动画
- (void)hideAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.bgView.frame;
        frame.origin.y = kScreenH;
        self.bgView.frame = frame;
    } completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark-----显示的动画
- (void)showAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.bgView.frame;
        frame.origin.y = kScreenH-SP(220);
        self.bgView.frame = frame;
    }];
}

@end
