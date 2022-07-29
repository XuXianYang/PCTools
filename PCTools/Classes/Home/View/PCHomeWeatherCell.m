//
//  PCHomeWeatherCell.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCHomeWeatherCell.h"
#import "PCHomeSectionHeaderView.h"
#import "PCHomeMenuButton.h"
#import<Plugin_SDK_iOS/Plugin_SDK_iOS.h>

@interface PCHomeWeatherCell()

@end

@implementation PCHomeWeatherCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
-(void)setupSubViews{
    
    UIView *headerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-40, 150)];
    headerBgView.backgroundColor = [UIColor whiteColor];
    headerBgView.layer.cornerRadius = 5;
    [self.contentView addSubview:headerBgView];
    
    UIView *weatherBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenW-40, 80)];
    weatherBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:weatherBgView];
    
    [self setupWeatherView:weatherBgView :SynopticNetworkCustomViewTypeHorizontal :CGRectMake(0, 0, kScreenW -40, 100)];
    
    PCHomeSectionHeaderView *headerView = [[PCHomeSectionHeaderView alloc]initWithFrame:CGRectMake(0, 5,kScreenW-40, 40)];
    headerView.contentText = @"计算器";
    [headerBgView addSubview:headerView];
    
    UIView *menuBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, kScreenW-40, 135)];
    menuBgView.backgroundColor = [UIColor whiteColor];
    menuBgView.layer.cornerRadius = 5;
    [self.contentView addSubview:menuBgView];
    
    
    NSArray *dataArr = @[
                         @{@"title":@"房贷计算",@"img":@"homeMenuHouse"},
                         @{@"title":@"存款计算",@"img":@"homeMenu_CKJSQ"},
                         @{@"title":@"纪念日计算",@"img":@"homeMenu_JNR"},
    ];
    
    //bgView.frame = CGRectMake(10+(i%4)*Width ,(i/4)*80+top , Width, 75);

    NSArray *imageArr = @[@"homeMenuLiJie1",@"homeMenuLiJie2"];
    for(NSInteger i = 0 ; i < 2; i++){
        UIImageView *imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        if(i==0){
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.centerY.mas_equalTo(menuBgView.mas_top).offset(-5);
            }];
        }else{
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
                make.centerY.mas_equalTo(menuBgView.mas_top).offset(-5);
            }];
        }
    }
    
    CGFloat marginX = (kScreenW - 90 - 180)/2;
    for(NSInteger i = 0 ; i < dataArr.count; i++){
        PCHomeMenuButton *btn = [PCHomeMenuButton buttonWithType:UIButtonTypeCustom];
        [menuBgView addSubview:btn];
        btn.tag = 100 + i;
        btn.defaultText = dataArr[i][@"title"];
        btn.defaultImage = dataArr[i][@"img"];
        btn.frame = CGRectMake(25+(i%3)*(60+marginX) ,(i/3)*110+20 , 60, 95);
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
-(void)btnAction:(PCHomeMenuButton*)btn{
    if([self.delegate respondsToSelector:@selector(btnAction:title:)]){
        [self.delegate btnAction:btn.tag title:btn.defaultText];
    }
}
-(void)setupWeatherView:(UIView*)fatherView :(SynopticNetworkCustomViewType)type :(CGRect)frame{
    SynopticNetworkCustomView *view = [SynopticNetworkCustomView initWithFrame:frame ViewType:type UserKey:@"mGgZuL0IOu" Location:@""];
    //2.3 属性设置
    view.viewPosition = SynopticNetworkCustomViewPositionTopLeft;//悬浮位置
    view.contentViewAlignmen = SynopticNetworkContentViewAlignmentCenter;//内容水平方向显示对齐方式
    view.iconType = SynopticNetworkCustomViewIconTypeDark;//图标样式
    view.padding = UIEdgeInsetsMake(0, 0, 0, 0);//SynopticNetworkCustomView的内边距
    view.backgroundColor = [UIColor redColor];//视图背景颜色
    view.contentViewBackgroundImage = [UIImage new];//视图背景图片
    view.navigationBarBackgroundColor = MainColor;//导航条背景颜色
    view.progressColor = [UIColor blueColor];//进度条颜色
    view.textColor = UIColorFromRGB(0x666666);//文字颜色
    if(type == SynopticNetworkCustomViewTypeCircle){
        view.textColor = UIColorFromRGB(0xffffff);//文字颜色
    }
    view.dragEnable = NO;//是不是能拖曳
    view.freeRect = CGRectMake(0, 0, kScreenW, 300);//拖拽范围
    view.dragDirection = SynopticNetworkCustomViewDragDirectionAny;//拖拽的方向
    view.isKeepBounds = NO;//黏贴边界效果
    //2.4 将插件视图添加到需要显示的视图上
    [fatherView addSubview:view];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
