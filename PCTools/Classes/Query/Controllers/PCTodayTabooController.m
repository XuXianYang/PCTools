//
//  PCTodayTabooController.m
//  PCTools
//
//  Created by apple on 2019/12/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCTodayTabooController.h"
#import "PCLifeLocationCell.h"
#import "PCTodayTabooCell.h"

@interface PCTodayTabooController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,retain)NSMutableArray*dataList;

@end

@implementation PCTodayTabooController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日禁忌";
    [self setupSubViews];
    [self queryAction];
}
-(void)queryAction{
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    [PCRequestTool postAllUrl:PCQueryCalendarUrl params:@{@"date":[CommonTool getCurrentTimesWithFormatter:@"YYYY-MM-dd"]} success:^(id responsebject) {
        [PNCGifWaitView hideWaitViewInController:self];
        if([responsebject[@"status"] isEqualToString:@"0000"]){
            [self.dataList removeAllObjects];
            NSDictionary *dict = responsebject[@"data"];
            [self.dataList addObjectsFromArray:@[
                 @{@"title":@"阳历",@"content":[CommonTool safeString:dict[@"date"]]},
                 @{@"title":@"农历",@"content":[CommonTool safeString:dict[@"lunar"]]},
                 @{@"title":@"节假日",@"content":[CommonTool safeString:dict[@"lunarYear"]]},
                 @{@"title":@"属相",@"content":[CommonTool safeString:dict[@"zodiac"]]},
                 @{@"title":@"宜",@"content":[CommonTool safeString:dict[@"suit"]]},
                 @{@"title":@"忌",@"content":[CommonTool safeString:dict[@"avoid"]]}]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [PNCGifWaitView hideWaitViewInController:self];
    }];
}
-(NSMutableArray*)dataList{
    if(!_dataList){
        _dataList = [NSMutableArray arrayWithArray:@[@{@"title":@"阳历",@"content":@""},
                            @{@"title":@"农历",@"content":@""},
                          @{@"title":@"节假日",@"content":@""},
                        @{@"title":@"属相",@"content":@""},
                        @{@"title":@"宜",@"content":@""},
                        @{@"title":@"忌",@"content":@""}]];
    }
    return _dataList;
}
-(void)btnAction{
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.dataList) {
        if([dict[@"content"] length]>0){
            [stringArray addObject:[NSString stringWithFormat:@"%@:%@",dict[@"title"],dict[@"content"]]];
        }
    }
    NSString *string = [stringArray componentsJoinedByString:@"\n"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    [CommonTool toastMessage:@"复制成功"];
}
-(void)setupSubViews{
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor =  [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PCLifeLocationCell class] forCellReuseIdentifier:@"PCLifeLocationCell"];
    [self.tableView registerClass:[PCTodayTabooCell class] forCellReuseIdentifier:@"PCTodayTabooCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(PCNaviBarHeight);
        make.height.mas_equalTo(self.view.frame.size.height-PCNaviBarHeight);
    }];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight=10;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn addTarget: self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"一键复制" forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(footerView);
        make.width.mas_equalTo(kScreenW - 40);
        make.height.mas_equalTo(45);
    }];
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
    if(indexPath.row>3){
        PCTodayTabooCell*cell = [tableView dequeueReusableCellWithIdentifier:@"PCTodayTabooCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleStr = self.dataList[indexPath.row][@"title"];
        cell.contentStr = self.dataList[indexPath.row][@"content"];
        return cell;
    }else{
        PCLifeLocationCell*cell = [tableView dequeueReusableCellWithIdentifier:@"PCLifeLocationCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleStr = self.dataList[indexPath.row][@"title"];
        cell.contentStr = self.dataList[indexPath.row][@"content"];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >3){
        return 90;
    }
    return 40;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
