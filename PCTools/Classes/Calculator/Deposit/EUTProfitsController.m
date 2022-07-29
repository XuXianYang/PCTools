#import "EUTProfitsController.h"

@implementation EUTProfitsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"利润表";
    [self eutSetupSubViews];
}
- (void)eutSetupSubViews {
    
    UIView *titleView = [[UIView alloc]init];
    [self.view addSubview:titleView];
    titleView.backgroundColor = MainColor;
    titleView.layer.cornerRadius = SP(8);
    titleView.layer.masksToBounds = YES;
    titleView.frame = CGRectMake(15, 20+EUTNaviBarHeight, kScreenW-30, SP(50));
    
    UIView *contentView = [[UIView alloc]init];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = SP(8);
    contentView.layer.masksToBounds = YES;
    contentView.frame = CGRectMake(15, 30+SP(50)+EUTNaviBarHeight, kScreenW-30, SP(300));
    
    for (int i=0; i<7; i++) {
        
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.textAlignment = NSTextAlignmentCenter;
        if (i==0) {
            titleLB.textColor = [UIColor whiteColor];
            titleLB.backgroundColor = MainColor;
            [titleView addSubview:titleLB];
            titleLB.frame = CGRectMake(0, 0, (kScreenW-30)/2, SP(50));
        }else {
            titleLB.textColor = UIColorFromRGB(0x000000);
            [contentView addSubview:titleLB];
            titleLB.frame = CGRectMake(0, (i-1)*SP(50), (kScreenW-30)/2, SP(50));
        }
        titleLB.text = @[@"利率项目",@"活期存款",@"3个月定期存款",@"6个月定期存款",@"1年定期存款",@"2年定期存款",@"3年以上定期存款"][i];
        titleLB.font = [UIFont systemFontOfSize:SP(16)];
        
        
        UILabel *valueLB = [[UILabel alloc] initWithFrame:CGRectMake(15+(kScreenW-30)/2, 20+i*SP(35)+EUTNaviBarHeight, (kScreenW-30)/2, SP(35))];
        valueLB.textAlignment = NSTextAlignmentCenter;
        if (i==0) {
            valueLB.textColor = [UIColor whiteColor];
            valueLB.backgroundColor = MainColor;
            [titleView addSubview:valueLB];
            valueLB.frame = CGRectMake((kScreenW-30)/2, 0, (kScreenW-30)/2, SP(50));
        }else {
            valueLB.textColor = UIColorFromRGB(0x000000);
            [contentView addSubview:valueLB];
            valueLB.frame = CGRectMake((kScreenW-30)/2, (i-1)*SP(50), (kScreenW-30)/2, SP(50));
        }
        valueLB.text = @[@"年利率（%）",@"0.35",@"1.10",@"1.30",@"1.50",@"2.10",@"2.75"][i];
        valueLB.font = [UIFont systemFontOfSize:SP(16)];
    }
    
    // 额外信息
    UILabel *infoLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 40+SP(350)+EUTNaviBarHeight, kScreenW-30, SP(23))];
    infoLB.textColor = UIColorFromRGB(0x888888);
    infoLB.text = @"以上为央行2018年最新公布的存款基准利率";
    infoLB.font = [UIFont systemFontOfSize:SP(16)];
    [self.view addSubview:infoLB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
