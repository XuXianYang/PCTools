//
//  PCCustomTabBar.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCCustomTabBar.h"
#import "UIImage+XzxyImage.h"
#import "PCTabBarButton.h"

@interface PCCustomTabBar()
//tabBar背景图
@property(nonatomic , strong)UIImageView*backImageView;
//选中的按钮
@property(nonatomic , strong)PCTabBarButton*praviousBtn;

@end

@implementation PCCustomTabBar

-(instancetype)init {
    self = [super init];
    if(self){
        self.backgroundColor = MainColor;
        [self createSubView];
    }
    return self;
}
-(void)createSubView
{
    _backImageView = [[UIImageView alloc]init];
    [self addSubview:_backImageView];
    _backImageView.userInteractionEnabled = YES;
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self).offset(0);
        make.height.mas_equalTo(49);
    }];
    
    self.layer.shadowOffset = CGSizeMake(0, -5);
    self.layer.shadowColor =  UIColorFromRGB(0x666666).CGColor;
    self.layer.shadowOpacity = 0.1;
    
    //选中的图片
    NSArray*selImageArr = @[@"tabbar_home_selected",@"tabbar_life_selected"];
    //未选中的图片
    NSArray*defaultImageArr = @[@"tabbar_home",@"tabbar_life"];
    //title
    NSArray*titleArr = @[@"首页",@"生活"];
    
    self.buttonArray = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0;i < titleArr.count; i++)
    {
        PCTabBarButton*tabBarBtn = [PCTabBarButton buttonWithType:UIButtonTypeCustom];
        [_backImageView addSubview:tabBarBtn];
        [tabBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backImageView).offset(0);
            make.width.mas_equalTo(kScreenW/titleArr.count);
            make.height.mas_equalTo(49);
            make.centerX.mas_equalTo(self.backImageView.mas_left).offset(kScreenW/titleArr.count/2+kScreenW/titleArr.count*i);
        }];
        tabBarBtn.selectedImage = selImageArr[i];
        tabBarBtn.defaultImage = defaultImageArr[i];
        tabBarBtn.defaultText = titleArr[i];
        //未选中的字体颜色
        tabBarBtn.defaultTextColor = UIColorFromRGB(0xffffff);
        //已选中的字体颜色
        tabBarBtn.selectedTextColor = UIColorFromRGB(0xFCEE21);
        tabBarBtn.tag = 1000+i;
        [tabBarBtn addTarget:self action:@selector(btnCliked:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarBtn addTarget:self action:@selector(btnRepeatCliked:) forControlEvents:UIControlEventTouchDownRepeat];
        
        if(i == 0){
            tabBarBtn.isSelected = YES;
            _praviousBtn = tabBarBtn;
            [self.selectButtonArray addObject:tabBarBtn];
        }else{
            tabBarBtn.isSelected = NO;
        }
        [self.buttonArray addObject:tabBarBtn];
    }
}
//双击操作
-(void)btnRepeatCliked:(PCTabBarButton*)btn
{
    if(btn != _praviousBtn)return;
    
    if([self.delegate respondsToSelector:@selector(tabBarButtonRepeatCliked:)])
    {
        [self.delegate tabBarButtonRepeatCliked:btn.tag-1000];
    }
}
-(void)btnCliked:(PCTabBarButton*)btn
{
    if(btn == _praviousBtn&&_praviousBtn.tag-1000 !=2 ){
        return;
    }else if (btn == _praviousBtn&&_praviousBtn.tag-1000 == 2){
        if([self.delegate respondsToSelector:@selector(tabBarButtonCliked:)])
        {
            [self.delegate tabBarButtonCliked:btn.tag-1000];
        }
        return;
    };
    btn.isSelected=YES;
    _praviousBtn.isSelected=NO;
    _praviousBtn=btn;
    
    [self.selectButtonArray replaceObjectAtIndex:0 withObject:_praviousBtn];
    
    if([self.delegate respondsToSelector:@selector(tabBarButtonCliked:)])
    {
        [self.delegate tabBarButtonCliked:btn.tag-1000];
    }
}

-(void)selectedItems:(NSInteger)index
{
    PCTabBarButton *btn = (PCTabBarButton *)self.buttonArray[index];
    PCTabBarButton *selectbtn = (PCTabBarButton *)self.selectButtonArray[0];
    
    _praviousBtn.isSelected = NO;
    _praviousBtn = btn;
    
    btn.isSelected = YES;
    selectbtn.isSelected = NO;
    selectbtn = btn;
    
    if([self.delegate respondsToSelector:@selector(tabBarButtonCliked:)])
    {
        [self.delegate tabBarButtonCliked:btn.tag-1000];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
