#import "PCCalculatorTool.h"
#import "PCCalculatorProperty.h"
#import <sys/utsname.h>
@interface PCCalculatorTool()
@property (nonatomic, strong) NSMutableArray *sumArray;

@end

@implementation PCCalculatorTool

+ (void)equalPrincipalAndInterest{

    [[PCCalculatorProperty shareCalculator].dengebenxiArray  removeAllObjects];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) {

        /*
         等额本息还款:
         　　每月月供额=〔贷款本金×月利率×(1＋月利率)＾还款月数〕÷〔(1＋月利率)＾还款月数-1〕
         　　每月应还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
         　　每月应还本金=贷款本金×月利率×(1+月利率)^(还款月序号-1)÷〔(1+月利率)^还款月数-1〕
         　　总利息=还款月数×每月月供额-贷款本金
         */
        double daiKuanZongShu = [[PCCalculatorProperty shareCalculator].daikuanzongshuString doubleValue] * 10000;//商贷数额


        double  gognjijindaikuanshue = [[PCCalculatorProperty shareCalculator].gongjijindaikuanString floatValue] * 10000; //公积金贷款数额
        if (daiKuanZongShu == 0 | gognjijindaikuanshue == 0 ) {
            [PCCalculatorProperty shareCalculator].huankuanzongeString = [NSString stringWithFormat:@"%.2f",0.00];

            [PCCalculatorProperty shareCalculator].zongzhifulixiString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].meiyueyuegongString = [NSString stringWithFormat:@"%.2f",0.00];

            [PCCalculatorProperty shareCalculator].gudinghuankuanString = [NSString stringWithFormat:@"%.2f",0.00];
            return;
        }
        double yueShu = [[PCCalculatorProperty shareCalculator].daikuannianxianString doubleValue] * 12.0;//贷款月数
        double liLv = [[PCCalculatorProperty shareCalculator].daikuanlilvString doubleValue];//年利率
        double gongjijinLilv = [[PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString doubleValue];//
        double yueLilv = (liLv / 100.0) /12.0;//商贷月利率
        double gonjijYuelilv = (gongjijinLilv / 100.0) /12.0;//公积金月利率

        double yueXuHao = 1.0;
        //    [label_2.text floatValue]/100;//利率


#pragma 每月还款
        double yueHuan = daiKuanZongShu * yueLilv * pow(1+yueLilv, yueShu) /(pow(1 + yueLilv, yueShu) - 1);
        double yueHuan1 = gognjijindaikuanshue * gonjijYuelilv * pow(1+gonjijYuelilv, yueShu) /(pow(1 + gonjijYuelilv, yueShu) - 1);
#pragma 每月应还利息
        double yueHuanLiXi = daiKuanZongShu * yueLilv * (pow(1 + yueLilv, yueShu) - pow(1 + yueLilv, yueXuHao - 1) ) / (pow(1 + yueLilv, yueShu) - 1); //
         double yueHuanLiXiGongJiJin = gognjijindaikuanshue * gonjijYuelilv * (pow(1 + gonjijYuelilv, yueShu) - pow(1 + gonjijYuelilv, yueXuHao - 1) ) / (pow(1 + gonjijYuelilv, yueShu) - 1); //

#pragma 每月应还本金
        double yueHuanBenJin = daiKuanZongShu * yueLilv * pow(1 + yueLilv, yueXuHao - 1) / (pow(1 + yueLilv, yueShu) - 1);//
        double yueHuanBenJinGongJiJin = gognjijindaikuanshue * gonjijYuelilv * pow(1 + gonjijYuelilv, yueXuHao - 1) / (pow(1 + gonjijYuelilv, yueShu) - 1);//
#pragma 总利息
        double zongLiXi = yueShu *yueHuan - daiKuanZongShu;//
        double zongLiXi2 = yueShu *yueHuan1 - gognjijindaikuanshue;//
#pragma 还款总额
        double zongHuan = yueHuan * yueShu + yueHuan1 * yueShu;//

        double  gudinghuankuanshue = yueHuanLiXi + yueHuanBenJin + yueHuanBenJinGongJiJin + yueHuanLiXiGongJiJin ;

            [PCCalculatorProperty shareCalculator].huankuanzongeString = [NSString stringWithFormat:@"%.2f",zongHuan];//

            [PCCalculatorProperty shareCalculator].zongzhifulixiString = [NSString stringWithFormat:@"%.2f",zongLiXi + zongLiXi2];//
            [PCCalculatorProperty shareCalculator].meiyueyuegongString = [NSString stringWithFormat:@"%.2f",yueHuan + yueHuan1];//

            [PCCalculatorProperty shareCalculator].gudinghuankuanString = [NSString stringWithFormat:@"%.2f",gudinghuankuanshue] ;//



        //加判断    在主界面
        for (int i = 1; i <=  [PCCalculatorProperty shareCalculator].calcuTime ; i++) {
#pragma 每月应还利息
            double yueHuanLiXi = daiKuanZongShu * yueLilv * ( (pow(1 + yueLilv, yueShu) - pow(1 + yueLilv, i - 1) )) / (pow(1 + yueLilv, yueShu) - 1); //
            double yueHuanLiXiGongJiJin = gognjijindaikuanshue * gonjijYuelilv * (pow(1 + gonjijYuelilv, yueShu) - pow(1 + gonjijYuelilv, i - 1) ) / (pow(1 + gonjijYuelilv, yueShu) - 1); //

#pragma 每月应还本金
            double yueHuanBenJin = daiKuanZongShu * yueLilv * pow(1 + yueLilv, (i - 1)) / (pow(1 + yueLilv, yueShu) - 1);//
             double yueHuanBenJinGongJiJin = gognjijindaikuanshue * gonjijYuelilv * pow(1 + i, yueXuHao - 1) / (pow(1 + gonjijYuelilv, yueShu) - 1);//

            //两种贷款数据
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",yueHuanBenJin + yueHuanBenJinGongJiJin] doubleValue]]]];//月供本金  yueHuanBenJin + yueHuanBenJinGongJiJin
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",yueHuanLiXi + yueHuanLiXiGongJiJin] doubleValue]]]];// 月还利息  yueHuanLiXi + yueHuanLiXiGongJiJin


            //剩余
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",zongHuan - i * (gudinghuankuanshue)] doubleValue]]]]; // zongHuan - i * (gudinghuankuanshue)
        }

    }else {

        double daiKuanZongShu = [[PCCalculatorProperty shareCalculator].daikuanzongshuString doubleValue] * 10000;//贷款总额



        if (daiKuanZongShu == 0) {

            [PCCalculatorProperty shareCalculator].huankuanzongeString = [NSString stringWithFormat:@"%.2f",0.00];

            [PCCalculatorProperty shareCalculator].zongzhifulixiString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].meiyueyuegongString = [NSString stringWithFormat:@"%.2f",0.00];

            [PCCalculatorProperty shareCalculator].gudinghuankuanString = [NSString stringWithFormat:@"%.2f",0.00];
            return;
        }

        double yueShu = [[PCCalculatorProperty shareCalculator].daikuannianxianString doubleValue] * 12.0;//贷款月数
        double liLv = [[PCCalculatorProperty shareCalculator].daikuanlilvString doubleValue];//年利率
        double yueLilv = (liLv / 100.0) /12.0;//月利率

        double yueXuHao = 1.0;
        //    [label_2.text floatValue]/100;//利率

#pragma 每月还款
        double yueHuan = daiKuanZongShu * yueLilv * pow(1+yueLilv, yueShu) /(pow(1 + yueLilv, yueShu) - 1);
#pragma 每月应还利息
        double yueHuanLiXi = daiKuanZongShu * yueLilv * (pow(1 + yueLilv, yueShu) - pow(1 + yueLilv, yueXuHao - 1) ) / (pow(1 + yueLilv, yueShu) - 1); //
#pragma 每月应还本金
        double yueHuanBenJin = daiKuanZongShu * yueLilv * pow(1 + yueLilv, yueXuHao - 1) / (pow(1 + yueLilv, yueShu) - 1);//
#pragma 总利息
        double zongLiXi = yueShu *yueHuan - daiKuanZongShu;//
#pragma 还款总额
        double zongHuan = yueHuan * yueShu;//

        double  gudinghuankuanshue = yueHuanLiXi + yueHuanBenJin;


        [PCCalculatorProperty shareCalculator].huankuanzongeString = [NSString stringWithFormat:@"%.2f",zongHuan] ;//zongHuan

        [PCCalculatorProperty shareCalculator].zongzhifulixiString = [NSString stringWithFormat:@"%.2f",zongLiXi] ;//zongLiXi
        [PCCalculatorProperty shareCalculator].meiyueyuegongString = [NSString stringWithFormat:@"%.2f",yueHuan] ;//yueHuan

        [PCCalculatorProperty shareCalculator].gudinghuankuanString = [NSString stringWithFormat:@"%.2f",gudinghuankuanshue] ;


        for (int i = 1; i <=  [PCCalculatorProperty shareCalculator].calcuTime ; i++) {

#pragma 每月应还利息
            double yueHuanLiXi = daiKuanZongShu * yueLilv * ( (pow(1 + yueLilv, yueShu) - pow(1 + yueLilv, i - 1) )) / (pow(1 + yueLilv, yueShu) - 1); //
#pragma 每月应还本金
            double yueHuanBenJin = daiKuanZongShu * yueLilv * pow(1 + yueLilv, (i - 1)) / (pow(1 + yueLilv, yueShu) - 1);//

            //单一一种贷款数据
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",yueHuanBenJin] doubleValue]]]];//月供本金
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",yueHuanLiXi] doubleValue]]]];// 月还利息


            //剩余
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",zongHuan - i * (gudinghuankuanshue)] doubleValue]]]]; //
        }
    }
}
+ (void )averageCapital {
    [[PCCalculatorProperty shareCalculator].dengebenxiArray  removeAllObjects];

    NSMutableArray *lixiArray = [NSMutableArray array];
    NSMutableArray *gongjijinlixiArray = [NSMutableArray array];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];

    formatter.numberStyle =NSNumberFormatterDecimalStyle;
/*
 等额本金还款:
 　　每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
 　　每月应还本金=贷款本金÷还款月数
 　　每月应还利息=剩余本金×月利率=(贷款本金-已归还本金累计额)×月利率
 　　每月月供递减额=每月应还本金×月利率=贷款本金÷还款月数×月利率
 　　总利息=〔(总贷款额÷还款月数+总贷款额×月利率)+总贷款额÷还款月数×(1+月利率)〕÷2×还款月数-总贷款额
 　　月利率=年利率÷12
 */
    if ([[PCCalculatorProperty shareCalculator].DAIKUANTYPE isEqualToString:@"组合贷款"]) { // 两种贷款混合计算
        double daiKuanZongShu = [[PCCalculatorProperty shareCalculator].daikuanzongshuString floatValue] * 10000;//贷款总额
        double gongjijindaiKuanZongShu = [[PCCalculatorProperty shareCalculator].gongjijindaikuanString floatValue] * 10000;//贷款总额

        if (daiKuanZongShu == 0 | gongjijindaiKuanZongShu == 0) {
            [PCCalculatorProperty shareCalculator].shouyueyuegongString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].yuemoyuegongString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].huankuanzongeString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].zongzhifulixiString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].yueGongDiJian = [NSString stringWithFormat:@"%.2f",0.00];
            return;
        }

        double  liLv = [[PCCalculatorProperty shareCalculator].daikuanlilvString doubleValue];//年利率
        double  gongjijinliLv = [[PCCalculatorProperty shareCalculator].gongjijidaikuanlilvString doubleValue];//年利率

        double yueShu = [[PCCalculatorProperty shareCalculator].daikuannianxianString doubleValue] * 12.0;//贷款月数
        double yueLilv = (liLv / 100) /12.0;//月利率
        double gongjijinyueLilv = (gongjijinliLv / 100) /12.0;//月利率

//        float diyigeyue = 1.0;

        double   yihuankuanyueshu = 1.0;

        //已归还本金累计
//        float guiHuanBenJinLeiJi = (daiKuanZongShu / yueShu) * yihuankuanyueshu;

        double gongjijinguiHuanBenJinLeiJi = (gongjijindaiKuanZongShu / yueShu) * yihuankuanyueshu;

#pragma 每月月供额
//        float meiYueYueGong = (daiKuanZongShu / yueShu) + (daiKuanZongShu - guiHuanBenJinLeiJi ) * yueLilv  ;
#pragma 每月应还本金
        double meiyueyinghuanbenjin = daiKuanZongShu / yueShu ;  //每月应还本金
        double gongjijinmeiyueyinghuanbenjin =  gongjijindaiKuanZongShu / yueShu;  //每月应还本金

#pragma 每月应还利息
//        float yueHuanLiXi = (daiKuanZongShu - guiHuanBenJinLeiJi ) * yueLilv; //
#pragma 每月月供递减额
        double yueGongDiJian = meiyueyinghuanbenjin * yueLilv + gongjijinmeiyueyinghuanbenjin * gongjijinyueLilv ;
#pragma 总利息
        double zongLiXi = ((daiKuanZongShu / yueShu + daiKuanZongShu * yueLilv) + daiKuanZongShu / yueShu * (1 + yueLilv)) / 2 * yueShu - daiKuanZongShu;//

        double gongjijinzongLiXi = ((gongjijindaiKuanZongShu / yueShu + gongjijindaiKuanZongShu * gongjijinyueLilv) + gongjijindaiKuanZongShu / yueShu * (1 + gongjijinyueLilv)) / 2 * yueShu - gongjijindaiKuanZongShu;//
#pragma 还款总额 (总利息 + 贷款总额)
        double zongHuan = zongLiXi +  daiKuanZongShu   + gongjijinzongLiXi + gongjijindaiKuanZongShu ;//



#pragma 首月月供

        double shouyueyuegong =  (daiKuanZongShu / yueShu) + (daiKuanZongShu  ) * yueLilv + (gongjijindaiKuanZongShu / yueShu) + (gongjijindaiKuanZongShu  ) * gongjijinyueLilv;

#pragma 月末月供


        double yuemoyuegong = meiyueyinghuanbenjin + (daiKuanZongShu - ((daiKuanZongShu / yueShu) * (yueShu - 1))) * yueLilv;
        double gongjijinyuemoyuegong = gongjijinguiHuanBenJinLeiJi + (gongjijindaiKuanZongShu - ((gongjijindaiKuanZongShu / yueShu) * (yueShu - 1))) * gongjijinyueLilv;

        [PCCalculatorProperty shareCalculator].shouyueyuegongString = [NSString stringWithFormat:@"%.2f",shouyueyuegong];//shouyueyuegong
        [PCCalculatorProperty shareCalculator].yuemoyuegongString = [NSString stringWithFormat:@"%.2f",yuemoyuegong + gongjijinyuemoyuegong];//yuemoyuegong + gongjijinyuemoyuegong
        [PCCalculatorProperty shareCalculator].huankuanzongeString = [NSString stringWithFormat:@"%.2f",zongHuan];//zongHuan
        [PCCalculatorProperty shareCalculator].zongzhifulixiString = [NSString stringWithFormat:@"%.2f",zongLiXi + gongjijinzongLiXi];//zongLiXi + gongjijinzongLiXi
        [PCCalculatorProperty shareCalculator].yueGongDiJian = [NSString stringWithFormat:@"%.2f",yueGongDiJian];//yueGongDiJian

        for ( int i = 0; i <= [PCCalculatorProperty shareCalculator].calcuTime; i ++) {

            double meiyueyinghuanbenjin = daiKuanZongShu / yueShu;  //每月应还本金
            double gongjijinmeiyueyinghuanbenjin = gongjijindaiKuanZongShu / yueShu;  //每月应还本金

            //累计归还本金
            double guiHuanBenJinLeiJi = (daiKuanZongShu / yueShu) * i;
            double gongjijinguiHuanBenJinLeiJi = (gongjijindaiKuanZongShu / yueShu) * i;

#pragma 每月应还利息
            double yueHuanLiXi = (daiKuanZongShu - guiHuanBenJinLeiJi ) * yueLilv; //
            double gongjijinyueHuanLiXi = (gongjijindaiKuanZongShu - gongjijinguiHuanBenJinLeiJi ) * gongjijinyueLilv; //

#pragma 归还利息总和
            //        float yiguihuanlixizonghe =

            [lixiArray addObject:[NSString stringWithFormat:@"%.2f",yueHuanLiXi]];
            [gongjijinlixiArray addObject:[NSString stringWithFormat:@"%.2f",gongjijinyueHuanLiXi]];
#pragma 每月月供额

//            float meiYueYueGong = (daiKuanZongShu / yueShu) + (daiKuanZongShu - guiHuanBenJinLeiJi ) * yueLilv  ;

            NSNumber *sum = [lixiArray valueForKeyPath:@"@sum.self"];
            double lixiTotalSum = [sum doubleValue];

            NSNumber *gongjijinsum = [gongjijinlixiArray valueForKeyPath:@"@sum.self"];
            double gongjijinlixiTotalSum = [gongjijinsum doubleValue];

            double residueMoney =  zongHuan - meiyueyinghuanbenjin * (i + 1)  - lixiTotalSum   - gongjijinmeiyueyinghuanbenjin * (i + 1)  - gongjijinlixiTotalSum;

            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",meiyueyinghuanbenjin + gongjijinmeiyueyinghuanbenjin] doubleValue]]]];//meiyueyinghuanbenjin + gongjijinmeiyueyinghuanbenjin
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",yueHuanLiXi + gongjijinyueHuanLiXi] doubleValue]]]];//yueHuanLiXi + gongjijinyueHuanLiXi

            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",residueMoney] doubleValue]]]];//residueMoney
        }

    }else { //单一贷款种类

        double daiKuanZongShu = [[PCCalculatorProperty shareCalculator].daikuanzongshuString doubleValue] * 10000;//贷款总额

        if (daiKuanZongShu == 0) {
            [PCCalculatorProperty shareCalculator].shouyueyuegongString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].yuemoyuegongString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].huankuanzongeString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].zongzhifulixiString = [NSString stringWithFormat:@"%.2f",0.00];
            [PCCalculatorProperty shareCalculator].yueGongDiJian = [NSString stringWithFormat:@"%.2f",0.00];
            return;
        }
        double  liLv = [[PCCalculatorProperty shareCalculator].daikuanlilvString doubleValue];//年利率

        double yueShu = [[PCCalculatorProperty shareCalculator].daikuannianxianString doubleValue] * 12.0;//贷款月数
        double yueLilv = (liLv / 100) /12.0;//月利率

//        float diyigeyue = 1.0;

        float   yihuankuanyueshu = 1.0;



        //已归还本金累计
//        float guiHuanBenJinLeiJi = (daiKuanZongShu / yueShu) * yihuankuanyueshu;
#pragma 每月月供额
//        float meiYueYueGong = (daiKuanZongShu / yueShu) + (daiKuanZongShu - guiHuanBenJinLeiJi ) * yueLilv  ;
#pragma 每月应还本金
        double meiyueyinghuanbenjin = daiKuanZongShu / yueShu;  //每月应还本金
#pragma 每月应还利息
//        float yueHuanLiXi = (daiKuanZongShu - guiHuanBenJinLeiJi ) * yueLilv; //
#pragma 每月月供递减额
        double yueGongDiJian = meiyueyinghuanbenjin * yueLilv;
#pragma 总利息
        double zongLiXi = ((daiKuanZongShu / yueShu + daiKuanZongShu * yueLilv) + daiKuanZongShu / yueShu * (1 + yueLilv)) / 2 * yueShu - daiKuanZongShu;//
#pragma 还款总额 (总利息 + 贷款总额)
        double zongHuan = zongLiXi +  daiKuanZongShu;//



#pragma 首月月供

        double shouyueyuegong =  (daiKuanZongShu / yueShu) + (daiKuanZongShu  ) * yueLilv;

#pragma 月末月供


        double yuemoyuegong = meiyueyinghuanbenjin + (daiKuanZongShu - ((daiKuanZongShu / yueShu) * (yueShu - 1))) * yueLilv;


        [PCCalculatorProperty shareCalculator].shouyueyuegongString = [NSString stringWithFormat:@"%.2f",shouyueyuegong] ;//shouyueyuegong
        [PCCalculatorProperty shareCalculator].yuemoyuegongString = [NSString stringWithFormat:@"%.2f",yuemoyuegong] ;//yuemoyuegong
        [PCCalculatorProperty shareCalculator].huankuanzongeString = [NSString stringWithFormat:@"%.2f",zongHuan];//zongHuan
        [PCCalculatorProperty shareCalculator].zongzhifulixiString = [NSString stringWithFormat:@"%.2f",zongLiXi];//zongLiXi
        [PCCalculatorProperty shareCalculator].yueGongDiJian = [NSString stringWithFormat:@"%.2f",yueGongDiJian];//yueGongDiJian

        for ( int i = 0; i <= [PCCalculatorProperty shareCalculator].calcuTime; i ++) {

            double meiyueyinghuanbenjin = daiKuanZongShu / yueShu;  //每月应还本金

            //累计归还本金
            double guiHuanBenJinLeiJi = (daiKuanZongShu / yueShu) * i;

#pragma 每月应还利息
            double yueHuanLiXi = (daiKuanZongShu - guiHuanBenJinLeiJi ) * yueLilv; //

#pragma 归还利息总和
            [lixiArray addObject:[NSString stringWithFormat:@"%.2f",yueHuanLiXi]];
#pragma 每月月供额
//            float meiYueYueGong = (daiKuanZongShu / yueShu) + (daiKuanZongShu - guiHuanBenJinLeiJi ) * yueLilv  ;


            NSNumber *sum = [lixiArray valueForKeyPath:@"@sum.self"];
            double lixiTotalSum = [sum doubleValue];

            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",meiyueyinghuanbenjin] doubleValue]]]];//meiyueyinghuanbenjin
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",yueHuanLiXi] doubleValue]]]];//yueHuanLiXi
            [[PCCalculatorProperty shareCalculator].dengebenxiArray addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",zongHuan - meiyueyinghuanbenjin * (i + 1) - lixiTotalSum] doubleValue]]]];//zongHuan - meiyueyinghuanbenjin * (i + 1) - lixiTotalSum
        }
    }
}
@end
