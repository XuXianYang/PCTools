//
//  EUTMemorialDayController.m
//  EUTTools
//
//  Created by apple on 2020/1/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTMemorialDayController.h"
#import "EUTMemorialDayCell.h"
#import "EUTEditMemorialDayController.h"

@interface EUTMemorialDayController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *dataList;

@end

@implementation EUTMemorialDayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"纪念日";
    [self eutSetupSubViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *dataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MemorialDayData"];
    [self.dataList removeAllObjects];
    if(dataArr&&dataArr.count>0){
        [self.dataList addObjectsFromArray:dataArr];
    }
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//新建纪念日
-(void)eutQueryBtnAction{
    EUTEditMemorialDayController *editVC = [[EUTEditMemorialDayController alloc]init];
    editVC.pageType = EUTQueryXJJNRType;
    [self.navigationController pushViewController:editVC animated:YES];
}
-(NSMutableArray*)dataList{
    if(!_dataList){
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
-(void)eutSetupSubViews{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn setBackgroundImage:[UIImage imageNamed:@"textFieldLineBg"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"addBtnIcon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(eutQueryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(PCNaviBarHeight+20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW - 40);
        make.height.mas_equalTo(SP(45));
    }];
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor =  [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EUTMemorialDayCell class] forCellReuseIdentifier:@"EUTMemorialDayCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(btn.mas_bottom).offset(20);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
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
    EUTMemorialDayCell*cell = [tableView dequeueReusableCellWithIdentifier:@"EUTMemorialDayCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dictData = self.dataList[indexPath.section];
    return cell;
}
//编辑纪念日
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EUTEditMemorialDayController *editVC = [[EUTEditMemorialDayController alloc]init];
    editVC.dictData = self.dataList[indexPath.section];
    editVC.pageType = EUTQueryBJJNRType;
    [self.navigationController pushViewController:editVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-40, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
