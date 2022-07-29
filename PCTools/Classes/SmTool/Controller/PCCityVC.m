//
//  CityVC.m
//  WagesCalculator
//
//  Created by 鸿朔 on 2017/12/18.
//  Copyright © 2017年 鸿朔. All rights reserved.
//

#import "PCCityVC.h"

@interface PCCityVC () <UITableViewDataSource,UITableViewDelegate>

/** UI */
//@property(nonatomic, strong) NCCustomNaviBar *bar;
@property (nonatomic ,strong) NSArray *sectionArr;
@property (nonatomic ,strong) NSArray *sourceArr;
@property (nonatomic ,strong) NSArray * indexArr;
@property (nonatomic ,strong) NSArray * pinyinArr;

@end

@implementation PCCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择城市";
    [self setSoure];
    [self setUI];
}
- (void)setSoure {
    NSDictionary *soure = [self readLocalFileWithName:@"city"];
    self.sectionArr = soure[@"section"];
    self.indexArr = soure[@"index"];
    self.sourceArr = soure[@"source"];
    self.pinyinArr = soure[@"pinyin"];
}
// 读取本地JSON文件
- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
- (void)setUI {
    
    UITableView *mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, PCNaviBarHeight, kScreenW, kScreenH - PCNaviBarHeight)];
    mainTV.delegate = self;
    mainTV.dataSource = self;
    mainTV.estimatedRowHeight = 0;
    mainTV.estimatedSectionHeaderHeight = 0;
    mainTV.estimatedSectionFooterHeight = 0;
    mainTV.separatorColor = MainBgColor;
    mainTV.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    mainTV.sectionIndexColor = MainColor;
    if (@available(iOS 15.0, *)) {
        mainTV.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:mainTV];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.sourceArr[section];
    return arr.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@" %@",self.sectionArr[section]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.sourceArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *city = self.sourceArr[indexPath.section][indexPath.row];
    NSString *py = self.pinyinArr[indexPath.section][indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectedCityBlock) {
        self.selectedCityBlock(city,py);
    }
}
#pragma mark -- 头部索引标题
//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArr;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
