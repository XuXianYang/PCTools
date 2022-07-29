//
//  EUTEditMemorialDayController.m
//  EUTTools
//
//  Created by apple on 2020/1/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTEditMemorialDayController.h"
#import "EUTPickerView.h"
#import "EUTDatePickerView.h"

@interface EUTEditMemorialDayController ()<UITextFieldDelegate,EUTPickerViewDelegate>

@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *daysField;
@property(nonatomic,strong)UISwitch *switchBtn;
@property(nonatomic,strong)UIView *contentBgView;
@property(nonatomic,copy)NSString *defaultDate;

@end

@implementation EUTEditMemorialDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self eutSetupSubViews];
    [self eutInitPageData];
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text Index:(NSInteger)num{
    UILabel *label = [self.view viewWithTag:161];
    label.text = text;
    UIView *view1 = [self.view viewWithTag:122];
    UIView *view2 = [self.view viewWithTag:124];
    if([text isEqualToString:@"按天数"]){
        view1.hidden = YES;
        view2.hidden = NO;
    }else{
        UILabel *label = [self.view viewWithTag:162];
        label.text = self.defaultDate;
        view1.hidden = NO;
        view2.hidden = YES;
    }
}
-(void)eutInitPageData{
    if(self.pageType == EUTQueryBJJNRType){
        NSInteger type = [self.dictData[@"type"] integerValue];
        self.defaultDate = self.dictData[@"date"];
        self.nameField.text = self.dictData[@"name"];
        UIView *view1 = [self.view viewWithTag:122];
        UIView *view2 = [self.view viewWithTag:124];
        UILabel *typeLabel = [self.view viewWithTag:161];
        if(type == 1){//按日期
            UILabel *label = [self.view viewWithTag:162];
            label.text = self.defaultDate;
            view1.hidden = NO;
            view2.hidden = YES;
            typeLabel.text = @"按日期";
        }else{//按天数
            view1.hidden = YES;
            view2.hidden = NO;
            typeLabel.text = @"按天数";
            self.daysField.text = self.dictData[@"content"];
        }
        NSInteger isOn = [self.dictData[@"switch"] integerValue];
        if(isOn == 0){
            self.switchBtn.on = NO;
        }else{
            self.switchBtn.on = YES;
        }
    }
}
//删除
-(void)eutDeleteBtnAction:(UIButton*)btn{
    NSArray *dataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MemorialDayData"];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:dataArr];
    if([tempArr containsObject:self.dictData]){
        [tempArr removeObject:self.dictData];
        [[NSUserDefaults standardUserDefaults] setObject:tempArr forKey:@"MemorialDayData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [CommonTool toastMessage:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [CommonTool toastMessage:@"删除失败"];
    }
}
//新建完成/编辑完成
-(void)eutQueryBtnAction:(UIButton*)btn{
    UIView *view = [self.view viewWithTag:122];
    if(self.nameField.text.length == 0 ){
        [CommonTool toastMessage:@"请输入名称"];
        return;
    }
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if(view.hidden == NO){//按日期
        UILabel *label = [self.view viewWithTag:162];
        if([label.text isEqualToString:@"请选择日期"]){
            [CommonTool toastMessage:@"请选择日期"];
            return;
        }
        [dataDict setObject:@(1) forKey:@"type"];
        [dataDict setObject:label.text forKey:@"date"];
        [dataDict setObject:label.text forKey:@"content"];
        
    }else{//按天数
        if(self.daysField.text.length == 0){
            [CommonTool toastMessage:@"请输入天数"];
            return;
        }
        [dataDict setObject:@(2) forKey:@"type"];
        [dataDict setObject:self.daysField.text forKey:@"content"];
        NSString *dateStr = [CommonTool getCurrentTimesWithFormatter:@"YYYY-MM-dd"];
        [dataDict setObject:dateStr forKey:@"date"];
    }
    [dataDict setObject:self.nameField.text forKey:@"name"];
    NSString *idStr = [CommonTool getCurrentTimesWithFormatter:@"YYYYMMddHHmmss"];
    [dataDict setObject:idStr forKey:@"sign"];
    
    NSArray *dataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MemorialDayData"];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:dataArr];

    if(self.switchBtn.isOn == YES){
        [dataDict setObject:@(1) forKey:@"switch"];
        [tempArr insertObject:dataDict atIndex:0];
        
    }else{
        [dataDict setObject:@(0) forKey:@"switch"];
        [tempArr addObject:dataDict];
    }
    
    if(self.pageType == EUTQueryBJJNRType){
        if([tempArr containsObject:self.dictData]){
            [tempArr removeObject:self.dictData];
        }
    }
    NSLog(@"dataDict = %@",dataDict);
    [[NSUserDefaults standardUserDefaults] setObject:tempArr forKey:@"MemorialDayData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [CommonTool toastMessage:@"新建成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)typeAction:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag - 120;
    if(index == 1){
        [self.nameField resignFirstResponder];
        [self.daysField resignFirstResponder];
        EUTPickerView *picker = [[EUTPickerView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:picker];
        picker.delegate = self ;
        picker.title = @"模式";
        picker.customArr = @[@"按天数",@"按日期"];
        UILabel *label = [self.view viewWithTag:161];
        picker.defaultStr = label.text;
    }else if(index == 2){
        [self.nameField resignFirstResponder];
        [self.daysField resignFirstResponder];
        EUTDatePickerView *datePicker = [[EUTDatePickerView alloc]initWithInitialDate:self.defaultDate];
        datePicker.confirmBlock = ^(NSString * _Nonnull selectedDate) {
            UILabel *label = [self.view viewWithTag:162];
            label.text = selectedDate;
        };
        [self.view addSubview:datePicker];
    }else if(index == 5){
        [self.daysField becomeFirstResponder];
    }else if(index == 0){
        [self.nameField becomeFirstResponder];
    }
}
-(void)selfTapAction{
    [self.nameField resignFirstResponder];
    [self.daysField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFiledDidChange:(UITextField *)textField{
    
    
}
-(void)eutSetupSubViews{
    if(self.pageType == EUTQueryXJJNRType){
        self.navigationItem.title = @"新建纪念日";
    }else{
        self.navigationItem.title = @"编辑纪念日";
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfTapAction)];
    [self.view addGestureRecognizer:tap];
    
    self.contentBgView = [[UIView alloc]init];
    self.contentBgView.layer.cornerRadius = SP(8);
    self.contentBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentBgView];
    self.contentBgView.clipsToBounds = YES;
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(20 + EUTNaviBarHeight);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(SP(200));
    }];
    
    NSArray *titleArr = @[@"名称",@"模式",@"日期",@"置顶"];
    NSArray *contentArr = @[@"请输入名称",@"按日期",@"请选择日期",@"置顶"];
    
    for(NSInteger i=0;i<titleArr.count;i++){
        NSInteger index = 1;
        if(i==2){
            index = 2;
        }
        for(NSInteger j=0;j<index;j++){
            //背景
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, SP(50)*i, kScreenW-40, SP(50))];
            bgView.backgroundColor = [UIColor whiteColor];
            [self.contentBgView addSubview:bgView];
            bgView.tag = 120 + i + j*2;
            bgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction:)];
            [bgView addGestureRecognizer:tap];
            //标题
            UILabel *titleLabel = [[UILabel alloc]init];
            [bgView addSubview:titleLabel];
            titleLabel.textColor = UIColorFromRGB(0x000000);
            titleLabel.font = [UIFont systemFontOfSize:16.0];
            titleLabel.text = titleArr[i];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).offset(12);
                make.centerY.equalTo(bgView);
            }];
            if(j==1){
                titleLabel.text = @"天数";
            }
            
            //置顶开关
            if(i==3){
                UISwitch *switchBtn = [[UISwitch alloc]init];
                [bgView addSubview:switchBtn];
                [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(bgView).offset(-12);
                    make.centerY.equalTo(bgView);
                }];
                switchBtn.onTintColor = MainColor;
                self.switchBtn = switchBtn;
            }
            //输入框
            if(i==0 || (i==2&&j==1)){
                UITextField *textField = [[UITextField alloc]init];
                [bgView addSubview:textField];
                textField.textColor = UIColorFromRGB(0x010101);
                textField.font = [UIFont systemFontOfSize:SP(16)];
                textField.backgroundColor = [UIColor whiteColor];
                [textField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
                textField.delegate = self;
                textField.textAlignment = NSTextAlignmentRight;
                textField.returnKeyType = UIReturnKeyDone;
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(kScreenW - 140);
                    make.right.equalTo(bgView).offset(-12);
                    make.centerY.equalTo(bgView);
                }];
                if(i==0){
                    textField.keyboardType = UIKeyboardTypeWebSearch;
                    textField.placeholder = @"请输入名称";
                    self.nameField = textField;
                }else{
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    textField.placeholder = @"请输入天数";
                    self.daysField = textField;
                }
            }
            
            if((i==1 || i==2)&&j==0){
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"moreIcon"]];
                [bgView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(bgView).offset(-12);
                    make.centerY.equalTo(bgView);
                }];
                UILabel *contentLabel = [[UILabel alloc]init];
                [bgView addSubview:contentLabel];
                contentLabel.tag = 160 +i;
                contentLabel.textAlignment = NSTextAlignmentRight;;
                contentLabel.textColor = UIColorFromRGB(0x000000);
                contentLabel.font = [UIFont systemFontOfSize:16.0];
                contentLabel.text = contentArr[i];
                [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(bgView).offset(-30);
                    make.centerY.equalTo(bgView);
                }];
            }
            if(j==1){
                bgView.hidden = YES;
            }else{
                
            }
        }
    }
    
    //完成
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:SP(16)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.tag = 100;
    [btn addTarget:self action:@selector(eutQueryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentBgView.mas_bottom).offset(SP(85));
        make.right.equalTo(self.view).offset(-20);
        make.width.mas_equalTo(kScreenW - 40);
        make.height.mas_equalTo(SP(45));
    }];
    //编辑纪念日
    if(self.pageType == EUTQueryBJJNRType){
        [btn setBackgroundImage:[UIImage imageNamed:@"smallBtnBgYellow"] forState:UIControlStateNormal];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenW/2 - 30);
        }];
        //删除
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:deleteBtn];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:SP(16)];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"smallBtnBgRed"] forState:UIControlStateNormal];
        deleteBtn.tag = 101;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(eutDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentBgView.mas_bottom).offset(SP(85));
            make.left.equalTo(self.view).offset(20);
            make.width.mas_equalTo(kScreenW/2 - 30);
            make.height.mas_equalTo(SP(45));
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
