//
//  PCQueryNumAndIPCell.m
//  PCTools
//
//  Created by apple on 2019/12/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "EUTQueryNumAndIPCell.h"

@interface EUTQueryNumAndIPCell()

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *contentLab;

@end

@implementation EUTQueryNumAndIPCell
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
    contentLabel.textColor = UIColorFromRGB(0x36348E);
    contentLabel.font = [UIFont systemFontOfSize:16.0];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab.mas_right).offset(15);
        make.centerY.equalTo(self);
        
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
