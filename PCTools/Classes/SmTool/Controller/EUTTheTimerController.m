//
//  EUTTheTimerController.m
//  EUTTools
//
//  Created by apple on 2020/1/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTTheTimerController.h"
#import "EUTTimePickerView.h"

@interface EUTTheTimerController ()<EUTTimePickerDelegate>

@property(nonatomic,retain)NSArray *selArr;
@property(nonatomic,strong)UIView *fullView;
@property(nonatomic,strong)UILabel *timeLabel;;
@property(nonatomic,assign)int totalSeconds;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,assign)int timerSeconds;

@end

@implementation EUTTheTimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全屏计时器";
    [self eutSetupSubViews];
}
//根据秒数返回时间
- (NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
-(void)timerBtnAction:(UIButton*)btn{
    NSInteger index = btn.tag - 40;
    if(index == 0){//重置定时器
        [self invalidateTimer];
        self.timeLabel.text = [self timeFormatted:self.totalSeconds];
    }else if(index == 1){//开始定时器
        if(!self.timer){
            [self setupTimer];
        }
    }else if(index == 2){//返回页面
        [self invalidateTimer];
        [self.fullView removeFromSuperview];
        [self.navigationController setNavigationBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
//定时器
- (void)setupTimer{
    [self invalidateTimer];
    self.timerSeconds = self.totalSeconds;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
//注销定时器
- (void)invalidateTimer{
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}
//定时器事件
-(void)timerAction{
    self.timerSeconds--;
    self.timeLabel.text = [self timeFormatted:self.timerSeconds];
    if(self.timerSeconds==0){
        [self invalidateTimer];
        self.timeLabel.text = @"00:00:00";
    }
}
//全屏点击事件
-(void)eutQueryBtnAction{
    if(self.selArr.count>=3){
        if([self.selArr[0] isEqualToString:@"00"]&&[self.selArr[1] isEqualToString:@"00"]&&[self.selArr[2] isEqualToString:@"00"]){
            [CommonTool toastMessage:@"请选择正确的时间"];
        }else{
            [self.navigationController setNavigationBarHidden:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
              self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
            [self.view addSubview:self.fullView];
            self.timeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",self.selArr[0],self.selArr[1],self.selArr[2]];
        }
    }else{
        [CommonTool toastMessage:@"请选择时间"];
    }
}
//时间选择器回调
-(void)pickerView:(UIPickerView *)pickerView didSelectHour:(NSString *)hour min:(NSString *)min sec:(NSString *)sec{
    self.totalSeconds = 0;
    NSArray* titleArr = @[hour,min,sec];
    self.selArr = titleArr;
    for(NSInteger i=0;i<3;i++){
        UIButton*btn = [self.view viewWithTag:20+i];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        
    }
    self.totalSeconds = [sec intValue] + [min intValue] * 60 + [hour intValue]*60*60;
}
//显示时间选择器
-(void)eutShowPickerAction{
    EUTTimePickerView *picker = [[EUTTimePickerView alloc]initWithFrame:self.view.bounds];
    picker.delegate = self ;
    picker.selArr = self.selArr;
    [self.view addSubview:picker];
}
//定时器View
-(UIView*)fullView{
    if(!_fullView){
        _fullView = [[UIView alloc]initWithFrame:self.view.bounds];
        _fullView.backgroundColor = MainColor;
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_fullView addSubview:self.timeLabel];
        self.timeLabel.font = [UIFont systemFontOfSize:150];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.textColor = UIColorFromRGB(0xED9B0B);
        self.timeLabel.adjustsFontSizeToFitWidth=YES;
        self.timeLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.timeLabel.frame = CGRectMake(50,0,kScreenW-50, kScreenH);
        NSArray *img = @[@"timerRefresh",@"timerBegin",@"timerBack"];
        for(NSInteger i=0;i<3;i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_fullView addSubview:btn];
            [btn setImage:[UIImage imageNamed:img[i]] forState:UIControlStateNormal];
            btn.tag = 40+i;
            [btn addTarget:self action:@selector(timerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.transform = CGAffineTransformMakeRotation(M_PI_2);
            switch (i) {
                case 0:{
                    btn.frame = CGRectMake(40, kScreenH/2-100, 60, 60);
                }
                    break;
                case 1:{
                    btn.frame = CGRectMake(40, kScreenH/2+40, 60, 60);
                }
                    break;
                case 2:{
                   btn.frame = CGRectMake(kScreenW-70,kScreenH-70,40, 40);
                }
                    break;
                default:break;
            }
        }
    }
    return _fullView;
}

-(void)eutSetupSubViews{
    
    CGFloat btnWidth = (kScreenW-40)/9;
    NSArray *titleArr = @[@"时",@"分",@"秒"];
    for(NSInteger i=0;i<3;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:SP(16)];
        [btn setTitleColor:MainColor forState:UIControlStateNormal];
        [btn setBackgroundColor: [UIColor whiteColor]];
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = SP(8);
        btn.tag = 20+i;
        btn.layer.borderColor = UIColorFromRGB(0xa0a0a0).CGColor;
        [btn addTarget:self action:@selector(eutShowPickerAction) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(PCNaviBarHeight + SP(20));
            make.left.equalTo(self.view).offset(20+btnWidth*i*3);
            make.width.mas_equalTo(btnWidth*2);
            make.height.mas_equalTo(SP(45));
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:kAutoScale(16)];
        [self.view addSubview:label];
        label.text = titleArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x000000);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(PCNaviBarHeight + SP(20));
            make.left.equalTo(self.view).offset(20+btnWidth*2+btnWidth*i*3);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(SP(45));
        }];
        
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:SP(16)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn setTitle:@"全屏" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(eutQueryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(PCNaviBarHeight+SP(125));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW - 40);
        make.height.mas_equalTo(SP(45));
    }];
}


@end
