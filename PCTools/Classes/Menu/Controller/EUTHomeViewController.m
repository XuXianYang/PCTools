//
//  EUTHomeViewController.m
//  EUTTools
//
//  Created by apple on 2020/1/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTHomeViewController.h"
#import "EUTHomeMenuView.h"
@interface EUTHomeViewController ()<HomeMenuViewDelegate>

@property(nonatomic,strong)EUTHomeMenuView * menuView;

@end

@implementation EUTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self eutSetupSubViews];
}
-(void)itemBtnAction:(NSInteger )index title:(NSString *)title{
    [self openPageWithIndex:index andTitle:title];
}
-(void)eutSetupSubViews{
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"生活";
    
    self.menuView = [[EUTHomeMenuView alloc]init];
    self.menuView.viewDelegate = self;
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(PCNaviBarHeight);
        make.bottom.equalTo(self.view).offset(-PCTabbarHeight);
    }];
    if (@available(iOS 11.0, *)){
        self.menuView.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    NSArray *menuArr = @[@{@"img":@"homeMenu_CKJSQ",@"title":@"存款计算",@"index":@"0"},
         @{@"img":@"homeMenu_LJFL",@"title":@"垃圾分类查询",@"index":@"1"},
         @{@"img":@"homeMenu_SJGSD",@"title":@"手机归属地",@"index":@"2"},
         @{@"img":@"homeMenu_WDWZ",@"title":@"我的位置",@"index":@"3"},
         @{@"img":@"homeMenu_SBXX",@"title":@"设备信息",@"index":@"4"},
         @{@"img":@"homeMenu_IPDZ",@"title":@"IP地址",@"index":@"5"},
         @{@"img":@"homeMenu_WLCS",@"title":@"网络测速",@"index":@"6"},
         @{@"img":@"homeMenu_JNR",@"title":@"纪念日计算",@"index":@"7"},
         @{@"img":@"homeMenu_SCDM",@"title":@"手持弹幕",@"index":@"8"},
         @{@"img":@"homeMenu_QPJSQ",@"title":@"全屏计时器",@"index":@"9"},
         @{@"img":@"homeMenu_DXSZ",@"title":@"大写数字",@"index":@"10"},
         @{@"img":@"homeMenu_PJSB",@"title":@"票据识别",@"index":@"11"},
         @{@"img":@"homeMenu_PCT",@"title":@"拼长图",@"index":@"12"}];
    [self.menuView.dataArr addObjectsFromArray:menuArr];
    [self.menuView.collectionView reloadData];
    
}


@end
