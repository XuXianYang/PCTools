//
//  PCTicketQueryCell.m
//  PCTools
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCTicketQueryCell.h"

@interface PCTicketQueryCell()

@property(nonatomic,strong) UILabel *startTimeLab;//开始时间
@property(nonatomic,strong) UILabel *endTimeLab;//到达时间
@property(nonatomic,strong) UILabel *startPlaceLab;//起点
@property(nonatomic,strong) UILabel *endPlaceLab;//目的地
@property(nonatomic,strong) UILabel *firstSeatLab;//一等座
@property(nonatomic,strong) UILabel *secondSeatLabLab;//二等座
@property(nonatomic,strong) UILabel *businessSeatLab;//商务座
@property(nonatomic,strong) UILabel *trainsLab;//车次
@property(nonatomic,strong) UILabel *timeConsumingLab;//耗时
@end

@implementation PCTicketQueryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.layer.cornerRadius = 5;
    }
    return self;
}
-(void)setDictData:(NSDictionary *)dictData{
    _dictData = dictData;
    self.startTimeLab.text = [CommonTool safeString:dictData[@"startTime"]];
    self.endTimeLab.text = [CommonTool safeString:dictData[@"arriveTime"]];
    
    self.trainsLab.text = [CommonTool safeString:dictData[@"stationTrainCode"]];
    self.timeConsumingLab.text = [CommonTool safeString:dictData[@"lishi"]];
    self.startPlaceLab.text = [CommonTool safeString:dictData[@"startStationName"]];
    self.endPlaceLab.text = [CommonTool safeString:dictData[@"endStationName"]];
    NSString *trainTypeStr = [NSString stringWithFormat:@"%@",dictData[@"trainType"]];
    NSInteger trainType = [trainTypeStr integerValue];
   if(trainType == 2){//T
        self.secondSeatLabLab.text = [NSString stringWithFormat:@"硬座:%@",[CommonTool safeString:dictData[@"priceyz"]]];
        self.firstSeatLab.text = [NSString stringWithFormat:@"硬卧:%@",[CommonTool safeString:dictData[@"priceyw"]]];
        self.businessSeatLab.text = [NSString stringWithFormat:@"软卧:%@",[CommonTool safeString:dictData[@"pricerw"]]];
    }else if(trainType == 3){//G
        self.secondSeatLabLab.text = [NSString stringWithFormat:@"二等座:%@",[CommonTool safeString:dictData[@"priceed"]]];
        self.firstSeatLab.text = [NSString stringWithFormat:@"一等座:%@",[CommonTool safeString:dictData[@"priceyd"]]];
        self.businessSeatLab.text = [NSString stringWithFormat:@"商务座:%@",[CommonTool safeString:dictData[@"pricesw"]]];
    }else{//K
        self.secondSeatLabLab.text = [NSString stringWithFormat:@"无座:%@",[CommonTool safeString:dictData[@"pricewz"]]];
        self.firstSeatLab.text = [NSString stringWithFormat:@"硬座:%@",[CommonTool safeString:dictData[@"priceyz"]].length ?[CommonTool safeString:dictData[@"priceyz"]] :[CommonTool safeString:dictData[@"pricewz"]]];
        self.businessSeatLab.text = [NSString stringWithFormat:@"硬卧:%@",[CommonTool safeString:dictData[@"priceyw"]]];
    }
}
-(void)setupSubViews{
    
    CGFloat WIDTH = (kScreenW - 90)/3;
    
    self.startTimeLab = [self setupLabel:20 textColor:UIColorFromRGB(0x000000)];
    [self.startTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.mas_equalTo(self.mas_left).offset(WIDTH/2+25);
    }];
    
    self.endTimeLab = [self setupLabel:20 textColor:UIColorFromRGB(0x000000)];
    [self.endTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.mas_equalTo(self.mas_right).offset(-WIDTH/2-25);
    }];
    
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = UIColorFromRGB(0xA0A0A0);
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.startTimeLab).offset(0);
        make.centerX.equalTo(self).offset(0);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(WIDTH);
    }];
    
    self.startPlaceLab = [self setupLabel:16 textColor:UIColorFromRGB(0x000000)];
    [self.startPlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1).offset(10);
        make.centerX.mas_equalTo(self.mas_left).offset(WIDTH/2+25);
    }];
    
    self.endPlaceLab = [self setupLabel:16 textColor:UIColorFromRGB(0x000000)];
    [self.endPlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1).offset(10);
        make.centerX.mas_equalTo(self.mas_right).offset(-WIDTH/2-25);
    }];
    
    self.trainsLab = [self setupLabel:16 textColor:UIColorFromRGB(0x6B6B6B)];
    [self.trainsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView1).offset(-10);
        make.centerX.equalTo(self).offset(0);
    }];
    
    self.timeConsumingLab = [self setupLabel:16 textColor:UIColorFromRGB(0x6B6B6B)];
    [self.timeConsumingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1).offset(10);
        make.centerX.equalTo(self).offset(0);
    }];
    
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = UIColorFromRGB(0xA0A0A0);
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeConsumingLab.mas_bottom).offset(25);
        make.centerX.equalTo(self).offset(0);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(kScreenW-90);
    }];
    
    self.secondSeatLabLab = [self setupLabel:12 textColor:UIColorFromRGB(0x666666)];
    [self.secondSeatLabLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2).offset(15);
        make.centerX.equalTo(self.startTimeLab).offset(0);
    }];
    
    self.firstSeatLab = [self setupLabel:12 textColor:UIColorFromRGB(0x666666)];
    [self.firstSeatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2).offset(15);
        make.centerX.equalTo(self).offset(0);
    }];
    
    self.businessSeatLab = [self setupLabel:12 textColor:UIColorFromRGB(0x666666)];
    [self.businessSeatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2).offset(15);
        make.centerX.equalTo(self.endTimeLab).offset(0);
    }];
    
}

-(UILabel*)setupLabel:(CGFloat)font textColor:(UIColor*)color{
    UILabel *contentLabel = [[UILabel alloc]init];
    [self addSubview:contentLabel];
    contentLabel.textColor = color;
    contentLabel.font = [UIFont systemFontOfSize:font];
    return contentLabel;
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
