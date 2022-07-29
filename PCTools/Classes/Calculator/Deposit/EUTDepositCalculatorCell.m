//
//  CKHomeCell.m
//  WagesCalculator
//
//  Created by 鸿朔 on 2017/12/18.
//  Copyright © 2017年 鸿朔. All rights reserved.
//

#import "EUTDepositCalculatorCell.h"
#import <objc/runtime.h>

@implementation EUTDepositCalculatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self eutSetupSubViews];
    }
    return self;
}

- (void)eutSetupSubViews {
    // 标题
    UILabel *titleLB = [[UILabel alloc] init];
    titleLB.textColor = UIColorFromRGB(0x000000);
    titleLB.font = [UIFont systemFontOfSize:SP(15)];
    [self.contentView addSubview:titleLB];
    self.titleLB = titleLB;
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(0);
        make.left.equalTo(self).offset(15);
    }];
    
    // 值
    UILabel *valueLB = [[UILabel alloc] init];
    valueLB.textColor = UIColorFromRGB(0x000000);
    valueLB.font = [UIFont systemFontOfSize:SP(15)];
    valueLB.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:valueLB];
    self.valueLB = valueLB;
    [self.valueLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-15);
    }];
    
    UITextField *valueTF = [[UITextField alloc] init];
    valueTF.placeholder = @"请输入金额";
    
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(valueTF, ivar);
    placeholderLabel.textColor = UIColorFromRGB(0x999999);
    placeholderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:SP(15)];
    valueTF.keyboardType = UIKeyboardTypeDecimalPad;
    valueTF.returnKeyType = UIReturnKeyDone;
    valueTF.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:valueTF];
    self.valueTF = valueTF;
    [self.valueTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(kScreenW-SP(148));
    }];

    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detailIcon"]];
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(0);
        make.left.mas_equalTo(self.titleLB.mas_right).offset(20);
    }];
}

@end
