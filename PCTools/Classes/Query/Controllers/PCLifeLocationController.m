//
//  PCLifeLocationController.m
//  PCTools
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCLifeLocationController.h"
#import "PCLifeLocationCell.h"
#import <CoreLocation/CoreLocation.h>

@interface PCLifeLocationController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager*locationManager;//位置管理
@property (retain, nonatomic)CLLocation *location;
@property (copy, nonatomic)NSString *city;

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,retain)NSMutableArray*dataList;

@end

@implementation PCLifeLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的位置";
    [self setupSubViews];
    [self startLocation];
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
    //[self getMyLocation];
     CLLocationCoordinate2D coordinate=newLocation.coordinate;
    //    NSLog(@"您的当前位置:经度：%f,纬度：%f,海拔：%f,航向：%f,速度：%f",coordinate.longitude,coordinate.latitude,newLocation.altitude,newLocation.course,newLocation.speed);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        [PNCGifWaitView hideWaitViewInController:self];
        
        NSLog(@"array - %@",array);
        
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            NSLog(@"placemark = %@",placemark.addressDictionary);
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            self.city = city;
            
            NSDictionary *dict = placemark.addressDictionary;
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:@[
             @{@"title":@"国家",@"content":[CommonTool safeString:dict[@"Country"]]},
             @{@"title":@"省份",@"content":[CommonTool safeString:city]},
             @{@"title":@"城市",@"content":[CommonTool safeString:dict[@"City"]]},
             @{@"title":@"区县",@"content":[CommonTool safeString:dict[@"SubLocality"]]},
             @{@"title":@"街道",@"content":[CommonTool safeString:dict[@"Street"]]},
             @{@"title":@"街道门牌号",@"content":[CommonTool safeString:dict[@"Name"]]},
             @{@"title":@"行政区划代码",@"content":[CommonTool safeString:dict[@"CountryCode"]]},
             @{@"title":@"当前经纬度",@"content":[CommonTool safeString:[NSString stringWithFormat:@"%f,%f",self.location.coordinate.longitude,self.location.coordinate.latitude]]},
             @{@"title":@"当前海拔",@"content":[CommonTool safeString:[NSString stringWithFormat:@"%f",self.location.altitude]]},]];
            [self.tableView reloadData];
            
            
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
        _dataList = [NSMutableArray arrayWithArray:@[@{@"title":@"国家",@"content":@""},
                             @{@"title":@"省份",@"content":@""},
                             @{@"title":@"城市",@"content":@""},
                             @{@"title":@"区县",@"content":@""},
                             @{@"title":@"街道",@"content":@""},
                             @{@"title":@"街道门牌号",@"content":@""},
                             @{@"title":@"行政区划代码",@"content":@""},
                             @{@"title":@"当前经纬度",@"content":@""},
                             @{@"title":@"当前海拔",@"content":@""},]];
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
    PCLifeLocationCell*cell = [tableView dequeueReusableCellWithIdentifier:@"PCLifeLocationCell"];
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
