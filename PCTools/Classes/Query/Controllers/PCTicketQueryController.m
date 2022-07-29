//
//  PCTicketQueryController.m
//  PCTools
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCTicketQueryController.h"
#import "PCTicketQueryCell.h"

@interface PCTicketQueryController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *dataList;
@property(nonatomic,strong)UITextField *startPlaceTextField;
@property(nonatomic,strong)UITextField *endPlaceTextField;
@property(nonatomic,strong)UILabel *noDataLabel;

@end

@implementation PCTicketQueryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainBgColor;
    [self setupSubViews];
}
-(void)queryBtnAction{
    [self.startPlaceTextField resignFirstResponder];
    [self.endPlaceTextField resignFirstResponder];
    if(self.startPlaceTextField.text.length == 0){
        [CommonTool toastMessage:@"请输入出发地"];
        return;
    }
    if(self.endPlaceTextField.text.length == 0){
        [CommonTool toastMessage:@"请输入目的地"];
        return;
    }
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    [PCRequestTool postAllUrl:PCQueryStationUrl params:@{@"start":self.startPlaceTextField.text,@"end":self.endPlaceTextField.text} success:^(id responsebject) {
        [PNCGifWaitView hideWaitViewInController:self];
        [self.dataList removeAllObjects];
        if([responsebject[@"status"] isEqualToString:@"0000"]){
            NSArray *dataArr = responsebject[@"data"];
            [self.dataList addObjectsFromArray:dataArr];
        }
        [self.tableView reloadData];
        if(self.dataList.count>0){
            self.noDataLabel.hidden = YES;
        }else{
            self.noDataLabel.hidden = NO;
        }
    } failure:^(NSError *error) {
        [PNCGifWaitView hideWaitViewInController:self];
        [self.dataList removeAllObjects];
        [self.tableView reloadData];
        self.noDataLabel.hidden = NO;
    }];
}

-(NSMutableArray*)dataList{
    if(!_dataList){
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
-(void)setupSubViews{
    
    UIImageView*backImageView = [[UIImageView alloc]init];
    [self.view addSubview:backImageView];
    backImageView.backgroundColor = MainColor;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(87.5+PCNaviBarHeight);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"火车票查询";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:19.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PCStatusBarHeight);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, PCStatusBarHeight, 44,44);
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIView *headerBgView = [[UIView alloc]init];
    [self.view addSubview:headerBgView];
    headerBgView.backgroundColor = [UIColor whiteColor];
    headerBgView.layer.cornerRadius = 5;
    [headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(PCNaviBarHeight);
        make.height.mas_equalTo(150);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBgView addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(queryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerBgView).offset(-35);
        make.left.equalTo(headerBgView).offset(35);
        make.bottom.equalTo(headerBgView).offset(-23);
        make.height.mas_equalTo(45);
    }];
    
    UIImageView *iconIamgeView = [[UIImageView alloc]init];
    [headerBgView addSubview:iconIamgeView];
    iconIamgeView.image = [UIImage imageNamed:@"tuxing"];
    [iconIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerBgView).offset(0);
        make.top.equalTo(headerBgView).offset(25);
        make.width.height.mas_equalTo(30);
    }];
    CGFloat textFieldWidth = (kScreenW - 170)/2;
    for(NSInteger i=0 ;i<2 ;i++){
        UITextField *textField = [[UITextField alloc]init];
        [headerBgView addSubview:textField];
        textField.textColor = UIColorFromRGB(0x010101);
        textField.font = [UIFont systemFontOfSize:15];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeWebSearch;
        [textField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
        UIView *lineView = [[UIView alloc]init];
        [textField addSubview:lineView];
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeWebSearch;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        lineView.backgroundColor = UIColorFromRGB(0xa0a0a0);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(textField).offset(0);
            make.height.mas_equalTo(0.5);
        }];
        if(i == 0){
            textField.placeholder = @"请输入出发地";
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerBgView).offset(35);
                make.centerY.equalTo(iconIamgeView);
                make.width.mas_equalTo(textFieldWidth);
                make.height.mas_equalTo(45);
            }];
            self.startPlaceTextField = textField;
        }else{
            textField.placeholder = @"请输入目的地";
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headerBgView).offset(-35);
                make.centerY.equalTo(iconIamgeView);
                make.width.mas_equalTo(textFieldWidth);
                make.height.mas_equalTo(45);
            }];
            self.endPlaceTextField = textField;
        }
    }
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor =  [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PCTicketQueryCell class] forCellReuseIdentifier:@"PCTicketQueryCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(headerBgView.mas_bottom).offset(12);
        make.height.mas_equalTo(self.view.frame.size.height-PCNaviBarHeight-24 - 150);
    }];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.noDataLabel = [[UILabel alloc]init];
    [self.tableView addSubview:self.noDataLabel];
    self.noDataLabel.textColor = UIColorFromRGB(0xa0a0a0);
    self.noDataLabel.font = [UIFont systemFontOfSize:16];
    self.noDataLabel.text = @"暂无直达车次";
    self.noDataLabel.hidden = YES;
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView).offset(0);
        make.top.equalTo(self.tableView).offset(30);
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self queryBtnAction];
    return YES;
}
-(void)textFiledDidChange:(UITextField *)textField{
    if(textField.text.length>0){
        textField.font = [UIFont boldSystemFontOfSize:20];
    }else{
        textField.font = [UIFont systemFontOfSize:15];
    }
}
-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView*)tableView{
    if(!_tableView){
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}
#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCTicketQueryCell*cell = [tableView dequeueReusableCellWithIdentifier:@"PCTicketQueryCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictData = self.dataList[indexPath.section];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-40, 12)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
