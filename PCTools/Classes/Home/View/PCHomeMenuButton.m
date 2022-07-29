//
//  PCHomeMenuButton.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCHomeMenuButton.h"
@interface PCHomeMenuButton()
@property(nonatomic,strong)UIImageView*btnImageView;

@property(nonatomic,strong)UILabel*btnTitleLabel;

@end
@implementation PCHomeMenuButton

+(instancetype)buttonWithType:(UIButtonType)buttonType {
    PCHomeMenuButton*  selfBtn = [super buttonWithType:buttonType];
    if (selfBtn) {
        [selfBtn setupSubViews];
    }
    return selfBtn;
}
-(void)setupSubViews
{
    _btnImageView = [[UIImageView alloc]init];
    [self addSubview:_btnImageView];
    [_btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self).offset(0);
    }];
    
    _btnTitleLabel = [[UILabel alloc]init];
    _btnTitleLabel.textAlignment = NSTextAlignmentCenter;
    _btnTitleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:_btnTitleLabel];
    [_btnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-5);
        make.centerX.equalTo(self).offset(0);
    }];
}
-(void)setDefaultImage:(NSString *)defaultImage{
    _defaultImage = defaultImage;
    _btnImageView.image = [UIImage imageNamed:defaultImage];
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
