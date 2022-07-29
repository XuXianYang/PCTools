//
//  PCQueryRecreationController.m
//  PCTools
//
//  Created by apple on 2019/12/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCQueryRecreationController.h"

@interface PCQueryRecreationController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *queryTextField;
@property(nonatomic,strong)UITextView *contentLab;

@end

@implementation PCQueryRecreationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainBgColor;
    [self setupSubViews];
    [self initPageData];
}
-(void)queryBtnAction{
    [self.queryTextField resignFirstResponder];
    
    if(self.queryTextField.text.length==0){
        [CommonTool toastMessage:@"输入内容不能为空"];
        return;
    }
    NSString *url; NSDictionary *parm;
    if(self.pageType == PCQueryZGJMType){
        url = PCQueryDreamUrl;
        parm = @{@"goods":self.queryTextField.text};
    }else if(self.pageType == PCQuerySJHJXType){
        if(![CommonTool valiMobile:self.queryTextField.text]){
            [CommonTool toastMessage:@"请输入正确的手机号!"];
            return;
        }
        url = PCLuckyByMobileUrl;
        parm = @{@"mobile":self.queryTextField.text};
    }
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    [PCRequestTool postAllUrl:url params:parm success:^(id responsebject) {
        [PNCGifWaitView hideWaitViewInController:self];
        if([responsebject[@"status"] isEqualToString:@"0000"]){
            if(self.pageType == PCQueryZGJMType){
                NSArray *arr = responsebject[@"data"];
                NSMutableArray *stringArray = [[NSMutableArray alloc] init];
                for(NSInteger i =0;i<arr.count;i++){
                    NSDictionary *dict = arr[i];
                    [stringArray addObject:[NSString stringWithFormat:@"%@:%@",dict[@"title"],dict[@"desc"]]];
                }
                self.contentLab.text = [stringArray componentsJoinedByString:@"\n"];
            }else if(self.pageType == PCQuerySJHJXType){
                self.contentLab.text = responsebject[@"data"][@"conclusion"];
            }
        }else{
            self.contentLab.text = @"";
            [CommonTool toastMessage:responsebject[@"message"]];
        }
    } failure:^(NSError *error) {
        [PNCGifWaitView hideWaitViewInController:self];
        self.contentLab.text = @"";
        [CommonTool toastMessage:@"系统繁忙"];
    }];
}
-(void)initPageData{
    if(self.pageType == PCQueryZGJMType){
        self.navigationItem.title = @"周公解梦";
        self.queryTextField.placeholder = @"请输入梦源关键字";
    }else if(self.pageType == PCQuerySJHJXType){
        self.navigationItem.title = @"手机号吉凶查询";
        self.queryTextField.placeholder = @"请输入手机号";
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self queryBtnAction];
    return YES;
}
-(void)setupSubViews{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, PCNaviBarHeight, kScreenW, 85)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(queryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-20);
        make.centerY.equalTo(headerView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(45);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    [headerView addSubview:textField];
    textField.textColor = UIColorFromRGB(0x010101);
    textField.font = [UIFont systemFontOfSize:16];
    textField.layer.cornerRadius = 3;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = UIColorFromRGB(0xA0A0A0).CGColor;
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeWebSearch;
    textField.returnKeyType = UIReturnKeyDone;
    textField.leftViewMode = UITextFieldViewModeAlways;
    if(self.pageType == PCQuerySJHJXType){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 45)];
    textField.leftView = leftView;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView).offset(20);
        make.right.mas_equalTo(btn.mas_left).offset(-10);
        make.height.mas_equalTo(45);
    }];
    self.queryTextField = textField;
    
    UIView *bgContentView = [[UIView alloc]init];
    bgContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgContentView];
    [bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.mas_equalTo(headerView.mas_bottom).offset(10);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [bgContentView addSubview:titleLabel];
    titleLabel.text = @"查询结果:";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(bgContentView).offset(20);
    }];
    
    UITextView *contentLabel = [[UITextView alloc]init];
    [bgContentView addSubview:contentLabel];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:16.0];
    contentLabel.editable = NO;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(bgContentView).offset(20);
        make.right.bottom.equalTo(bgContentView).offset(-20);
    }];
    self.contentLab = contentLabel;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
