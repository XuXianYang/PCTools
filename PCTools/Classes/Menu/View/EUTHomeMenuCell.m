//
//  EUTHomeMenuCell.m
//  EUTTools
//
//  Created by apple on 2020/1/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTHomeMenuCell.h"
@interface EUTHomeMenuCell()

@property(nonatomic,strong)UIImageView * contentImageView;
@property(nonatomic,strong)UILabel * contentLabel;


@end
@implementation EUTHomeMenuCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}
-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    self.contentImageView.image = [UIImage imageNamed:dataDict[@"img"]];
    self.contentLabel.text = dataDict[@"title"];
}
-(void)createSubView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = kAutoScale(4);
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kAutoScale(8));
    }];
    self.contentImageView = imageView;
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:kAutoScale(15)];
    [self addSubview:label];
    label.textColor = UIColorFromRGB(0x000000);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(self.contentImageView.mas_right).offset(kAutoScale(8));
    }];
    self.contentLabel = label;
}

@end
