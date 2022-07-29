#import "PCHouseRateController.h"

@interface PCHouseRateController ()

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) UIScrollView *bgView;
@end

@implementation PCHouseRateController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainBgColor;
    self.title = @"利率表";
    self.dataList = [NSArray arrayWithObjects: @"5年以上", @"4.90", @"3.35", @"3-5年(含)", @"4.75", @"2.75", @"1-3年(含)", @"4.75", @"2.75",@"1年", @"4.35", @"2.75" ,@"6个月" , @"4.35" ,@"2.75", nil];
    [self setupBgScrollView];
    [self setupTopView];
    [self setupTextViews];
}
- (void)setupBgScrollView  {
    self.bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64)];
    self.bgView.backgroundColor =UIColorFromRGB(0xF2F2F2);
    self.bgView.showsVerticalScrollIndicator = NO;
    self.bgView.showsHorizontalScrollIndicator = NO;
        self.bgView.contentSize = CGSizeMake(kScreenW, 40 * 6 + 0.5 * 5 + 220 + 10.5 + 10.5 + 20.5 + 25);
     [self.view addSubview:self.bgView];
}

- (void)setupTopView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    headerView.backgroundColor = MainColor;
    [self.bgView addSubview:headerView];
    NSArray *array = [NSArray arrayWithObjects:@"贷款期限", @"商业贷款(%)", @"公积金贷款(%)", nil];
    for (int i = 0; i < 3; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake( i * kScreenW / 3, 0, kScreenW / 3, 40)];
        label.text = array[i];
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = COLOR_RGB_0X(0xFFFFFF);
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
    }
}
- (void)setupTextViews {
    int width = (kScreenW - 1) / 3;
    int height = (200 - 2) / 5;
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 3; j++) {
             UIView *view = [[UIView alloc]init];
            UILabel *label = [[UILabel alloc]init];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = COLOR_RGB_0X(0x666666);
            label.font = [UIFont systemFontOfSize:13];
            label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
            view.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
            
            view.frame = CGRectMake((width + 0.5) * j,  40 +  (height + 0.5) * i, width, height);
            label.frame = CGRectMake(0, 14, width , 12.5);
            [view addSubview:label];
            label.text = self.dataList[j + 3 * i];
            [self.bgView addSubview:view];
        }
    }
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0,  40 + 200, kScreenW, 25)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, kScreenW - 16, 10.5)];
    label.font = [UIFont systemFontOfSize:11];
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    firstView.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    label.textColor = COLOR_RGB_0X(0x999999);
    label.text = @"以上为央行2019年最新公布贷款的贷款基准利率";
    [firstView addSubview:label];
    
    [self.bgView addSubview:firstView];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(firstView.frame) + 20.5, kScreenW - 16, 10.5)];
    messageLabel.font = [UIFont systemFontOfSize:11];
    messageLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    messageLabel.textColor = COLOR_RGB_0X(0x000000);
    messageLabel.text = @"基准利率与执行利率的区别";
    [self.bgView addSubview:messageLabel];


    UILabel *differentLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.5, CGRectGetMaxY(messageLabel.frame) + 10.5, kScreenW - 16.5 - 16.5, 220)];
    NSString *stringF = @"基准利率是央行发布给商业银行的存贷款的指导性利率，是央行用于调节社会经济和金融体系运转的货币政策之一。商业银行贷款利率在基准利率基础上做浮动，具体贷款执行的利率，不一定是基准利率。不同银行、不同贷款产品、不同借款人的贷款利率都可能不同的，银行执行的贷款利率通常高于央行制定的基准利率。";
    NSString *stringM = @"银行贷款利率表是根据贷款对象的信用情况、抵押物、国家政策(是否首套房)等来确定贷款利率水平，如果各方面评价良好，不同银行执行的房贷利率有所差别，除信用社外，央行对多数商业银行的贷款利率并没有上限限制，相反有贷款利率下限规定，依据央行关于调整存贷款利率浮动区间通知，个人住房贷款利率浮动区间的下限为基准利率的0.7倍。";
    NSString *stringL = @"现公积金贷款基准利率是2015年10月24日调整并实施的，由于资金紧张等原因，部分银行首套住房公积金贷款利率为基准利率的1.1倍。";
    differentLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",stringF, stringM, stringL];
    differentLabel.numberOfLines = 0;
    differentLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    differentLabel.font = [UIFont systemFontOfSize:11];
    differentLabel.textColor = COLOR_RGB_0X(0x999999);
    [self.bgView addSubview:differentLabel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
