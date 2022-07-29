//
//  EUTDepositCalculatorController.m
//  EUTTools
//
//  Created by apple on 2020/1/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTDepositCalculatorController.h"
#import "EUTProfitsController.h"
#import "EUTDepositCalculatorCell.h"
#import "EUTPickerView.h"

@interface EUTDepositCalculatorController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,EUTPickerViewDelegate>

@property (nonatomic ,strong) UITableView *DepositHomeTableView;
@property (nonatomic ,strong) UIView *headV;
@property (nonatomic ,copy)   NSString *moneyStr; // 存款金额
@property (nonatomic ,copy)   NSString *dateStr; // 显示日期
@property (nonatomic ,copy)   NSString *typeStr; // 类型 1.活期 2.定期
@property (nonatomic ,copy)   NSString *rateStr; // 年利率
@property (nonatomic ,copy)   NSString *dateDou; // 计算日期
@property (nonatomic ,assign) NSInteger seleNum; // 选择下表
@property (nonatomic ,strong) NSArray *yearsArr;
@end

@implementation EUTDepositCalculatorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"存款计算器";
    [self initPageData];
}
- (void)initPageData {
    self.moneyStr = @"";
    self.typeStr = @"1";
    self.dateStr = @"1年";
    self.rateStr = @"0.35";
    self.dateDou = @"1";
    self.seleNum = 2;
    self.yearsArr = @[@"0.25",@"0.5",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"15",@"20",@"30",@"50",@"75",@"100"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.view addSubview:self.headV];
    self.DepositHomeTableView.frame = CGRectMake(SP(20), EUTNaviBarHeight + SP(120)+SP((10)), kScreenW - SP(40), SP(250));
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(queryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.DepositHomeTableView.mas_bottom).offset(90);
        make.height.mas_equalTo(45);
    }];
}
- (UITableView *)DepositHomeTableView{
    if (_DepositHomeTableView == nil) {
        _DepositHomeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _DepositHomeTableView.delegate = self;
        _DepositHomeTableView.dataSource = self;
        _DepositHomeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _DepositHomeTableView.scrollEnabled = NO;
        _DepositHomeTableView.backgroundColor = [UIColor whiteColor];
        _DepositHomeTableView.layer.cornerRadius = SP(8);
        [self.view addSubview:_DepositHomeTableView];
        if (@available(iOS 11.0, *)) {
            // 不考虑安全区域（系统默认有安全区域），更多用于没有导航栏全屏展示TableView
            _DepositHomeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _DepositHomeTableView.estimatedRowHeight=0;
            _DepositHomeTableView.estimatedSectionHeaderHeight=0;
            _DepositHomeTableView.estimatedSectionFooterHeight=0;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        if (@available(iOS 15.0, *)) {
            _DepositHomeTableView.sectionHeaderTopPadding = 0;
        }
        
    }
    return _DepositHomeTableView;
}
- (UIView *)headV{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = MainColor;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SP(120))];
    backView.backgroundColor = MainColor;
    [headView addSubview:backView];
    
    for (int i=0; i<2; i++) {
        
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.textColor = [UIColor whiteColor];
        titleLB.font = [UIFont systemFontOfSize:SP(12)];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.text = @[@"利息 (元)",@"本息 (元)"][i];
        [backView addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backView.mas_left).offset(kScreenW/4+kScreenW/2*i);
            make.width.mas_equalTo(kScreenW/2-10);
            make.centerY.mas_equalTo(backView).offset(SP(-15));
        }];
        
        UILabel *valueLB = [[UILabel alloc] init];
        valueLB.textColor = [UIColor whiteColor];
        valueLB.font = [UIFont systemFontOfSize:SP(25)];
        valueLB.textAlignment = NSTextAlignmentCenter;
        valueLB.text = @"0.00";
        valueLB.tag = 1000+i;
        [backView addSubview:valueLB];
        [valueLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(titleLB);
            make.width.mas_equalTo(kScreenW/2-10);
            make.top.mas_equalTo(titleLB.mas_bottom).offset(SP(5));
        }];
    }
    
    headView.frame = CGRectMake(0, EUTNaviBarHeight, kScreenW, CGRectGetMaxY(backView.frame));//SP(283)
    return headView;
}
#pragma mark -  tableView deleagte

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SP(50);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    EUTDepositCalculatorCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[EUTDepositCalculatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell.valueLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell).offset(-15);
    }];
    cell.iconImageView.hidden = YES;
    cell.valueLB.hidden = NO;
    cell.valueTF.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.valueLB.hidden = YES;
        cell.valueTF.hidden = NO;
        cell.valueTF.tag = 2000;
        cell.valueTF.delegate = self;
        cell.valueTF.text = self.moneyStr;
    }else if (indexPath.row==1) {
        [cell.valueLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-30);
        }];
        if([self.typeStr isEqualToString:@"1"]){
             cell.valueLB.text = @"活期";
        }else{
             cell.valueLB.text = @"定期";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row==2) {
        [cell.valueLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-30);
        }];
        cell.valueLB.text = self.dateStr;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row==3){
        cell.valueLB.text = self.rateStr;
    }else if (indexPath.row==4){
        cell.valueLB.hidden = YES;
        cell.iconImageView.hidden = NO;
    }
    cell.titleLB.text = @[@"存款金额（元）",@"存款类型",@"存款期限",@"年利率（%）",@"利润表"][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITextField *textField = (UITextField *)[self.view viewWithTag:2000];
    [textField resignFirstResponder];
    if (indexPath.row==0) {
        UITextField *textTF = (UITextField *)[self.view viewWithTag:2000];
        [textTF becomeFirstResponder];
    }else if (indexPath.row==1) {
        if ([self.typeStr isEqualToString:@"1"]) {
            self.typeStr = @"2";
            if (self.seleNum>3) {
                self.rateStr = @"2.75";
            }else {
                self.rateStr = @[@"1.10",@"1.30",@"1.50",@"2.10"][self.seleNum];
            }
        }else {
            self.typeStr = @"1";
            self.rateStr = @"0.35";
        }
        [self.DepositHomeTableView reloadData];
        [self calculate];
    }else if (indexPath.row==2) {
        EUTPickerView *picker = [[EUTPickerView alloc]initWithFrame:self.view.bounds];
        picker.delegate = self ;
        picker.title = @"存款期限";
        picker.customArr = @[@"3个月",@"6个月",@"1年",@"2年",@"3年",@"4年",@"5年",@"6年",@"7年",@"8年",@"9年",@"10年",@"15年",@"20年",@"30年",@"50年",@"75年",@"100年"];
        picker.defaultStr = self.dateStr;
        [self.view addSubview:picker];
    }else if(indexPath.row == 4){
        EUTProfitsController *MVC = [[EUTProfitsController alloc] init];
        [self.navigationController pushViewController:MVC animated:YES];
    }
}
#pragma mark -  methods
// 计算
- (void)calculate {
    
    double lixi = [self.moneyStr doubleValue]*[self.dateDou doubleValue]*[self.rateStr doubleValue]/100;
    double benxi = lixi + [self.moneyStr doubleValue];
    
    for (int i=0; i<2; i++) {
        UILabel *valueLB = (UILabel *)[self.view viewWithTag:1000+i];
        valueLB.text = @[[NSString stringWithFormat:@"%.2f",lixi],
                         [NSString stringWithFormat:@"%.2f",benxi]][i];
    }
}
- (void)textFieldDidChange {
    
    UITextField *textTF = (UITextField *)[self.view viewWithTag:2000];
    
    if (textTF.text.length>1) {
        if ([[textTF.text substringToIndex:1] isEqualToString:@"0"] && ![[textTF.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]) {
            textTF.text = [textTF.text substringToIndex:1];
        }
    }
    if ([textTF.text isContainStr:@"."]) {
        NSUInteger at = [textTF.text rangeOfString:@"."].location;
        if (textTF.text.length>at+3) {
            textTF.text = [textTF.text substringToIndex:at+3];
        }
        if (at>13) {
            textTF.text = [textTF.text substringToIndex:13];
        }
    }else {
        if (textTF.text.length>10) {
            textTF.text = [textTF.text substringToIndex:10];
        }
    }
}
-(void)queryBtnAction{
    if(self.moneyStr.length==0 ||!self.moneyStr){
        [CommonTool toastMessage:@"请输入存款金额"];
        return;
    }
    [self.DepositHomeTableView reloadData];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text Index:(NSInteger)num {
    
    self.seleNum = num;
    self.dateStr = text;
    self.dateDou = self.yearsArr[num];
    if ([self.typeStr isEqualToString:@"1"]) {
        self.rateStr = @"0.35";
    }else {
        if (num>3) {
            self.rateStr = @"2.75";
        }else {
            self.rateStr = @[@"1.10",@"1.30",@"1.50",@"2.10"][num];
        }
    }
    [self.DepositHomeTableView reloadData];
    [self calculate];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length>0) {
        if (![textField.text isEqualToString:self.moneyStr]) {
            self.moneyStr = textField.text;
            [self calculate];
        }
    }else {
        self.moneyStr = @"";
        for (int i=0; i<2; i++) {
            UILabel *valueLB = (UILabel *)[self.view viewWithTag:1000+i];
            valueLB.text = @"0.00";
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
- (void)reSettableViewHeaderFrame:(CGFloat)scrollH{
    [self.DepositHomeTableView beginUpdates];
    [self.DepositHomeTableView setTableHeaderView:self.headV];
    [self.DepositHomeTableView endUpdates];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
