//
//  EUTMemorialDayCell.m
//  EUTTools
//
//  Created by apple on 2020/1/6.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTMemorialDayCell.h"

@interface EUTMemorialDayCell()

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *contentLab;
@property(nonatomic,strong) UILabel *timeLab;

@end

@implementation EUTMemorialDayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        [self setupSubViews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)setDictData:(NSDictionary *)dictData{
    _dictData = dictData;
    self.titleLab.text = [CommonTool safeString:dictData[@"name"]];
    self.timeLab.text = [CommonTool safeString:dictData[@"date"]];
    
    NSString *dateStr = dictData[@"date"];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSInteger marginDays = [CommonTool numberOfDaysWithFromDate:[NSDate date] toDate:date];
    NSInteger type = [self.dictData[@"type"] integerValue];
    if(type == 2){//按天数
        NSInteger content = [self.dictData[@"content"] integerValue];
        marginDays = content - marginDays;
    }
    if(marginDays>=0){
        self.contentLab.text = [NSString stringWithFormat:@"剩余%li天",marginDays];
    }else{
        self.contentLab.text = [NSString stringWithFormat:@"已过%li天",-marginDays];
    }
    
}
-(void)setupSubViews{
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kScreenW/3-20);
    }];
    self.titleLab = titleLabel;
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [self addSubview:timeLabel];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont systemFontOfSize:16.0];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
    self.timeLab = timeLabel;
    
    UILabel *contentLabel = [[UILabel alloc]init];
    [self addSubview:contentLabel];
    contentLabel.textColor = UIColorFromRGB(0x000000);
    contentLabel.numberOfLines = 2;
    contentLabel.font = [UIFont systemFontOfSize:16.0];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
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
