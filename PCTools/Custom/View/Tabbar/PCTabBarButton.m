//
//  PCTabBarButton.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCTabBarButton.h"

@interface PCTabBarButton()


@end

@implementation PCTabBarButton

+(instancetype)buttonWithType:(UIButtonType)buttonType {
    PCTabBarButton*  selfBtn = [super buttonWithType:buttonType];
    if (selfBtn) {
        [selfBtn resetBtnConfig];
    }
    return selfBtn;
}
-(void)setupSubViews
{
    _btnImageView = [[UIImageView alloc]init];
    [self addSubview:_btnImageView];
    [_btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.centerX.equalTo(self).offset(0);
    }];
    
    _btnTitleLabel = [[UILabel alloc]init];
    _btnTitleLabel.textAlignment = NSTextAlignmentCenter;
    _btnTitleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:_btnTitleLabel];
    [_btnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnImageView.mas_bottom).offset(2);
        make.centerX.equalTo(self).offset(0);
    }];
}
-(void)setIsHiddenText:(BOOL)isHiddenText
{
    _isHiddenText = isHiddenText;
    _btnTitleLabel.hidden = isHiddenText;
}
-(void)resetBtnConfig {
    [self setupSubViews];
    //监听是否被选中状态
    [self addObserver:self forKeyPath:@"isSelected" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_isSelected) {
        [self setSelected];
    }else {
        [self setUnSelected];
    }
}
//设置已选中状态
-(void)setSelected {
    _btnImageView.image = [UIImage imageNamed:self.selectedImage];
    _btnTitleLabel.textColor = self.selectedTextColor;
}

//未选中状态
-(void)setUnSelected {
    _btnImageView.image = [UIImage imageNamed:self.defaultImage];
    _btnTitleLabel.textColor = self.defaultTextColor;
}
-(void)setDefaultText:(NSString *)defaultText
{
    _defaultText = defaultText;
    _btnTitleLabel.text = self.defaultText;
}
-(void)dealloc {
    [self removeObserver:self forKeyPath:@"isSelected"];
}
@end
