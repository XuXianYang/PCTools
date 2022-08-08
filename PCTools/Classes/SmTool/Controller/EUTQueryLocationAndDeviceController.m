//
//  PCLifeLocationController.m
//  PCTools
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "EUTQueryLocationAndDeviceController.h"
#import "EUTQueryLocationCell.h"
#import <CoreLocation/CoreLocation.h>
#import "EUTGetDeviceModel.h"

@interface EUTQueryLocationAndDeviceController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager*locationManager;//位置管理
@property (retain, nonatomic)CLLocation *location;
@property (copy, nonatomic)NSString *city;

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,retain)NSMutableArray*dataList;

@end

@implementation EUTQueryLocationAndDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubViews];
    [self eutInitPageData];
}
-(void)eutInitPageData{
    if(self.pageType == EUTQueryWDWZType){
        self.navigationItem.title = @"我的位置";
        [self.dataList addObjectsFromArray:
               @[@{@"title":@"国家",@"content":@""},
                 @{@"title":@"省份",@"content":@""},
                 @{@"title":@"城市",@"content":@""},
                 @{@"title":@"区县",@"content":@""},
                 @{@"title":@"街道",@"content":@""},
                 @{@"title":@"街道门牌号",@"content":@""},
                 @{@"title":@"行政区划代码",@"content":@""},
                 @{@"title":@"当前经纬度",@"content":@""},
                 @{@"title":@"当前海拔",@"content":@""}]];
        [self startLocation];
    }else if(self.pageType == EUTQuerySBXXType){
        self.navigationItem.title = @"设备信息";
        [self.dataList addObjectsFromArray:
         @[@{@"title":@"APP名称",@"content":[EUTGetDeviceModel getAppName]},
           @{@"title":@"设备名称",@"content":[EUTGetDeviceModel deviceModel]},
           @{@"title":@"剩余电量",@"content":[EUTGetDeviceModel getCurrentBatteryLevel]},
           @{@"title":@"IP地址",@"content":[EUTGetDeviceModel getNetworkIPAddress]},
           @{@"title":@"网络运营商",@"content":[EUTGetDeviceModel deviceCarrierName]},
           @{@"title":@"设备总内存",@"content":[EUTGetDeviceModel getTotalMemory]},
           @{@"title":@"设备已使用内存",@"content":[EUTGetDeviceModel getUsedMemory]},
            @{@"title":@"设备总存储空间",@"content":[EUTGetDeviceModel totalDiskSpaceInBytes]},
          @{@"title":@"可用存储空间",@"content":[EUTGetDeviceModel freeDiskSpaceInBytes]},
          @{@"title":@"设备唯一ID",@"content":[[NSUUID UUID] UUIDString]},
           @{@"title":@"User Agent",@"content":@"Mozilla/5.0(iPhone; CPU iPhone OS like Mac OS X) "},
           @{@"title":@"设备品牌",@"content":@"Apple"},
           @{@"title":@"设备国家",@"content":[EUTGetDeviceModel getLocalCountry]},
           @{@"title":@"设备标识",@"content":[EUTGetDeviceModel platformName]},
           @{@"title":@"设备时区",@"content":[EUTGetDeviceModel getLocalZone]},
           @{@"title":@"语言环境",@"content":[EUTGetDeviceModel getLocalLanguage]},
           @{@"title":@"设备制造商",@"content":@"Apple"},
           @{@"title":@"系统名称",@"content":[EUTGetDeviceModel systemName]},
           @{@"title":@"系统版本",@"content":[EUTGetDeviceModel systemVersion]},
           @{@"title":@"字体缩放比例",@"content":@"1"},
           @{@"title":@"是否24小时制",@"content":[EUTGetDeviceModel is12Hours]?@"否":@"是"},
           @{@"title":@"是否是平板电脑",@"content":[EUTGetDeviceModel isIpad]?@"是":@"否"}]];
    }else if(self.pageType == EUTQueryWLCSType){
        self.navigationItem.title = @"网络测速";
        
        //获取wifi信息
        NSDictionary *WIFImessage = [EUTGetDeviceModel fetchSSIDInfo];
        //检测手机网络速度
        NSMutableDictionary *WIFIspeed = [EUTGetDeviceModel getDataCounters];
        NSLog(@"获取wifi信息 = %@ ------------- 检测手机网络速度 = %@",WIFImessage,WIFIspeed);
        
        [self.dataList addObjectsFromArray:
         @[@{@"title":@"IP",@"content":[EUTGetDeviceModel getIPAddress:YES]},
           @{@"title":@"来自",@"content":[EUTGetDeviceModel deviceCarrierName]},
           @{@"title":@"平均上传速度",@"content":[NSString stringWithFormat:@"%@k/s",WIFIspeed[@"nwifiSend"]]},
           @{@"title":@"平均下载速度",@"content":[NSString stringWithFormat:@"%@k/s",WIFIspeed[@"wifiReceived"]]},
           @{@"title":@"预估宽带",@"content":[NSString stringWithFormat:@"%@M",WIFIspeed[@"wwansend"]]}]];
        
        
    }
}
//开始定位
- (void)startLocation {
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied){//访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown){//无法获取位置信息
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    self.location = newLocation;
    [self getMyLocation];
    //    CLLocationCoordinate2D coordinate=newLocation.coordinate;
    //    NSLog(@"您的当前位置:经度：%f,纬度：%f,海拔：%f,航向：%f,速度：%f",coordinate.longitude,coordinate.latitude,newLocation.altitude,newLocation.course,newLocation.speed);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            self.city = city;
        }else if (error == nil && [array count] == 0){//No results were returned.
            
        }else if (error != nil){//error
            
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
-(void)getMyLocation{
    
    CLLocationCoordinate2D coordinate = self.location.coordinate;
    NSDictionary *parm = @{@"location":[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude]};
    //    NSLog(@"您的当前位置:经度：%f,纬度：%f,海拔：%f,航向：%f,速度：%f",coordinate.longitude,coordinate.latitude,self.location.altitude,self.location.course,self.location.speed);
    
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    [PCRequestTool postAllUrl:PCMyLocationUrl params:parm success:^(id responsebject) {
        [PNCGifWaitView hideWaitViewInController:self];
        if([responsebject[@"status"] isEqualToString:@"0000"]){
            [self.dataList removeAllObjects];
            NSDictionary *dict = responsebject[@"data"];
            [self.dataList addObjectsFromArray:@[
             @{@"title":@"国家",@"content":[CommonTool safeString:dict[@"country"]]},
             @{@"title":@"省份",@"content":[CommonTool safeString:dict[@"province"]]},
             @{@"title":@"城市",@"content":[CommonTool safeString:dict[@"city"]]},
             @{@"title":@"区县",@"content":[CommonTool safeString:dict[@"district"]]},
             @{@"title":@"街道",@"content":[CommonTool safeString:dict[@"street"]]},
             @{@"title":@"街道门牌号",@"content":[CommonTool safeString:dict[@"street_number"]]},
             @{@"title":@"行政区划代码",@"content":[CommonTool safeString:dict[@"adcode"]]},
             @{@"title":@"当前经纬度",@"content":[CommonTool safeString:parm[@"location"]]},
             @{@"title":@"当前海拔",@"content":[CommonTool safeString:[NSString stringWithFormat:@"%f",self.location.altitude]]},]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [PNCGifWaitView hideWaitViewInController:self];
    }];
}
-(NSMutableArray*)dataList{
    if(!_dataList){
        _dataList = [[NSMutableArray alloc]init];
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
    [self.tableView registerClass:[EUTQueryLocationCell class] forCellReuseIdentifier:@"EUTQueryLocationCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(EUTNaviBarHeight);
        make.height.mas_equalTo(self.view.frame.size.height-EUTNaviBarHeight);
    }];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight=10;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 135)];
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
        make.centerX.equalTo(footerView);
        make.bottom.equalTo(footerView).offset(-45);
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
    EUTQueryLocationCell*cell = [tableView dequeueReusableCellWithIdentifier:@"EUTQueryLocationCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleStr = self.dataList[indexPath.row][@"title"];
    cell.contentStr = self.dataList[indexPath.row][@"content"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
