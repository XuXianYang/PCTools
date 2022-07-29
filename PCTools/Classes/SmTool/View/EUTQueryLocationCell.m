//
//  PCLifeLocationCell.m
//  PCTools
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "EUTQueryLocationCell.h"

@interface EUTQueryLocationCell()

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *contentLab;

@end

@implementation EUTQueryLocationCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}
-(void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    self.contentLab.text = contentStr;
}
-(void)setupSubViews{
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    self.titleLab = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc]init];
    [self addSubview:contentLabel];
    contentLabel.textColor = UIColorFromRGB(0x8b8b8b);
    contentLabel.numberOfLines = 2;
    contentLabel.font = [UIFont systemFontOfSize:16.0];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kScreenW-180);
    }];
    self.contentLab = contentLabel;
   
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
