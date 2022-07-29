#import <Foundation/Foundation.h>

@interface PCCalculatorProperty : NSObject

@property(nonatomic, strong) NSString *daikuanzongshuString;//商贷金额
@property(nonatomic, strong) NSString *gongjijindaikuanString;//公积金金额
@property(nonatomic, strong) NSString *daikuannianxianString;// 贷款年限
@property(nonatomic, strong) NSString *daikuanlilvString;//贷款利率
@property(nonatomic, strong) NSString *gongjijidaikuanlilvString;//公积金贷款  利率
@property(nonatomic, strong) NSString *zongzhifulixiString; //总支付利息
@property(nonatomic, strong) NSString *huankuanzongeString;//还款总额
@property(nonatomic, strong) NSString *gudinghuankuanString;//固定还款数额
@property(nonatomic, strong) NSString *yuemoyuegongString; //月末月供
@property(nonatomic, strong) NSString *shouyueyuegongString;//首月月供
@property(nonatomic, strong) NSString *meiyueyuegongString;//每月月供
@property(nonatomic, strong) NSString *yueGongDiJian;//每月月供递减
@property (nonatomic, copy) NSString *DAIKUANTYPE;
@property (nonatomic, assign) int   calcuTime;
@property (nonatomic, assign) BOOL zuhedaikuanState;
@property (nonatomic, strong) NSMutableArray *dengebenxiArray;//数组放三种数据   1月供本金  2月供利息  3剩余
+ (PCCalculatorProperty *)shareCalculator;
@end
