#import "PCReimbursementCell.h"

@implementation PCReimbursementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
-(void)setupSubViews{
    
    int width = kScreenW / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, 40)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0x666666);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        switch (i) {
            case 0:
                self.monethLabel = label;
                break;
            case 1:
                self.principalLabel = label;
                break;
            case 2:
                self.interestLabel = label;
                break;
            case 3:
                self.residueLabel = label;
                break;
            default:
                break;
        }
    }
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = UIColorFromRGB(0xa0a0a0);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.bottom.equalTo(self).offset(0);
    }];
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
