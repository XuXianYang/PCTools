#import "PCHouseViewController.h"
#import "PCReimbursementController.h"
#import "PCHouseRateController.h"

#import "PCCalculatorTool.h"
#import "PCCalculatorProperty.h"

#import "PCStringPickerView.h"
#import "PCBaseTextField.h"

@interface PCHouseViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) UIView *bigBottomView;
@property (nonatomic, strong) UIView *inforBigView;//显示 首月月供、月末月供、利息 、总额等信息的底部视图
@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) UIView *qixianView;//贷款期限
@property (nonatomic, strong) UIView *lilvView;//利率%
@property (nonatomic, strong) UIView *gongjijindaikuanjineView;
@property (nonatomic, strong) UIView *gongjijinlilvView;
@property (nonatomic, strong) UIView *daikuanleixingView;
@property (nonatomic, strong) UIView *daikuanjineView;


@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *huankuanxiangqingView;

@property (nonatomic, strong) UITextField *daikuanjineField;
@property (nonatomic, strong) UITextField *gongjijindaikuanField;

@property (nonatomic, strong) NSString *daikuanjineFieldString;
@property (nonatomic, strong) NSString *gongjijindaikuanFieldString;

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@property (nonatomic, strong) UIButton *daikuanTypeButton;
@property (nonatomic, strong) UIButton *loanTimeButton;
@property (nonatomic, strong) UIButton *lilvButton;
@property (nonatomic, strong) UIButton *gongjijinButton;

@property (nonatomic, strong) UIView *keyboardDoneBgView;

@end

@implementation PCHouseViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainBgColor;
    self.navigationItem.title  = @"房贷计算器";
    [self initPageData];
    [self setupNavigationItemButton];
    [self setupBgScrollView];//添加底部滑动视图
    [self setupRepaymentDetailView];//添加还款详情
    [self setupSegmentAndBottomView];//分栏控制相关视图
    [self setupDifferentTypeView];//添加类型 年限 利率等视图
    [self setupFooterMessageView];//添加底部说明视图
    [self setupKeyBoardBgView];
}
-(void)initPageData{
    //设置初始年限 两种贷款利率
    [PCCalculatorProperty shareCalculator].daikuannianxianString = @"5";
    [PCCalculatorProperty shareCalculator].daikuanlilvString = @"4.75";
    [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = @"2.75";
    [PCCalculatorProperty shareCalculator].DAIKUANTYPE = @"商业贷款";
    [PCCalculatorProperty shareCalculator].calcuTime = 0;
}
//键盘将要出现
-(void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    CGFloat marginHeight = kScreenH - PCNaviBarHeight - 210 -55*4 - height-40;
    if(marginHeight <0){
        self.scrollView.contentOffset = CGPointMake(0, -marginHeight);
    }
}
//键盘将要出现
-(void)keyboardDidShow:(NSNotification *)notification {
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    [self.keyboardDoneBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(APPDELEGATE.window).offset(-height);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
//键盘将要消失
-(void)keyboardWillHidden:(NSNotification *)notification {
    [self.keyboardDoneBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(APPDELEGATE.window).offset(40);
    }];
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)btnAction{
    [self.daikuanjineField resignFirstResponder];
    [self.gongjijindaikuanField resignFirstResponder];
}
-(void)setupKeyBoardBgView{
    UIView *bgView  = [[UIView alloc]init];
    bgView.backgroundColor = MainBgColor;
    [APPDELEGATE.window addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(APPDELEGATE.window);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(APPDELEGATE.window).offset(40);
    }];
    self.keyboardDoneBgView = bgView;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget: self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-20);
        make.centerY.equalTo(bgView);
    }];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
- (void)setupBgScrollView {
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,  64, kScreenW, kScreenH )];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    if (kScreenH < 667) {
        self.scrollView.contentSize = CGSizeMake(kScreenW, 210 + 55 * 6 + 64);
    }else {
        self.scrollView.contentSize  = CGSizeMake(kScreenW, kScreenH );
    }
    [self.view addSubview:self.scrollView];
}
- (void)setupSegmentAndBottomView {
    if (self.bigBottomView) {
        [self.bigBottomView removeFromSuperview];
    }
    self.bigBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 210)];
    self.bigBottomView.backgroundColor = MainColor;
    [self.scrollView addSubview:self.bigBottomView];//蓝色的视图
    [self setupSegmentControl];
    [self setupRepaymentMoneyDetailView];
}
- (void)setupSegmentControl {
    NSArray *array = @[@"等额本息",@"等额本金"];
    if (self.segment) {
        [self.segment removeFromSuperview];
    }
    self.segment = [[UISegmentedControl alloc]initWithItems:array];
    self.segment.frame = CGRectMake((kScreenW - 200) / 2, 15, 200, 32);
    // 设置整体的色调
    self.segment.tintColor = [UIColor whiteColor];
    // 设置分段名的字体
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x000000),NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName ,nil];
    [self.segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    // 设置初始选中项
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
    [self.bigBottomView addSubview:self.segment];
}
- (void)setupRepaymentMoneyDetailView {

    if (self.inforBigView) {
        [self.inforBigView removeFromSuperview];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    self.inforBigView = [[UIView alloc]initWithFrame:CGRectMake(0,  32 + 15 + 22, kScreenW, 210 - 15 - 32 - 22)];
    self.bigBottomView.backgroundColor = MainColor;
    [self.bigBottomView addSubview:self.inforBigView];

    int width = (kScreenW - 0.5) / 2;
    int height = self.inforBigView.frame.size.height / 2;
    //每月月供参考
    UIView *meiYueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 0, width - 16.5, 12.5)];
    label.text = (self.segment.selectedSegmentIndex == 0) ? @"每月月供参考(元)" : @"首月月供参考(元)";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = COLOR_RGB_0X(0xFEFEFE);
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [meiYueView addSubview:label];
    UILabel *meiyueMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 12.5 + 10, width - 16.5, 20.5)];
    if ([label.text isEqualToString:@"每月月供参考(元)"]) {
        if ([PCCalculatorProperty shareCalculator].meiyueyuegongString.length == 0) {
            meiyueMoneyLabel.text = @"0.00";
        }else {
            if ([[PCCalculatorProperty shareCalculator].meiyueyuegongString doubleValue] > 1000.0) {
                meiyueMoneyLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[PCCalculatorProperty shareCalculator].meiyueyuegongString doubleValue]]];
            }else {
                meiyueMoneyLabel.text = [PCCalculatorProperty shareCalculator].meiyueyuegongString;
            }
        }
    }else {

        if ([PCCalculatorProperty shareCalculator].shouyueyuegongString.length == 0) {
            meiyueMoneyLabel.text = @"0.00";
        }else {
            if ([[PCCalculatorProperty shareCalculator].shouyueyuegongString doubleValue] > 1000.0) {
                meiyueMoneyLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[PCCalculatorProperty shareCalculator].shouyueyuegongString doubleValue]]];
            }else {
                meiyueMoneyLabel.text = [PCCalculatorProperty shareCalculator].shouyueyuegongString;
            }
        }
    }

    meiyueMoneyLabel.font = [UIFont systemFontOfSize:22];
    meiyueMoneyLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    meiyueMoneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:22];
    [meiYueView addSubview:meiyueMoneyLabel];
    
    //月末月供供参考(hide  show)
    UIView *yueMoView = [[UIView alloc]initWithFrame:CGRectMake(width + 0.5, 0, width, height)];
    //    yueMoView.backgroundColor = [UIColor redColor];
    UILabel *yuelabel  = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 0, width - 16.5, 12.5)];
    yuelabel.text = @"末月月供参考(元)";
    yuelabel.font = [UIFont systemFontOfSize:13];
    yuelabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    yuelabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [yueMoView addSubview:yuelabel];
    UILabel *yueMoMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 12.5 + 10, width - 16.5, 20.5)];
#pragma warn 月末的计算

    if ([PCCalculatorProperty shareCalculator].yuemoyuegongString.length == 0) {
        yueMoMoneyLabel.text = @"0.00";
    }else {
        if ([[PCCalculatorProperty shareCalculator].yuemoyuegongString doubleValue] > 1000.0) {
            
            yueMoMoneyLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[PCCalculatorProperty shareCalculator].yuemoyuegongString doubleValue]]];
        }else {
           yueMoMoneyLabel.text = [PCCalculatorProperty shareCalculator].yuemoyuegongString;
        }

    }
    yueMoMoneyLabel.font = [UIFont systemFontOfSize:22];
    yueMoMoneyLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    yueMoMoneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:22];
    [yueMoView addSubview:yueMoMoneyLabel];

    //总支付利息
    UIView *rateView = [[UIView alloc]initWithFrame:CGRectMake(0, height, width, height)];
    UILabel *ratelabel  = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 0, width - 16.5, 12.5)];
    ratelabel.text = @"总支付利息(元)";
    ratelabel.font = [UIFont systemFontOfSize:13];
    ratelabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    ratelabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [rateView addSubview:ratelabel];
    UILabel *rateMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 12.5 + 10, width - 16.5, 20.5)];

    if ([PCCalculatorProperty shareCalculator].zongzhifulixiString.length == 0) {
        rateMoneyLabel.text = @"0.00" ;
    }else {
        if ([[PCCalculatorProperty shareCalculator].zongzhifulixiString doubleValue] > 1000.0) {
            rateMoneyLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[PCCalculatorProperty shareCalculator].zongzhifulixiString doubleValue]]];
        }else {
            rateMoneyLabel.text = [PCCalculatorProperty shareCalculator].zongzhifulixiString;
        }
    }

    rateMoneyLabel.font = [UIFont systemFontOfSize:14];
    rateMoneyLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    rateMoneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:20];
    [rateView addSubview:rateMoneyLabel];
    
    //还款总额
    UIView *totalView = [[UIView alloc]initWithFrame:CGRectMake(width + 0.5, height, width, height)];
    UILabel *totalLabel  = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 0, width - 16.5, 12.5)];
    totalLabel.text = @"还款总额(元)";
    totalLabel.font = [UIFont systemFontOfSize:13];
    totalLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    totalLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [totalView addSubview:totalLabel];
    UILabel *totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 12.5 + 10, width - 16.5, 20.5)];

    if ([PCCalculatorProperty shareCalculator].huankuanzongeString == nil) {
        totalMoneyLabel.text = @"0.00";
    }else {
        if ([[PCCalculatorProperty shareCalculator].huankuanzongeString  doubleValue] > 1000.0) {
            totalMoneyLabel.text =  [formatter stringFromNumber:[NSNumber numberWithDouble:[[PCCalculatorProperty shareCalculator].huankuanzongeString  doubleValue]]];
        }else {
          totalMoneyLabel.text = [PCCalculatorProperty shareCalculator].huankuanzongeString;
        }
    }
    totalMoneyLabel.font = [UIFont systemFontOfSize:14];
    totalMoneyLabel.textColor = COLOR_RGB_0X(0xFEFEFE);
    totalMoneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:20];
    [totalView addSubview:totalMoneyLabel];
    
    UIView *upLineView = [[UIView alloc]initWithFrame:CGRectMake(width, 0, 0.5, 40)];
    upLineView.backgroundColor = [UIColor whiteColor];
    UIView *downLineView = [[UIView alloc]initWithFrame:CGRectMake(width, height, 0.5, 40)];
    downLineView.backgroundColor = [UIColor whiteColor];
    if (self.segment.selectedSegmentIndex == 0) {
    }else {
        [self.inforBigView addSubview:yueMoView];
        [self.inforBigView addSubview:upLineView];
    }
    [self.inforBigView addSubview:meiYueView];
    [self.inforBigView addSubview:rateView];
    [self.inforBigView addSubview:totalView];
    [self.inforBigView addSubview:downLineView];
}
- (void)setupDifferentTypeView {
    //贷款类型
    if (self.daikuanleixingView) {
        [self.daikuanleixingView  removeFromSuperview];
    }
    _daikuanleixingView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55 , kScreenW, 55 )];
    UITapGestureRecognizer *daikuanleixingTap = [[UITapGestureRecognizer alloc]init];
    [daikuanleixingTap addTarget:self action:@selector(tapMaturityTypeAction)];
    [self.daikuanleixingView addGestureRecognizer:daikuanleixingTap];
    _daikuanleixingView.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    UILabel *daikuanleiixngLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.5, 20, 62.5, 14.5)];
    daikuanleiixngLabel.text = @"贷款类型";
    daikuanleiixngLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    daikuanleiixngLabel.font = [UIFont systemFontOfSize:15];
    daikuanleiixngLabel.textColor = COLOR_RGB_0X(0x000000);
    [_daikuanleixingView addSubview:daikuanleiixngLabel];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 19.9 - 8.3, 20, 8.3, 15.15)];
    imageView.image = [UIImage imageNamed:@"moreIcon"];
    [_daikuanleixingView addSubview:imageView];

    self.daikuanTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.daikuanTypeButton.frame = CGRectMake(kScreenW - 17.2 - 8.3 - 16 - 80, 20, 80, 14.5);


    NSString *string = [PCCalculatorProperty shareCalculator].DAIKUANTYPE;
    if (string.length != 0) {
        [self.daikuanTypeButton setTitle:string forState:UIControlStateNormal];

    }else {
        [self.daikuanTypeButton setTitle:@"商业贷款" forState:UIControlStateNormal];

    }
    [self.daikuanTypeButton setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];
    self.daikuanTypeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.daikuanTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.daikuanTypeButton addTarget:self action:@selector(tapChangeLoansType:) forControlEvents:UIControlEventTouchUpInside];
    [_daikuanleixingView  addSubview:self.daikuanTypeButton];

    [self.scrollView addSubview:_daikuanleixingView];
    //贷款金额
    if (self.daikuanjineView) {
        [self.daikuanjineView  removeFromSuperview];
    }
    _daikuanjineView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55 + 0.5 + 55 , kScreenW, 55 )];
    UITapGestureRecognizer *daikuanjineTapFiled = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(daikuanjineTapAction)];
    [_daikuanjineView addGestureRecognizer:daikuanjineTapFiled];
    _daikuanjineView.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    UILabel *daikuanjineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.5, 20, 62.5, 14.5)];
    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {
            daikuanjineLabel.text = @"商贷金额";

    }else {
        daikuanjineLabel.text = @"贷款金额";

    }
    daikuanjineLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    daikuanjineLabel.font = [UIFont systemFontOfSize:15];
    daikuanjineLabel.textColor = COLOR_RGB_0X(0x000000);
    [_daikuanjineView addSubview:daikuanjineLabel];
    UILabel *labelO = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 17.5 - 14, 21.5, 14, 13)];
    labelO.text = @"万";
    labelO.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    labelO.font = [UIFont systemFontOfSize:15];
    labelO.textColor = COLOR_RGB_0X(0x666666);
    [_daikuanjineView addSubview:labelO];
    self.daikuanjineField = [[PCBaseTextField alloc]init];
    self.daikuanjineField.frame = CGRectMake(kScreenW - 14 - 17.5 - 10.5 - 100, 20, 100, 14.5);
    self.daikuanjineField.delegate  =  self;
    
    self.daikuanjineField.placeholder = @"请输入金额";
    if (self.daikuanjineFieldString.length != 0) {
        self.daikuanjineField.text = self.daikuanjineFieldString;
    }
    self.daikuanjineField.font = [UIFont systemFontOfSize:15];
    self.daikuanjineField.textColor = COLOR_RGB_0X(0x666666);
    self.daikuanjineField.textAlignment = NSTextAlignmentRight;
    self.daikuanjineField.keyboardType = UIKeyboardTypeDecimalPad;
    self.daikuanjineField.returnKeyType = UIReturnKeyDone;
    [_daikuanjineView  addSubview:self.daikuanjineField];
    [self.scrollView addSubview:_daikuanjineView];
    //期限(年)

    if (self.qixianView) {
        [self.qixianView  removeFromSuperview];
    }
    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {
          _qixianView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55 + (0.5 + 55) * 3, kScreenW, 55 )];
    }else {
        _qixianView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55 + (0.5 + 55) * 2, kScreenW, 55 )];
    }
    UITapGestureRecognizer *daikuanjineTap = [[UITapGestureRecognizer alloc]init];
    [daikuanjineTap addTarget:self action:@selector(tapLengthOfMaturityAction)];
    [self.qixianView addGestureRecognizer:daikuanjineTap];
    _qixianView.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    UILabel *qixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.5, 20, 62.5, 14.5)];
    qixianLabel.text = @"期限(年)";
    qixianLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    qixianLabel.font = [UIFont systemFontOfSize:15];
    qixianLabel.textColor = COLOR_RGB_0X(0x000000);
    [_qixianView addSubview:qixianLabel];

    UIImageView *imageViewT = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 19.9 - 8.3, 20, 8.3, 15.15)];
    imageViewT.image = [UIImage imageNamed:@"moreIcon"];
    [_qixianView addSubview:imageViewT];
    self.loanTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loanTimeButton.frame = CGRectMake(kScreenW - 19.9 - 8.3 - 16 - 62.5, 20, 62.5, 14.5);

    NSString *yearString = [PCCalculatorProperty shareCalculator].daikuannianxianString;

    if (yearString.length != 0) {
        [self.loanTimeButton setTitle:yearString forState:UIControlStateNormal];
    }else {
        [self.loanTimeButton setTitle:@"5" forState:UIControlStateNormal];
    }

    [self.loanTimeButton setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];
    self.loanTimeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.loanTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.loanTimeButton addTarget:self action:@selector(tapChangeTimeLimit:) forControlEvents:UIControlEventTouchUpInside];
    [_qixianView  addSubview:self.loanTimeButton];
    [self.scrollView addSubview:_qixianView];

    //利率(%)
    if (self.lilvView) {
        [self.lilvView  removeFromSuperview];
    }
    UILabel *lilvLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.5, 20, 100, 14.5)];

    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {
         _lilvView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55  + (0.5 + 55) * 4, kScreenW, 55 )];
            lilvLabel.text = @"商贷利率(%)";

    }else {
        _lilvView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55  + (0.5 + 55) * 3, kScreenW, 55 )];
        lilvLabel.text = @"利率(%)";

    }
    UITapGestureRecognizer *lilvTap = [[UITapGestureRecognizer alloc]init];
    [lilvTap addTarget:self action:@selector(tapRateAction)];
    [self.lilvView addGestureRecognizer:lilvTap];
    _lilvView.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    lilvLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    lilvLabel.font = [UIFont systemFontOfSize:15];
    lilvLabel.textColor = COLOR_RGB_0X(0x000000);
    [_lilvView addSubview:lilvLabel];

    UIImageView *imageViewTH = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 19.9 - 8.3, 20, 8.3, 15.15)];
    imageViewTH.image = [UIImage imageNamed:@"moreIcon"];
    [_lilvView addSubview:imageViewTH];

    self.lilvButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lilvButton.frame = CGRectMake(kScreenW - 19.9 - 8.3 - 16 - 62.5, 20, 62.5, 14.5);

    NSString *lilvString = [PCCalculatorProperty shareCalculator].daikuanlilvString;

    [self.lilvButton setTitle:[NSString stringWithFormat:@"%.2f",[lilvString floatValue] ] forState:UIControlStateNormal];

    [self.lilvButton setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];
    self.lilvButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.lilvButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.lilvButton addTarget:self action:@selector(tapChangeRateType:) forControlEvents:UIControlEventTouchUpInside];
    [_lilvView  addSubview:self.lilvButton];
    [self.scrollView addSubview:_lilvView];

    //公积金贷款利率
    if (self.gongjijinlilvView) {
        [self.gongjijinlilvView  removeFromSuperview];
    }
    _gongjijinlilvView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55  + (0.5 + 55) * 5, kScreenW, 55 )];
    UITapGestureRecognizer *gongjijinTap = [[UITapGestureRecognizer alloc]init];
    [gongjijinTap addTarget:self action:@selector(tapAccumulationFundAction)];
    [self.gongjijinlilvView addGestureRecognizer:gongjijinTap];
    _gongjijinlilvView.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    UILabel *gongjijinlilvLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.5, 20, 130, 14.5)];
    gongjijinlilvLabel.text = @"公积金贷款利率(%)";
    gongjijinlilvLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    gongjijinlilvLabel.font = [UIFont systemFontOfSize:15];
    gongjijinlilvLabel.textColor = COLOR_RGB_0X(0x000000);
    [_gongjijinlilvView addSubview:gongjijinlilvLabel];

    UIImageView *gongjijinlilvimageViewTH = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 19.9 - 8.3, 20, 8.3, 15.15)];
    gongjijinlilvimageViewTH.image = [UIImage imageNamed:@"moreIcon"];
    [_gongjijinlilvView addSubview:gongjijinlilvimageViewTH];

    self.gongjijinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gongjijinButton.frame = CGRectMake(kScreenW - 19.9 - 8.3 - 16 - 62.5, 20, 62.5, 14.5);

    NSString *gongjijiString = [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString;
    if (gongjijiString.length != 0) {
        [self.gongjijinButton setTitle:[NSString stringWithFormat:@"%.2f",[gongjijiString floatValue] ] forState:UIControlStateNormal];
    }else {
        [self.gongjijinButton setTitle:@"2.75" forState:UIControlStateNormal];
    }
    [self.gongjijinButton setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];
    self.gongjijinButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.gongjijinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.gongjijinButton addTarget:self action:@selector(tapAccumulationChangeRateType:) forControlEvents:UIControlEventTouchUpInside];
    [_gongjijinlilvView  addSubview:self.gongjijinButton];
    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {
            [self.scrollView addSubview:_gongjijinlilvView];
       }else {
     }

    //公积金贷款金额
    if (self.gongjijindaikuanjineView) {
        [self.gongjijindaikuanjineView  removeFromSuperview];
    }
    _gongjijindaikuanjineView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55 + (0.5 + 55) * 2 , kScreenW, 55 )];
    UITapGestureRecognizer *jineTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jineTapAction)];
    [_gongjijindaikuanjineView addGestureRecognizer:jineTap];
    _gongjijindaikuanjineView.backgroundColor = COLOR_RGB_0X(0xFFFFFF);
    UILabel *gongjijindaikuanjineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.5, 20, 130, 14.5)];
    gongjijindaikuanjineLabel.text = @"公积金贷款金额";
    gongjijindaikuanjineLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    gongjijindaikuanjineLabel.font = [UIFont systemFontOfSize:15];
    gongjijindaikuanjineLabel.textColor = COLOR_RGB_0X(0x000000);
    [_gongjijindaikuanjineView addSubview:gongjijindaikuanjineLabel];
    UILabel *gongjijindaikuan = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 17.5 - 14, 21.5, 14, 13)];
    gongjijindaikuan.text = @"万";
    gongjijindaikuan.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    gongjijindaikuan.font = [UIFont systemFontOfSize:15];
    gongjijindaikuan.textColor = COLOR_RGB_0X(0x666666);
    [_gongjijindaikuanjineView addSubview:gongjijindaikuan];
    self.gongjijindaikuanField = [[PCBaseTextField alloc]init];
    self.gongjijindaikuanField.frame = CGRectMake(kScreenW - 19.9 - 8.3 - 10.5 - 100, 20, 100, 14.5);
    self.gongjijindaikuanField.delegate  =  self;
    self.gongjijindaikuanField.placeholder = @"请输入金额";
    self.gongjijindaikuanField.textColor = COLOR_RGB_0X(0x666666);
    if (self.gongjijindaikuanFieldString.length != 0) {
        self.gongjijindaikuanField.text = self.gongjijindaikuanFieldString;
    }
    self.gongjijindaikuanField.font = [UIFont systemFontOfSize:15];
    self.gongjijindaikuanField.textAlignment = NSTextAlignmentRight;
    self.gongjijindaikuanField.keyboardType = UIKeyboardTypeDecimalPad;
    self.gongjijindaikuanField.returnKeyType =  UIReturnKeyDone;
    [_gongjijindaikuanjineView  addSubview:self.gongjijindaikuanField];
    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {
          [self.scrollView addSubview:_gongjijindaikuanjineView];
         }else {
    }
}

-(void)jineTapAction{
    [self.gongjijindaikuanField becomeFirstResponder];
}
-(void)daikuanjineTapAction{
    [self.daikuanjineField becomeFirstResponder];
}
#pragma 点击贷款类型
//点击贷款类型
- (void)tapChangeLoansType:(UIButton *)button {
    __block typeof(self)  weakSelf = self ;
    NSString *string = (button.currentTitle.length == 0) ? @"商业贷款" :button.currentTitle;
    [PCStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"商业贷款", @"公积金贷款", @"组合贷款",] defaultSelValue:string isAutoSelect:YES resultBlock:^(id selectValue) {

        [button setTitle:selectValue forState:UIControlStateNormal];
        [button setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];
        [PCCalculatorProperty shareCalculator].DAIKUANTYPE = selectValue;
        if ([selectValue isEqualToString:@"商业贷款"]) {
            [PCCalculatorProperty shareCalculator].daikuannianxianString = @"5";
            [PCCalculatorProperty shareCalculator].daikuanlilvString = @"4.75";
            [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = @"2.75";
            self.daikuanjineFieldString = nil;
            [PCCalculatorProperty shareCalculator].daikuanzongshuString = nil;
        }else if ([selectValue isEqualToString:@"公积金贷款"]) {
            [PCCalculatorProperty shareCalculator].daikuannianxianString = @"5";
            [PCCalculatorProperty shareCalculator].daikuanlilvString = @"2.75";
            self.daikuanjineFieldString = nil;
            [PCCalculatorProperty shareCalculator].daikuanzongshuString = nil;
        }else {
            [PCCalculatorProperty shareCalculator].daikuannianxianString = @"5";
            [PCCalculatorProperty shareCalculator].daikuanlilvString = @"4.75";
            [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = @"2.75";
                self.daikuanjineFieldString = nil;

                self.gongjijindaikuanFieldString = nil;
            [PCCalculatorProperty shareCalculator].daikuanzongshuString = nil;
            [PCCalculatorProperty shareCalculator].gongjijindaikuanString = nil;
        }
        if (self.segment.selectedSegmentIndex == 0) {
            [PCCalculatorTool equalPrincipalAndInterest];
        }else {
            [PCCalculatorTool averageCapital];
        }
        weakSelf.scrollView.contentSize = CGSizeMake(kScreenW, 210 + (55 + 0.5) * 7 + 64);
        [weakSelf setupDifferentTypeView];
        [weakSelf setupRepaymentMoneyDetailView];
        [weakSelf  setupRepaymentDetailView];
        [weakSelf setupFooterMessageView];
    }];
}
#pragma 点击贷款利率类型
//点击贷款利率类型
- (void)tapChangeRateType:(UIButton *)button {
    [self.view endEditing:YES];

    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"商业贷款"] |[[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {
        NSString *string ;
        if ([[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] > 3 && [[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] <= 5) {//3 -  5年间的贷款利率
            //4.75

            NSLog(@"%@",button.currentTitle);
            if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:@"4.75"]) {//4.75
                string = @"基准利率" ;
            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 0.07 * 10] ]) {//3.43

                string = @"7折利率";
            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 0.08 * 10]]) {//3.92
                string = @"8折利率";
            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 0.083 * 10]]) {//4.067
                string = @"8.3折利率";
            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 0.085 * 10]]) {//4.165
                string = @"8.5折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 0.088 * 10]]) {//4.312
                string = @"8.8折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 0.09 * 10]]) {//4.41
                string = @"9折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 0.095 * 10]]) {//4.655
                string = @"9.5折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 1.05 ]]) {//5.145
                string = @"1.05倍利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString  isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 1.1]]) {//5.39
                string  = @"1.1倍利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 1.2]]) {//5.88
                string = @"1.2倍利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.75 * 1.3]]) {//6.37
                string = @"1.3倍利率";
            }
        }else if ([[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] > 5){ //5年以上的贷款利率
            //4.90
            if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:@"4.9"]) {//4.9
                string = @"基准利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 0.07 * 10]]) {//3.43
                string = @"7折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 0.08 * 10]]) {//3.92
                string = @"8折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 0.083 * 10]]) {//4.067
                string = @"8.3折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 0.085 * 10]]) {//4.165
                string = @"8.5折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 0.088 * 10]]) {//4.312
                string = @"8.8折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 0.09 * 10]]) {//4.41
                string = @"9折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 0.095 * 10]]) {//4.655
                string = @"9.5折利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 1.05 ]]) {//5.145
                string = @"1.05倍利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 1.1]]) {//5.39
                string = @"1.1倍利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 1.2]]) {//5.88
                string = @"1.2倍利率";

            }else if ([[PCCalculatorProperty shareCalculator].daikuanlilvString isEqualToString:[NSString stringWithFormat:@"%.2f",4.90 * 1.3]]) {//6.37
                string = @"1.3倍利率";
            }
        }
        NSLog(@"string = %@",string) ;
        [PCStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"基准利率", @"7折利率", @"8折利率", @"8.3折利率", @"8.5折利率", @"8.8折利率", @"9折利率", @"9.5折利率", @"1.05倍利率", @"1.1倍利率", @"1.2倍利率", @"1.3倍利率"] defaultSelValue:string isAutoSelect:YES resultBlock:^(id selectValue) {

                if ([[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] > 3 && [[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] <= 5) {//3 -  5年间的贷款利率
                    //4.75

                    if ([selectValue isEqualToString:@"基准利率"]) {//4.75
                        [button setTitle:@"4.75" forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"7折利率"]) {//3.43
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 0.07 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"8折利率"]) {//3.92
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 0.08 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"8.3折利率"]) {//4.067
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 0.083 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"8.5折利率"]) {//4.165
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 0.085 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"8.8折利率"]) {//4.312
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 0.088 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"9折利率"]) {//4.41
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 0.09 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"9.5折利率"]) {//4.655
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 0.095 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"1.05倍利率"]) {//5.145
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 1.05 ] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"1.1倍利率"]) {//5.39
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 1.1] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"1.2倍利率"]) {//5.88
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 1.2] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"1.3倍利率"]) {//6.37
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.75 * 1.3] forState:UIControlStateNormal];
                    }
                    [PCCalculatorProperty shareCalculator].daikuanlilvString = button.currentTitle;

                }else if ([[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] > 5){ //5年以上的贷款利率
                    //4.90
                    if ([selectValue isEqualToString:@"基准利率"]) {//4.9
                        [button setTitle:@"4.9" forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"7折利率"]) {//3.43
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 0.07 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"8折利率"]) {//3.92
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 0.08 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"8.3折利率"]) {//4.067
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 0.083 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"8.5折利率"]) {//4.165
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 0.085 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"8.8折利率"]) {//4.312
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 0.088 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"9折利率"]) {//4.41
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 0.09 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"9.5折利率"]) {//4.655
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 0.095 * 10] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"1.05倍利率"]) {//5.145
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 1.05 ] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"1.1倍利率"]) {//5.39
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 1.1] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"1.2倍利率"]) {//5.88
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 1.2] forState:UIControlStateNormal];
                    }else if ([selectValue isEqualToString:@"1.3倍利率"]) {//6.37
                        [button setTitle:[NSString stringWithFormat:@"%.2f",4.90 * 1.3] forState:UIControlStateNormal];
                    }
                    [PCCalculatorProperty shareCalculator].daikuanlilvString = button.currentTitle;
                }
            [button setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];

            if (self.segment.selectedSegmentIndex == 0) {
                [PCCalculatorTool equalPrincipalAndInterest];
            }else {
                [PCCalculatorTool averageCapital];
            }
            [self setupRepaymentMoneyDetailView];
            [self setupDifferentTypeView];
        }];
    }else { //公积金贷款
        NSString *string;
        if ([[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] > 5) {
            if ([button.currentTitle isEqualToString:[NSString stringWithFormat:@"%.2f",3.35 * 1.1]]) {
                string = @"1.1倍利率";
            }else {
                string = @"基准利率";
            }

        }else {
            if ([button.currentTitle isEqualToString:[NSString stringWithFormat:@"%.2f",2.75 * 1.1]]) {
                string = @"1.1倍利率";
            }else {
                string = @"基准利率";
            }
        }
        [PCStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"基准利率", @"1.1倍利率"] defaultSelValue:string isAutoSelect:YES resultBlock:^(id selectValue) {
            [button setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];
            NSLog(@"公积金 = %@",string);
            if ([[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] > 5) {
                if ([selectValue isEqualToString:@"基准利率"]) {
                    [button setTitle:@"3.35" forState:UIControlStateNormal];
                }else if ([selectValue isEqualToString:@"1.1倍利率"]) {
                    [button setTitle:[NSString stringWithFormat:@"%.2f",3.35 * 1.1] forState:UIControlStateNormal];
                }
                [PCCalculatorProperty shareCalculator].daikuanlilvString = button.currentTitle;

            }else if ( [[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] <= 5) {
                if ([selectValue isEqualToString:@"基准利率"]) {
                        [button setTitle:@"2.75" forState:UIControlStateNormal];

                }else if ([selectValue isEqualToString:@"1.1倍利率"]) {
                    [button setTitle:[NSString stringWithFormat:@"%.2f",2.75 * 1.1] forState:UIControlStateNormal];
                }
                [PCCalculatorProperty shareCalculator].daikuanlilvString = button.currentTitle;
             }
            if (self.segment.selectedSegmentIndex == 0) {
                [PCCalculatorTool equalPrincipalAndInterest];
            }else {
                [PCCalculatorTool averageCapital];
            }
            [self setupRepaymentMoneyDetailView];
            [self setupDifferentTypeView];
        }];
    }
}
//点击修改期限 tapChangeTimeLimit
- (void)tapChangeTimeLimit:(UIButton *)button {
    [self.view endEditing:YES];
    NSString *string = [PCCalculatorProperty shareCalculator].daikuannianxianString;
    [PCStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"5", @"10", @"15", @"20", @"25", @"30"] defaultSelValue:string isAutoSelect:YES resultBlock:^(id selectValue) {
        [button setTitle:selectValue forState:UIControlStateNormal];
        [button setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];
//商业贷款情况
        [PCCalculatorProperty shareCalculator].daikuannianxianString = selectValue;
        if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"商业贷款"]) {
            if ([selectValue intValue] <= 1) {
                //4.35
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",4.35];
            }else if ([selectValue intValue] > 1 && [selectValue intValue] <= 3) {
                //4.35
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",4.75];
            }else if ([selectValue intValue] > 3 && [selectValue intValue] <= 5) {
                //4.75
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",4.75];
            }else {
                //4.90
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",4.90];
            }
        }else if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"公积金贷款"]) {
            if ([selectValue intValue] <= 1) {
                //2.75
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",2.75];
            }else if ([selectValue intValue] > 1 && [selectValue intValue] <= 3) {
                //2.75
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",2.75];
            }else if ([selectValue intValue] > 3 && [selectValue intValue] <= 5) {
                //2.75
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",2.75];
            }else {
                //3.35
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",3.35];
            }
        }else {  //组合贷款情况

            if ([selectValue intValue] <= 1) {
                //2.75
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",4.35];
                [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = [NSString stringWithFormat:@"%f",2.75];

            }else if ([selectValue intValue] > 1 && [selectValue intValue] <= 3) {
                //2.75
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",4.75];
                [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = [NSString stringWithFormat:@"%f",2.75];

            }else if ([selectValue intValue] > 3 && [selectValue intValue] <= 5) {
                //2.75
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",4.75];
                [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = [NSString stringWithFormat:@"%f",2.75];

            }else {
                //3.35
                [PCCalculatorProperty shareCalculator].daikuanlilvString = [NSString stringWithFormat:@"%f",4.90];
                [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = [NSString stringWithFormat:@"%f",3.35];
            }
        }
        if (self.segment.selectedSegmentIndex == 0) {
            if ([PCCalculatorProperty shareCalculator].daikuanzongshuString.length == 0) {
            }else {
                [PCCalculatorTool equalPrincipalAndInterest];
            }
        }else {
            if ([PCCalculatorProperty shareCalculator].daikuanzongshuString.length == 0) {
            }else {
                [PCCalculatorTool averageCapital];
            }
        }
        [self setupRepaymentMoneyDetailView];
        [self setupDifferentTypeView];
    }];
}
//公积金利率  单独 tapAccumulationChangeRateType
- (void)tapAccumulationChangeRateType:(UIButton *) button {

    NSString *string ;//(button.currentTitle.length == 0) ? @"基准利率" :button.currentTitle
    if ([[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] > 5) {

        if ([button.currentTitle isEqualToString:[NSString stringWithFormat:@"%.2f",3.35 * 1.1]]) {
            string = @"1.1倍利率";
        }else {
            string = @"基准利率";
        }

    }else {
        if ([button.currentTitle isEqualToString:[NSString stringWithFormat:@"%.2f",2.75 * 1.1]]) {
            string = @"1.1倍利率";
        }else {
            string = @"基准利率";
        }
    }
        [PCStringPickerView showStringPickerWithTitle:@"" dataSource:@[@"基准利率", @"1.1倍利率"] defaultSelValue:string isAutoSelect:YES resultBlock:^(id selectValue) {
            [button setTitleColor:COLOR_RGB_0X(0x666666) forState:UIControlStateNormal];

            if ([[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] > 5) {
                if ([selectValue isEqualToString:@"基准利率"]) {
                    [button setTitle:@"3.35" forState:UIControlStateNormal];

                }else if ([selectValue isEqualToString:@"1.1倍利率"]) {
                    [button setTitle:[NSString stringWithFormat:@"%.2f",3.35 * 1.1] forState:UIControlStateNormal];
                }
                [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = button.currentTitle;

            }else if ( [[PCCalculatorProperty shareCalculator].daikuannianxianString intValue] <= 5) {
                if ([selectValue isEqualToString:@"基准利率"]) {

                    [button setTitle:@"2.75" forState:UIControlStateNormal];

                }else if ([selectValue isEqualToString:@"1.1倍利率"]) {
                    [button setTitle:[NSString stringWithFormat:@"%.2f",2.75 * 1.1] forState:UIControlStateNormal];

                }
                [PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString = button.currentTitle;
            }

            if (self.segment.selectedSegmentIndex == 0) {
                [PCCalculatorTool equalPrincipalAndInterest];
            }else {
                [PCCalculatorTool averageCapital];
            }
            [self setupRepaymentMoneyDetailView];
            [self setupDifferentTypeView];
        }];
}
- (void)selectItem:(UISegmentedControl *)control {
    if ([PCCalculatorProperty shareCalculator].daikuanzongshuString == nil) {
        //给出提示信息  输入贷款金额
        [self setupRepaymentMoneyDetailView];//:resultDic
    }else {
        if (control.selectedSegmentIndex == 0) {
            //等额本息
            [PCCalculatorTool equalPrincipalAndInterest];
            [self setupRepaymentMoneyDetailView];//:resultDic
        }else {
            //等额本金
            [PCCalculatorTool averageCapital];
            [self setupRepaymentMoneyDetailView];//:self.benxiArray
        }
    }
}
//利率表按钮
- (void)setupNavigationItemButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 46, 14.5);
    [button setTitle:@"利率表" forState:UIControlStateNormal];
    [button setTitle:@"利率表" forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(navBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemNew = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = itemNew;
}
//利率表按钮点击事件
- (void)navBtnClick {
    PCHouseRateController *interRate  = [[PCHouseRateController alloc]init];
    [self.navigationController pushViewController:interRate animated:YES];
}
- (void)setupRepaymentDetailView {
    if (self.huankuanxiangqingView) {
        [self.huankuanxiangqingView removeFromSuperview];
    }
        self.huankuanxiangqingView = [[UIView alloc]initWithFrame:CGRectMake(0, 210, kScreenW,   55 )];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapRapaymentDetailAction)];
        self.huankuanxiangqingView.backgroundColor = MainBgColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15.5, 20, 62.5, 14.5)];
        label.text = @"还款详情";
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = COLOR_RGB_0X(0x000000);
        [self.huankuanxiangqingView  addSubview:label];

        [self.scrollView addSubview:self.huankuanxiangqingView];

        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 17 - 8.3, 19.5, 8.3, 16)];
        iconImage.image = [UIImage imageNamed:@"moreIcon"];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"detailIcon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"detailIcon"] forState:UIControlStateHighlighted];
        button.frame  =  CGRectMake(kScreenW - 16 - 15 - 17 - 8.3 , 19, 15, 17);
        [button addTarget:self action:@selector(repaymentBtnAction) forControlEvents:UIControlEventTouchUpInside];

    NSString *string = [PCCalculatorProperty shareCalculator].daikuanzongshuString;
    NSString *gongjijinString = [PCCalculatorProperty shareCalculator].gongjijindaikuanString;
    NSString *title = [PCCalculatorProperty shareCalculator].DAIKUANTYPE;
    if ([title isEqualToString:@"组合贷款"]) {

        if (string.length != 0 && gongjijinString.length != 0) {
            [self.huankuanxiangqingView addSubview:button];
            [self.huankuanxiangqingView addSubview:iconImage];
            [self.huankuanxiangqingView addGestureRecognizer:tap];
        }
    }else {
        if (string.length != 0) {
            [self.huankuanxiangqingView addSubview:button];
            [self.huankuanxiangqingView addSubview:iconImage];
            [self.huankuanxiangqingView addGestureRecognizer:tap];
        }
    }
}
//点击还款详情
- (void)tapRapaymentDetailAction {
    [self repaymentBtnAction];
    [self.view endEditing:YES];
}
//点击贷款类型
- (void)tapMaturityTypeAction {
    [self tapChangeLoansType:_daikuanTypeButton];
    [self.view endEditing:YES];
}
//改变贷款期限
- (void)tapLengthOfMaturityAction {
    [self tapChangeTimeLimit:_loanTimeButton];
}
//点击公积金贷款
- (void)tapAccumulationFundAction {
    [self tapAccumulationChangeRateType:_gongjijinButton];
    [self.view endEditing:YES];
}
//点击利率
- (void)tapRateAction {
    [self tapChangeRateType:_lilvButton];
    [self.view endEditing:YES];
}
- (void)setupFooterMessageView {
    [self.view endEditing:YES];
    if (self.headView ) {
        [self.headView removeFromSuperview];
    }
    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {

        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 210 + 55 * 7 + 0.5 * 5 , kScreenW, 30)];
    }else {
        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0,  210 + 55 * 5 + 0.5 * 3, kScreenW, 30)];
    }
        _headView.backgroundColor = MainBgColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 15.5, kScreenW - 16, 14.5)];
        label.text = @"以上为央行2019年最新公布贷款的贷款基准利率";
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = COLOR_RGB_0X(0x999999);
        [_headView addSubview:label];
        [self.scrollView addSubview:_headView];
}
//还款详情button
- (void)repaymentBtnAction{
    PCReimbursementController *repaymeng = [[PCReimbursementController alloc]init];
    repaymeng.reimbursementIndex = self.segment.selectedSegmentIndex;
    [self.navigationController pushViewController:repaymeng animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {

    if ([textField.text doubleValue] > 9999.99) {
        textField.text = [NSString stringWithFormat:@"%.2f",9999.99];
    }
//    if ([textField.text isEqualToString:[NSString stringWithFormat:@"%@.",textField.text]]) {
    //    }
    if ([textField.text containsString:@"."]) {
        if ([textField.text rangeOfString:@"."].location + 1  == textField.text.length) {
            textField.text = [NSString stringWithFormat:@"%@00",textField.text];
        }
        if ([textField.text rangeOfString:@"."].location == 1) {
            if (textField.text.length >= 4) {
                textField.text = [textField.text substringWithRange:NSMakeRange(0, 4)];
            }else {
            }
        }else if ([textField.text rangeOfString:@"."].location == 0) {
            textField.text = @"0.00";
        }
    }
    if (textField == self.gongjijindaikuanField) {
        [PCCalculatorProperty shareCalculator].gongjijindaikuanString = textField.text;
        self.gongjijindaikuanFieldString = textField.text;
    }else {
        [PCCalculatorProperty shareCalculator].daikuanzongshuString = textField.text;
        self.daikuanjineFieldString = textField.text;
    }
    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {

        if (self.segment.selectedSegmentIndex == 0) {
//组合贷款情况下  两个输入结果都存在
            if ([PCCalculatorProperty shareCalculator].gongjijindaikuanString.length != 0 && [PCCalculatorProperty shareCalculator].daikuanzongshuString.length != 0) {
                [PCCalculatorTool equalPrincipalAndInterest];
            }else {

            }
        }else {
            if ([PCCalculatorProperty shareCalculator].gongjijindaikuanString.length != 0 && [PCCalculatorProperty shareCalculator].daikuanzongshuString.length != 0) {
                [PCCalculatorTool averageCapital];

            }else {

            }
        }
    }else {
        if (self.segment.selectedSegmentIndex == 0) {
            [PCCalculatorTool equalPrincipalAndInterest];
        }else {
            [PCCalculatorTool averageCapital];
        }
    }
    [self setupRepaymentDetailView];
    [self setupRepaymentMoneyDetailView];
}
//9999.99
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 6) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else {
          return NO;
        }
    }
    if (textField == self.daikuanjineField | textField == self.gongjijindaikuanField) {
        // 当前输入的字符是'.'
        if ([string isEqualToString:@"."]) {
            // 已输入的字符串中已经包含了'.'或者""
            if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]) {
                return NO;
            } else {
                return YES;
            }
        } else {// 当前输入的不是'.'
            // 第一个字符是0时, 第二个不能再输入0
            if (textField.text.length == 1) {
                unichar str = [textField.text characterAtIndex:0];
                if (str == '0' && [string isEqualToString:@"0"]) {
                    return NO;
                }
                if (str != '0' && str != '1') {// 1xx或0xx
                    return YES;
                } else {
                    if (str == '1') {
                        return YES;
                    } else {
                        if ([string isEqualToString:@""]) {
                            return YES;
                        } else {
                            return NO;
                        }
                    }
                }
            }
            // 已输入的字符串中包含'.'
            if ([textField.text rangeOfString:@"."].location != NSNotFound) {
                NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
                [str insertString:string atIndex:range.location];
                if (str.length >= [str rangeOfString:@"."].location + 4) {
                    return NO;
                }
            } else {
                if (textField.text.length > 3) {
                    return range.location < 4;
                }
            }
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.daikuanjineField resignFirstResponder];
    [self.gongjijindaikuanField resignFirstResponder];
    return YES;
}
@end
