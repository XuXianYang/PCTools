//
//  PCHomeSectionHeaderView.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCHomeSectionHeaderView.h"

@interface PCHomeSectionHeaderView()

@property(nonatomic,strong)UILabel*contentTitleLabel;

@end

@implementation PCHomeSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self setUpChildViews];
    }
    return self;
}
-(void)setContentText:(NSString *)contentText{
    _contentText = contentText;
    _contentTitleLabel.text = contentText;
}
-(void)setUpChildViews{
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.layer.cornerRadius = 3;
    lineView.backgroundColor = MainColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self).offset(0);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [self addSubview:label];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = UIColorFromRGB(0x000000);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView.mas_right).offset(5);
        make.centerY.mas_equalTo(self).offset(0);
    }];
    _contentTitleLabel=label;

}
@end
