//
//  EUTTimePickerView.m
//  EUTTools
//
//  Created by apple on 2020/1/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTTimePickerView.h"

@interface EUTTimePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) NSMutableArray *customArr;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *defaultStr;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *completionBtn;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIView* line;
@property (nonatomic, copy) NSString *selectedStr;

@end

@implementation EUTTimePickerView

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
        
        self.pickerView = [UIPickerView new];
        [self.bgView addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.line);
            make.left.right.mas_equalTo(0);
        }];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }
    return self;
}
-(void)setSelArr:(NSArray *)selArr{
    _selArr = selArr;
    if(selArr.count>=3){
        for(NSInteger i =0;i<3;i++){
            NSInteger index = [selArr[i] integerValue];
            [self.pickerView selectRow:index inComponent:i animated:NO];
        }
    }
}
-(NSMutableArray*)customArr{
    if(!_customArr){
        _customArr = [NSMutableArray array];
        NSMutableArray *hArr = [NSMutableArray array];
        NSMutableArray *mArr = [NSMutableArray array];
        NSMutableArray *sArr = [NSMutableArray array];
        for(int i=0;i<60;i++){
            if(i<24){
                [hArr addObject:[NSString stringWithFormat:@"%02d时",i]];
            }
            [mArr addObject:[NSString stringWithFormat:@"%02d分",i]];
            [sArr addObject:[NSString stringWithFormat:@"%02d秒",i]];
        }
        [_customArr addObjectsFromArray:@[hArr,mArr,sArr]];
    }
    return _customArr;
}

#pragma mark-----UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.customArr.count;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *arr = self.customArr[component];
    return arr.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *arr = self.customArr[component];
    return arr[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}
- (void)tapAction {
    [self hideAnimation];
}
- (void)cancelBtnClick{
    [self hideAnimation];
}
- (void)completionBtnClick{
    NSString *hour = [self.customArr[0] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    NSString *min = [self.customArr[1] objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    NSString *sec = [self.customArr[2] objectAtIndex:[self.pickerView selectedRowInComponent:2]];
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:didSelectHour:min:sec:)]) {
        [self.delegate pickerView:self.pickerView didSelectHour:[hour substringToIndex:hour.length-1] min:[min substringToIndex:min.length-1] sec:[sec substringToIndex:sec.length-1]];
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
