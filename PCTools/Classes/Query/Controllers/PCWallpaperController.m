//
//  PCWallpaperController.m
//  PCTools
//
//  Created by apple on 2019/12/21.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCWallpaperController.h"

@interface PCWallpaperController ()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *refreshBtn;
@property(nonatomic,strong)UIButton *downloadBtn;

@end

@implementation PCWallpaperController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"天天壁纸";
    [self setupSubViews];
    [self getImageData:NO];
}
-(void)queryBtnAction:(UIButton*)btn{
    if(btn == self.refreshBtn){
        [self getImageData:YES];
    }else{
        if(!self.imageView.image)return;
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(!error){
        [PNCGifWaitView hideWaitViewInController:self];
       [CommonTool toastMessage:@"保存成功"];
    }else{
        [CommonTool toastMessage:@"保存失败"];
        [PNCGifWaitView hideWaitViewInController:self];
    }
}
-(void)getImageData:(BOOL)isRefreshCached{
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    [PCRequestTool postAllUrl:PCWallpaperUrl params:nil success:^(id responsebject) {
        [PNCGifWaitView hideWaitViewInController:self];
        if([responsebject[@"status"] isEqualToString:@"0000"]){
            NSString *imgUrl = responsebject[@"data"][@"imgUrl"];
            imgUrl = [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            if(isRefreshCached){
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil options:SDWebImageRefreshCached];
            }else{
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
            }
        }
    } failure:^(NSError *error) {
        [PNCGifWaitView hideWaitViewInController:self];
    }];
}
-(void)setupSubViews{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, PCNaviBarHeight, kScreenW, kScreenH - PCNaviBarHeight)];
    [self.view addSubview:self.imageView];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat btnWidth = (kScreenW - 80)/2;
    for(NSInteger i=0 ;i<2 ;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(queryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 20+i;
        if(i == 0){
            [btn setTitle:@"刷新" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"orangeBtnBg"] forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-PCTabbarHeight);
                make.centerX.equalTo(self.view.mas_left).offset(kScreenW/4);
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(45);
            }];
            self.refreshBtn = btn;
        }else{
            [btn setTitle:@"下载" forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"blueBtnBg"] forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-PCTabbarHeight);
                make.centerX.equalTo(self.view.mas_left).offset(kScreenW/4*3);
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(45);
            }];
            self.downloadBtn = btn;
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
@end
