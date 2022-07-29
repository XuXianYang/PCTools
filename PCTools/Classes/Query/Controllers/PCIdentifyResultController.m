//
//  NCHelperTextController.m
//  NCCalculator
//
//  Created by 陈凯 on 2019/12/16.
//  Copyright © 2019 NongCai. All rights reserved.
//

#import "PCIdentifyResultController.h"

@interface PCIdentifyResultController ()

/** 选择框 */
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
/** 底部选择按钮 */
@property (nonatomic,strong) UIView *bottomView;
/** 识别的内容显示 */
@property (nonatomic,strong) UIScrollView *bgScrollView;
/** 识别的原图 */
@property (nonatomic,strong) UIImageView *showImageView;
@end

@implementation PCIdentifyResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.navigationItem.title = @"文字识别";
    [self setupSubViews];
    [self setupBottomView];
    [self setupBgScrollView];
}

#pragma mark -  contentView

- (void)setupSubViews
{
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(PCStatusBarHeight + 7);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(29);
    }];
}

- (void)setupBottomView
{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(64 + PCTabbarHeight-49);
    }];
    
    NSArray *array = @[@"复制文字",@"导出图片"];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(bottonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:button];
        button.tag = i;
        
        CGFloat buttonW = kScreenW/2;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(buttonW * i);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(buttonW);
            make.bottom.mas_equalTo(-(PCTabbarHeight-49));
        }];
        
        if (i == 0) {
            UIView *lineView = [[UIView alloc]init];
            [self.bottomView addSubview:lineView];
            lineView.backgroundColor = UIColorFromRGB(0x8C8C8C);
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(button.mas_right);
                make.top.mas_equalTo(button.mas_top);
                make.width.mas_equalTo(0.5);
                make.height.mas_equalTo(button.mas_height);
            }];
        }
    }
}

- (void)setupBgScrollView
{
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PCNaviBarHeight);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    NSMutableArray *textLabArray = [[NSMutableArray alloc] init];
    if (self.dataArray.count > 0) {
        
        CGFloat textLabY = 0;
        for (int i = 0; i < self.dataArray.count; i++) {
            NSDictionary *dict = self.dataArray[i];
            UILabel *textLab = [[UILabel alloc]init];
            textLab.text = dict[@"words"];
            textLab.textColor = UIColorFromRGB(0x666666);
            textLab.font = [UIFont systemFontOfSize:14];
            [self.bgScrollView addSubview:textLab];
            textLab.numberOfLines = 0;
            
            CGFloat taxtLabX = 21.5;
            CGFloat taxtLabW = kScreenW - taxtLabX * 2;
            CGFloat taxtLabH = [[CommonTool shareInstance]calculateMoreLineTextHeight:textLab.text Font:14 Wtdth:taxtLabW];
            
            textLab.frame = CGRectMake(taxtLabX, textLabY, taxtLabW, taxtLabH);
            textLabY = textLabY + taxtLabH;
            
            [textLabArray addObject:textLab];
            [self.bgScrollView setContentSize:CGSizeMake(kScreenW, textLabY + taxtLabH)];
        }
    }
    
    CGFloat showImageW = self.showImage.size.width;
    CGFloat showImageH = self.showImage.size.height;
    CGFloat width = kScreenW - 30;
    CGFloat height = (width * showImageH)/showImageW;
    [self.showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgScrollView.mas_top).offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(height);
    }];
    self.showImageView.image = self.showImage;
    self.showImageView.hidden = YES;
}

#pragma mark - alloc UI


- (UISegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl  alloc] initWithItems:@[@"文字", @"原图"]];
        _segmentedControl.backgroundColor = UIColorFromRGB(0x00728E);
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.tintColor = UIColorFromRGB(0xFFFFFF);
        //选中的颜色
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x00728E)} forState:UIControlStateSelected];
        //未选中的颜色
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFFFFFF)} forState:UIControlStateNormal];
//        _segmentedControl.layer.borderWidth = SCALELINEH;
//        _segmentedControl.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
        
        [_segmentedControl addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segmentedControl];
    }
    return _segmentedControl;
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        [self.view addSubview:_bottomView];
        _bottomView.backgroundColor = UIColorFromRGB(0x2A2B31);
    }
    return _bottomView;
}

- (UIScrollView *)bgScrollView
{
    if (_bgScrollView == nil) {
        _bgScrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_bgScrollView];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.bounces = NO;
    }
    return _bgScrollView;
}

- (UIImageView *)showImageView
{
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc]init];
        [self.view addSubview:_showImageView];
        _showImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _showImageView;
}

#pragma mark -  btnClick

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//文字、原图
- (void)segmentedControl:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        self.bgScrollView.hidden = NO;
        self.showImageView.hidden = YES;
    }else{
        self.bgScrollView.hidden = YES;
        self.showImageView.hidden = NO;
    }
}

// 复制文字、导出图片
- (void)bottonClick:(UIButton *)button
{
    if (button.tag == 0) {//复制文字
        NSMutableArray *stringArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.dataArray) {
            [stringArray addObject:dict[@"words"]];
        }
        NSString *string = [stringArray componentsJoinedByString:@"\n"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = string;
        [CommonTool toastMessage:@"复制成功"];
    }else{//导出图片
        if(!self.showImage)return;
        UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
        UIImageWriteToSavedPhotosAlbum(self.showImage, nil, nil, nil);//然后将该图片保存到图片图
        [CommonTool toastMessage:@"导出成功!"];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
