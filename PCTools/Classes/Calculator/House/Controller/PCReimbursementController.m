#import "PCReimbursementController.h"
#import "PCReimbursementCell.h"
#import "PCCalculatorTool.h"

@interface PCReimbursementController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headBottomView;
@property (nonatomic, strong) UIView *huankuanDetailView;
@property (nonatomic, copy) NSArray *benxiArray;
@property (nonatomic, copy) NSArray *benjinArray;
@property (nonatomic, strong) UISegmentedControl *segment;

@end

@implementation PCReimbursementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MainBgColor;
    self.title = @"还款详情";
    int times = [[PCCalculatorProperty shareCalculator].daikuannianxianString intValue];
    [PCCalculatorProperty shareCalculator].calcuTime = times * 12;
    if (self.reimbursementIndex == 0) {
        [PCCalculatorTool equalPrincipalAndInterest];
    }else {
        [PCCalculatorTool averageCapital];

    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [PCCalculatorProperty shareCalculator].calcuTime = 0;
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self setupReimbursementHeaderView];
    [self setupReimbursementDetailView];
    [self setupTableView];
}
- (void)setupTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 173 + 40 + PCNaviBarHeight, kScreenW, kScreenH - 173 - 40 - PCNaviBarHeight)];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PCReimbursementCell class] forCellReuseIdentifier:@"repayCell"];
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)setupReimbursementHeaderView {
    self.headBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, PCNaviBarHeight, kScreenW, 173)];
    self.headBottomView.backgroundColor = MainColor;
    [self.view addSubview:self.headBottomView];

    NSArray *array = @[@"等额本息",@"等额本金"];
    
    self.segment = [[UISegmentedControl alloc]initWithItems:array];
    self.segment.frame = CGRectMake((kScreenW - 200) / 2, 15, 200, 32);
    
    // 设置整体的色调
    self.segment.tintColor = [UIColor whiteColor];
    
    // 设置分段名的字体
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName ,nil];
    [self.segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    // 设置初始选中项
    self.segment.selectedSegmentIndex = self.reimbursementIndex;
    [self.segment addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
    [_headBottomView addSubview:self.segment];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headBottomView.frame) - PCNaviBarHeight, kScreenW, 40)];
    titleView.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    NSArray *titleArray = [NSArray arrayWithObjects:@"月份", @"月供本金", @"月供利息", @"剩余", nil];
    int width = kScreenW / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, 40)];
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = MainColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        [titleView addSubview:label];
    }
    [_headBottomView addSubview:titleView];
}
//总还款 总利息 总贷款  贷款月数 等信息
- (void)setupReimbursementDetailView {

    if (self.huankuanDetailView) {
        [self.huankuanDetailView removeFromSuperview];
    }
    self.huankuanDetailView = [[UIView alloc]initWithFrame:CGRectMake(0,  15 + 32 + 20, kScreenW, 173 - 15 - 32 - 20)];
    [self.headBottomView addSubview:self.huankuanDetailView];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    int width = (kScreenW - 1.5) / 4;
    int height = (173 - 15 - 32 - 20) / 2;
    //总还款
    UIView *zonghuankuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    UILabel *zonghuankuanLabel  = [[UILabel alloc]initWithFrame:CGRectMake((width - 60) / 2, 0, 60, 11.5)];
    zonghuankuanLabel.text = @"总还款(万)";
    zonghuankuanLabel.font = [UIFont systemFontOfSize:10];
    zonghuankuanLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    zonghuankuanLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    [zonghuankuanView addSubview:zonghuankuanLabel];
    UILabel *ZHKMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 11.5 + 10.5, width , 15)];
    ZHKMoneyLabel.textAlignment = NSTextAlignmentCenter;

    double ZH = [[PCCalculatorProperty shareCalculator].huankuanzongeString doubleValue] /10000.0;

    if (ZH > 1000.0) {
        ZHKMoneyLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",ZH] doubleValue]]];
    }else {
        ZHKMoneyLabel.text = [NSString stringWithFormat:@"%.2f",ZH];
    }
    ZHKMoneyLabel.font = [UIFont systemFontOfSize:10];
    ZHKMoneyLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    ZHKMoneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16.8];
    [zonghuankuanView addSubview:ZHKMoneyLabel];
    //总利息
    UIView *zongliixView = [[UIView alloc]initWithFrame:CGRectMake(width + 0.5, 0, width, height)];
    UILabel *zonglixiLabel  = [[UILabel alloc]initWithFrame:CGRectMake((width - 60) / 2, 0, 60, 11.5)];
    zonglixiLabel.text = @"总利息(万)";
    zonglixiLabel.font = [UIFont systemFontOfSize:12];
    zonglixiLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    zonglixiLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    [zongliixView addSubview:zonglixiLabel];
    UILabel *ZLXMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 11.5 + 10.5, width , 15)];
    double zonglixi  = [[PCCalculatorProperty shareCalculator].zongzhifulixiString doubleValue] / 10000.0;
    if (zonglixi > 1000.0) {
        ZLXMoneyLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",zonglixi] doubleValue]]];
    }else {

        ZLXMoneyLabel.text = [NSString stringWithFormat:@"%.2f",zonglixi];
    }

    ZLXMoneyLabel.font = [UIFont systemFontOfSize:10];
    ZLXMoneyLabel.textAlignment = NSTextAlignmentCenter;
    ZLXMoneyLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    ZLXMoneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16.8];
    [zongliixView addSubview:ZLXMoneyLabel];
    //总贷款
    UIView *zongdaikuanView = [[UIView alloc]initWithFrame:CGRectMake(2 * (width + 0.5), 0, width, height)];
    UILabel *zongdaikuanLabel  = [[UILabel alloc]initWithFrame:CGRectMake((width - 60) / 2, 0, 60, 11.5)];
    zongdaikuanLabel.text = @"总贷款(万)";
    zongdaikuanLabel.font = [UIFont systemFontOfSize:12];
    zongdaikuanLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    zongdaikuanLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    [zongdaikuanView addSubview:zongdaikuanLabel];
    UILabel *ZDKMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 11.5 + 10.5, width , 12.5)];
    if ([PCCalculatorProperty shareCalculator].gongjijindaikuanString.length != 0) {
        ZDKMoneyLabel.text =  [NSString stringWithFormat:@"%.2f",([[PCCalculatorProperty shareCalculator].daikuanzongshuString doubleValue] + [[PCCalculatorProperty shareCalculator].gongjijindaikuanString doubleValue])] ;

    }else {

        ZDKMoneyLabel.text = [PCCalculatorProperty shareCalculator].daikuanzongshuString;
    }
    ZDKMoneyLabel.font = [UIFont systemFontOfSize:14];
    ZDKMoneyLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    ZDKMoneyLabel.textAlignment = NSTextAlignmentCenter;
    ZDKMoneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16.8];
    [zongdaikuanView addSubview:ZDKMoneyLabel];
    //贷款月数
    UIView *daikuanyueshuView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW - width, 0, width, height)];
    UILabel *daikuanyueshuLabel  = [[UILabel alloc]initWithFrame:CGRectMake((width - 50) / 2, 0, 50, 11.5)];
    daikuanyueshuLabel.text = @"贷款月数";
    daikuanyueshuLabel.textAlignment = NSTextAlignmentCenter;
    daikuanyueshuLabel.font = [UIFont systemFontOfSize:12];
    daikuanyueshuLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    daikuanyueshuLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    [daikuanyueshuView addSubview:daikuanyueshuLabel];
    UILabel *DKYSMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 11.5 + 10.5, width , 12.5)];

    int numberOfMouth = [[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] * 12;
    DKYSMoneyLabel.text = [NSString stringWithFormat:@"%d",numberOfMouth] ;
    DKYSMoneyLabel.font = [UIFont systemFontOfSize:14];
    DKYSMoneyLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    DKYSMoneyLabel.textAlignment = NSTextAlignmentCenter;
    DKYSMoneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16.8];
    [daikuanyueshuView addSubview:DKYSMoneyLabel];
    //固定还款数额参考
    UIView *gudingView = [[UIView alloc]initWithFrame:CGRectMake(0, height, kScreenW, height)];
    UILabel *gudingabel  = [[UILabel alloc]init];

    if (self.segment.selectedSegmentIndex == 0) {
        gudingabel.frame = CGRectMake(17.5, (height - 10) / 2, 128, 15);
        gudingabel.text = @"固定还款数额参考(元):";
    }
    else {
        gudingabel.frame = CGRectMake(17.5, (height - 10) / 2, 76.5, 15);
        gudingabel.text = @"每月递减(元):";
    }
    gudingabel.font = [UIFont systemFontOfSize:10];
    gudingabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    gudingabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    [gudingView addSubview:gudingabel];
    UILabel *GDMoneylabel  = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(gudingabel.frame) + 10, (height - 20.5) / 2, 190, 25)];
    if (self.segment.selectedSegmentIndex == 0) {//规定还款数额
        if ([[PCCalculatorProperty shareCalculator].gudinghuankuanString doubleValue] > 1000.0) {
            GDMoneylabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[PCCalculatorProperty shareCalculator].gudinghuankuanString doubleValue]]];

        }else {

            GDMoneylabel.text = [PCCalculatorProperty shareCalculator].gudinghuankuanString;
        }

    }else { //每月递减   每月所交利息递减
        if ([[PCCalculatorProperty shareCalculator].yueGongDiJian doubleValue] > 1000.0) {
            GDMoneylabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[PCCalculatorProperty shareCalculator].yueGongDiJian doubleValue]]];

        }else {
            GDMoneylabel.text = [PCCalculatorProperty shareCalculator].yueGongDiJian;
        }
    }
//    GDMoneylabel.text = array[4];
    GDMoneylabel.font = [UIFont systemFontOfSize:13];
    GDMoneylabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    GDMoneylabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:27];
    [gudingView addSubview:GDMoneylabel];
    
    //white  line
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(width, 15 + 32 + 20, 0.5, 35)];
    leftLine.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    UIView *middleLine = [[UIView alloc]initWithFrame:CGRectMake(width * 2 + 0.5, 15 + 32 + 20, 0.5, 35)];
    middleLine.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(width * 3 + 0.5 * 2, 15 + 32 + 20, 0.5, 35)];
    rightLine.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    [self.headBottomView addSubview:leftLine];
    [self.headBottomView addSubview:middleLine];
    [self.headBottomView addSubview:rightLine];
    [self.huankuanDetailView addSubview:zonghuankuanView];
    [self.huankuanDetailView addSubview:zongliixView];
    [self.huankuanDetailView addSubview:zongdaikuanView];
    [self.huankuanDetailView addSubview:daikuanyueshuView];
    [self.huankuanDetailView addSubview:gudingView];
}
- (void)selectItem:(UISegmentedControl *)control {
        if (control.selectedSegmentIndex == 0) {
            [PCCalculatorTool  equalPrincipalAndInterest];
            [self setupReimbursementDetailView];
        }else{
            [PCCalculatorTool averageCapital];
            [self setupReimbursementDetailView];
        }
    [self.tableView reloadData];
}
#pragma tableView delegate and dataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCReimbursementCell *rateCell  = [tableView dequeueReusableCellWithIdentifier:@"repayCell" forIndexPath:indexPath];
    rateCell.selectionStyle = UITableViewCellSelectionStyleNone;

    rateCell.monethLabel.text = [NSString stringWithFormat:@"%ld月",(long)indexPath.row + 1];
        rateCell.principalLabel.text = [PCCalculatorProperty shareCalculator].dengebenxiArray[indexPath.row * 3 + indexPath.section * 36];
        rateCell.interestLabel.text = [PCCalculatorProperty shareCalculator].dengebenxiArray[indexPath.row * 3 + 1 + indexPath.section * 36];
        rateCell.residueLabel.text = [PCCalculatorProperty shareCalculator].dengebenxiArray[indexPath.row * 3 + 2 + indexPath.section * 36];
    return rateCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [PCCalculatorProperty shareCalculator].dengebenxiArray.count / 12 / 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
//tableView  header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    headView.backgroundColor = MainBgColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(9, 14, 62.5, 11.5)];
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = COLOR_RGB_0X(0x000000);
    [headView  addSubview:label];
    label.text = [NSString stringWithFormat:@"第%ld年",(long)section + 1];
    return headView;
}
@end
