//
//  EUTBulletScreenController.m
//  EUTTools
//
//  Created by apple on 2020/1/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTBulletScreenController.h"
#import "EUTPickerView.h"

@interface EUTBulletScreenController ()<UITextViewDelegate,EUTPickerViewDelegate>

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeHoderLabel;
@property(nonatomic,strong)UIView *contentBgView;
@property(nonatomic,strong)UIView *typeBgView;
@property(nonatomic,strong)UIView *speedBgView;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *speedLabel;
@property(nonatomic,assign)BOOL isScroll;
@property(nonatomic,assign)BOOL isFast;
@property(nonatomic,strong)UIView *fullView;
@property(nonatomic,strong)UILabel *timeLabel;;

@end

@implementation EUTBulletScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手持弹幕";
    [self eutSetupSubViews];
}
//弹幕关闭
-(void)timerBackBtnAction{
    [self.view.layer removeAllAnimations];
    [self.timeLabel.layer removeAllAnimations];
    [self.timeLabel removeFromSuperview];
    [self.fullView removeFromSuperview];
    self.timeLabel = nil;
    self.fullView = nil;
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
//全屏点击事件
-(void)eutQueryBtnAction{
    [self.textView resignFirstResponder];
    if(self.textView.text.length == 0){
        [CommonTool toastMessage:@"请输入文字内容"];
        return;
    }
    [self.view addSubview:self.fullView];
    if(self.isScroll == NO){
        self.timeLabel.numberOfLines = 0;
        self.timeLabel.frame = CGRectMake(20,70,kScreenW-40, kScreenH-160);
    }else{
        self.timeLabel.numberOfLines = 1;
        [self setupScrollAnimation];
    }
    self.timeLabel.text = self.textView.text;
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
//开始滚动动画
-(void)setupScrollAnimation{
    //先通过计算文字宽度,更新lable宽度
    CGSize size = [self.textView.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:72.f]}];
    CGFloat leftMargin = (kScreenW - size.width)/2;
    self.timeLabel.frame = CGRectMake(leftMargin,kScreenH,size.width, size.width+20);
    [self.timeLabel setAdjustsFontSizeToFitWidth:YES];
    CGFloat time = size.width/kScreenW*5;
    
    if(self.isFast){
        time = size.width/kScreenW*3;
    }
    //执行动画:从右往左匀速飘过
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.timeLabel.frame = CGRectMake(leftMargin,-size.width-20,size.width, size.width+20);
    } completion:^(BOOL finished) {
        if(finished){
            [self setupScrollAnimation];
        }
    }];
}
//选择器回调
-(void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text Index:(NSInteger)num{
    if(pickerView.tag == 80){
        if([text isEqualToString:@"静止"]){
            self.speedBgView.hidden = YES;
            [self.contentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SP(55));
            }];
            self.isScroll = NO;
        }else{
            self.speedBgView.hidden = NO;
            [self.contentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SP(110));
            }];
            self.isScroll = YES;
        }
        self.typeLabel.text = text;
    }else{
        if([text isEqualToString:@"慢"]){
            self.isFast = NO;
        }else{
            self.isFast = YES;
        }
        self.speedLabel.text = text;
    }
}
//选择器弹出
-(void)typeAction:(UITapGestureRecognizer*)tap{
    [self.textView resignFirstResponder];
    EUTPickerView *picker = [[EUTPickerView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:picker];
    picker.delegate = self ;
    if(tap.view.tag == 60){
        picker.title = @"显示方式";
        picker.customArr = @[@"滚动",@"静止"];
        picker.defaultStr = self.typeLabel.text;
        picker.pickerView.tag = 80;
    }else{
        picker.title = @"滚动速度";
        picker.customArr = @[@"快",@"慢"];
        picker.defaultStr = self.speedLabel.text;
        picker.pickerView.tag = 81;
    }
}
-(void)selfTapAction{
    [self.textView resignFirstResponder];
}
//全屏弹幕View
-(UIView*)fullView{
    if(!_fullView){
        _fullView = [[UIView alloc]initWithFrame:self.view.bounds];
        _fullView.backgroundColor = MainColor;
       
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_fullView addSubview:self.timeLabel];
    
        self.timeLabel.font = [UIFont systemFontOfSize:72];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.textColor = UIColorFromRGB(0xED9B0B);
        self.timeLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.timeLabel.frame = CGRectMake(0,0,kScreenW, kScreenH);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"timerBack"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(timerBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
        btn.transform = CGAffineTransformMakeRotation(M_PI_2);
        btn.frame = CGRectMake(kScreenW-70,kScreenH-70,40, 40);
    }
    return _fullView;
}
-(void)eutSetupSubViews{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfTapAction)];
    [self.view addGestureRecognizer:tap];
    
    UITextView *textView = [[UITextView alloc]init];
    [self.view addSubview:textView];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:16.0];
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = SP(8);
    textView.layer.borderWidth = 0.5;
    //textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.layer.borderColor = UIColorFromRGB(0xa0a0a0).CGColor;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(EUTNaviBarHeight + 20);
        make.height.mas_equalTo(SP(100));
    }];
    self.textView = textView;
    
    UILabel *placeHoderLabel = [[UILabel alloc]init];
    [self.textView addSubview:placeHoderLabel];
    placeHoderLabel.textColor = UIColorFromRGB(0xa0a0a0);
    placeHoderLabel.font = [UIFont systemFontOfSize:16.0];
    placeHoderLabel.text = @"请输入文字";
    [placeHoderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).offset(5);
        make.top.equalTo(self.textView).offset(10);
    }];
    self.placeHoderLabel = placeHoderLabel;
    
    self.contentBgView = [[UIView alloc]init];
    self.contentBgView.layer.cornerRadius = SP(8);
    self.contentBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentBgView];
    self.contentBgView.clipsToBounds = YES;
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(SP(110));
    }];
    
    NSArray *titleArr = @[@"显示方式",@"滚动速度"];
    NSArray *contentArr = @[@"滚动",@"快"];
    
    self.isFast = YES;
    self.isScroll = YES;
    
    for(NSInteger i=0;i<2;i++){
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, SP(55)*i, kScreenW-40, SP(55))];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentBgView addSubview:bgView];
        bgView.tag = 60+i;
        bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction:)];
        [bgView addGestureRecognizer:tap];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [bgView addSubview:titleLabel];
        titleLabel.textColor = UIColorFromRGB(0x000000);
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        titleLabel.text = titleArr[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(12);
            make.centerY.equalTo(bgView);
        }];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moreIcon"]];
        [bgView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-12);
            make.centerY.equalTo(bgView);
        }];
        
        UILabel *contentLabel = [[UILabel alloc]init];
        [bgView addSubview:contentLabel];
        contentLabel.textAlignment = NSTextAlignmentRight;;
        contentLabel.textColor = UIColorFromRGB(0x000000);
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        contentLabel.text = contentArr[i];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-30);
            make.centerY.equalTo(bgView);
        }];
        
        if(i==0){
            self.typeBgView = bgView;
            self.typeLabel = contentLabel;
        }else{
            self.speedBgView = bgView;
            self.speedLabel = contentLabel;
        }
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:SP(16)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn setTitle:@"全屏" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(eutQueryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentBgView.mas_bottom).offset(55);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW - 40);
        make.height.mas_equalTo(SP(45));
    }];
    
}
-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length){
        self.placeHoderLabel.hidden = YES;
    }else{
        self.placeHoderLabel.hidden = NO;
    }
}
@end
