//
//  PCHomeMenuCell.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCHomeMenuCell.h"
#import "PCHomeSectionHeaderView.h"
#import "PCHomeMenuButton.h"
#import<Plugin_SDK_iOS/Plugin_SDK_iOS.h>

@interface PCHomeMenuCell()

@property(nonatomic,strong) PCHomeSectionHeaderView *headerView;

@end

@implementation PCHomeMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
-(void)setHeaderViewTitle:(NSString *)headerViewTitle{
    _headerViewTitle = headerViewTitle;
    self.headerView.contentText = headerViewTitle;
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    for(NSInteger i = 0; i<dataArr.count ;i++){
        PCHomeMenuButton *btn = [self viewWithTag:200+i];
        btn.defaultText = dataArr[i][@"title"];
        btn.defaultImage = dataArr[i][@"img"];
    }
}
-(void)setIsShowWeather:(BOOL)isShowWeather{
    _isShowWeather = isShowWeather;
    if(isShowWeather){
        PCHomeMenuButton *btn = [self viewWithTag:200];
        [self setupWeatherView:btn :SynopticNetworkCustomViewTypeCircle :CGRectMake(0, 0, 60, 75)];
    }
}
-(void)setupWeatherView:(UIView*)fatherView :(SynopticNetworkCustomViewType)type :(CGRect)frame{
    SynopticNetworkCustomView *view = [SynopticNetworkCustomView initWithFrame:frame ViewType:type UserKey:@"mGgZuL0IOu" Location:@""];
    //2.3 属性设置
    view.viewPosition = SynopticNetworkCustomViewPositionTopLeft;//悬浮位置
    view.contentViewAlignmen = SynopticNetworkContentViewAlignmentCenter;//内容水平方向显示对齐方式
    view.iconType = SynopticNetworkCustomViewIconTypeDark;//图标样式
    view.padding = UIEdgeInsetsMake(0, 0, 0, 0);//SynopticNetworkCustomView的内边距
    view.backgroundColor = [UIColor whiteColor];//视图背景颜色
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
-(void)setupSubViews{
    
    UIView *menuBgView = [[UIView alloc]initWithFrame:CGRectZero];
    menuBgView.backgroundColor = [UIColor whiteColor];
    menuBgView.layer.cornerRadius = 5;
    [self.contentView addSubview:menuBgView];
    [menuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
    }];
    
    PCHomeSectionHeaderView *headerView = [[PCHomeSectionHeaderView alloc]initWithFrame:CGRectMake(0, 5,kScreenW-40, 40)];
    [menuBgView addSubview:headerView];
    self.headerView = headerView;
    
    CGFloat marginX = (kScreenW - 90 - 180)/2;
    for(NSInteger i = 0 ; i < 12; i++){
        PCHomeMenuButton *btn = [PCHomeMenuButton buttonWithType:UIButtonTypeCustom];
        [menuBgView addSubview:btn];
        btn.tag = 200+i;
        btn.frame = CGRectMake(25+(i%3)*(60+marginX) ,(i/3)*110+50 , 60, 95);
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)btnAction:(PCHomeMenuButton*)btn{

    if([self.delegate respondsToSelector:@selector(btnAction:title:)]){
        [self.delegate btnAction:btn.tag title:btn.defaultText];
    }
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
