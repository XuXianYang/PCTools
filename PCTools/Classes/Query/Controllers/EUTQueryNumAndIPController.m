//
//  PCQueryNumAndIPController.m
//  PCTools
//
//  Created by apple on 2019/12/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "EUTQueryNumAndIPController.h"
#import "EUTQueryNumAndIPCell.h"

@interface EUTQueryNumAndIPController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,retain)NSMutableArray*dataList;
@property(nonatomic,strong)UITextField *queryTextField;
@property(nonatomic,strong)UITextView *contentLabel;

@end

@implementation EUTQueryNumAndIPController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self eutSetupSubViews];
    [self eutInitPageData];
}
-(void)eutQueryBtnAction{
    [self.queryTextField resignFirstResponder];
    
    if(self.queryTextField.text.length==0){
        [CommonTool toastMessage:@"输入内容不能为空"];
        return;
    }
    
    if(self.pageType == EUTQueryDXZMType){
        NSString *moneyStr = [self.queryTextField.text toCapitalLetters];
        self.contentLabel.text = [NSString stringWithFormat:@"转换结果:%@",moneyStr];;
        return;
    }
    
    NSString *url; NSDictionary *parm;
    if(self.pageType == EUTQueryIPType){
        url = EUTQueryIPUrl;
        parm = @{@"ip":self.queryTextField.text};
        if(![CommonTool isValidatIP:self.queryTextField.text]){
            [CommonTool toastMessage:@"请输入正确的IP地址"];
            return;
        }
    }else if(self.pageType == EUTQueryNumType){
        if(![CommonTool valiMobile:self.queryTextField.text]){
            [CommonTool toastMessage:@"请输入正确的手机号"];
            return;
        }
        url = EUTQueryMoboleNumUrl;
        parm = @{@"mobile":self.queryTextField.text};
    }else if(self.pageType == EUTQueryLJFLType){
        url = EUTQueryLJFLUrl;
        parm = @{@"goods":self.queryTextField.text};
    }
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    [PCRequestTool postAllUrl:url params:parm success:^(id responsebject) {
        [PNCGifWaitView hideWaitViewInController:self];
        if([responsebject[@"status"] isEqualToString:@"0000"]){
            [self.dataList removeAllObjects];
            NSDictionary *dict = responsebject[@"data"];
            if(self.pageType == EUTQueryIPType){
                [self.dataList addObjectsFromArray:@[
                 @{@"title":@"IP地址:",@"content":[CommonTool safeString:dict[@"ip"]]},            @{@"title":@"归属城市:",@"content":[CommonTool safeString:dict[@"addIp"]]}]];
            }else if(self.pageType == EUTQueryNumType){
                [self.dataList addObjectsFromArray:@[
                @{@"title":@"手机号:",@"content":[CommonTool safeString:dict[@"mobile"]]},
                @{@"title":@"归属地:",@"content":[CommonTool safeString:dict[@"territoriality"]]},
                @{@"title":@"运营商:",@"content":[CommonTool safeString:dict[@"model"]]}]];
            }else if(self.pageType == EUTQueryLJFLType){
                [self.dataList addObjectsFromArray:@[@{@"title":@"物品:",@"content":[CommonTool safeString:dict[@"goods"]]},
                    @{@"title":@"分类:",@"content":[CommonTool safeString:dict[@"category"]]}]];
            }
        }else{
            [self eutInitPageData];
            [CommonTool toastMessage:responsebject[@"message"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [PNCGifWaitView hideWaitViewInController:self];
        [CommonTool toastMessage:@"系统繁忙"];
        [self eutInitPageData];
        [self.tableView reloadData];
    }];
}
-(void)eutInitPageData{
    [self.dataList removeAllObjects];
    if(self.pageType == EUTQueryIPType){
        self.navigationItem.title = @"IP地址查询";
        self.queryTextField.placeholder = @"请输入IP地址";
        [self.dataList addObjectsFromArray:@[@{@"title":@"IP地址:",@"content":@""},                         @{@"title":@"归属城市:",@"content":@""}]];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SP(100));
        }];
    }else if(self.pageType == EUTQueryNumType){
        self.navigationItem.title = @"手机号归属地查询";
        self.queryTextField.placeholder = @"请输入手机号";
        [self.dataList addObjectsFromArray:@[@{@"title":@"手机号:",@"content":@""},
                                @{@"title":@"归属地:",@"content":@""},
                                @{@"title":@"运营商:",@"content":@""}]];
    }else if(self.pageType == EUTQueryLJFLType){
        self.navigationItem.title = @"垃圾分类";
        self.queryTextField.placeholder = @"请输入垃圾名称";
        [self.dataList addObjectsFromArray:@[@{@"title":@"物品:",@"content":@""},
                                  @{@"title":@"分类:",@"content":@""}]];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SP(100));
        }];
    }else if(self.pageType == EUTQueryDXZMType){
        self.navigationItem.title = @"大写数字";
        self.queryTextField.placeholder = @"请输入阿拉伯数字";
        self.contentLabel.hidden = NO;
        self.contentLabel.text = @"转换结果:";
    }
}
-(NSMutableArray*)dataList{
    if(!_dataList){
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
-(void)eutSetupSubViews{
    
    UITextField *textField = [[UITextField alloc]init];
    [self.view addSubview:textField];
    textField.textColor = UIColorFromRGB(0x010101);
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:SP(16)];
    textField.layer.cornerRadius = SP(8);
    textField.layer.borderWidth = 0.5;
    textField.delegate = self;
    if(self.pageType != EUTQueryLJFLType){
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    textField.returnKeyType = UIReturnKeyDone;
    textField.layer.borderColor = UIColorFromRGB(0xA0A0A0).CGColor;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, SP(45))];
    textField.leftView = leftView;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(EUTNaviBarHeight+20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(SP(45));
        make.width.mas_equalTo(kScreenW-40);
    }];
    self.queryTextField = textField;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(eutQueryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.queryTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(SP(45));
        make.width.mas_equalTo(kScreenW-40);
    }];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layer.cornerRadius = SP(8);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor =  [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EUTQueryNumAndIPCell class] forCellReuseIdentifier:@"EUTQueryNumAndIPCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.top.mas_equalTo(btn.mas_bottom).offset(40);
        make.height.mas_equalTo(SP(150));
    }];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight=10;
    self.tableView.bounces = NO;
    
    UITextView *contentLabel = [[UITextView alloc]init];
    [self.view addSubview:contentLabel];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:16.0];
    contentLabel.editable = NO;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-25);
        make.left.equalTo(self.view).offset(25);
        make.top.mas_equalTo(btn.mas_bottom).offset(45);
        make.height.mas_equalTo(SP(140));
    }];
    self.contentLabel = contentLabel;
    self.contentLabel.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self eutQueryBtnAction];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(self.pageType != EUTQueryDXZMType) return YES;
    UITextField *countTextField = textField;
    NSString *NumbersWithDot = @".1234567890";
    NSString *NumbersWithoutDot = @"1234567890";
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        if ([textField isEqual:countTextField]) {
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            // 判断字符串中是否有小数点
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            if (dotLocation == NSNotFound ) {
                // -- 如果限制非第一位才能输入小数点，加上 && range.location != 0
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                /*
                 [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                 在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                 */
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 30) {
                    NSLog(@"单笔金额不能超过亿位");
                    if ([string isEqualToString:@"."] && range.location == 30) {
                        return YES;
                    }
                    return NO;
                }
            }else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
            }
            // 按cs分离出数组,数组按@""分离出字符串
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest) {
                NSLog(@"只能输入数字和小数点");
                return NO;
            }
            if (dotLocation != NSNotFound && range.location > dotLocation + 2){
                NSLog(@"小数点后最多两位");
                return NO;
            }
            if (textField.text.length > 32) {
                return NO;
            }
        }
    }
    return YES;
}
-(UITableView*)tableView{
    if(!_tableView){
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}
#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EUTQueryNumAndIPCell*cell = [tableView dequeueReusableCellWithIdentifier:@"EUTQueryNumAndIPCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleStr = self.dataList[indexPath.row][@"title"];
    cell.contentStr = self.dataList[indexPath.row][@"content"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
