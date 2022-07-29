//
//  EUTSpellLongFigureController.m
//  EUTTools
//
//  Created by apple on 2020/1/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTSpellLongFigureController.h"
#import "ZYQAssetPickerController.h"

@interface EUTSpellLongFigureController ()<ZYQAssetPickerControllerDelegate>

@property(nonatomic,strong)UIScrollView *bgScrollView;
@property(nonatomic,retain)NSMutableArray *imageArr;
@property(nonatomic,strong)UIButton *btn;

@end

@implementation EUTSpellLongFigureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"拼长图";
    [self eutSetupSubViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self selectPictures];
}
-(NSMutableArray*)imageArr{
    if(!_imageArr){
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
-(void)eutSetupSubViews{
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, EUTNaviBarHeight, kScreenW, kScreenH - EUTNaviBarHeight)];
    [self.view addSubview:self.bgScrollView];
    if (@available(iOS 11.0, *)){
        self.bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:SP(16)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnbg"] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(eutQueryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(PCTabbarHeight-49)-20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW - 40);
        make.height.mas_equalTo(SP(45));
    }];
    self.btn = btn;
    self.btn.hidden = YES;
}
// 本地相册选择多张照片
- (void)selectPictures{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    //picker.maximumNumberOfSelection = 9-_imageArray.count;
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]){
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self presentViewController:picker animated:YES completion:^{}];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker{
    if (@available(iOS 11, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController popViewControllerAnimated:NO];
}
//获取图片
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if (@available(iOS 11, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    dispatch_async(dispatch_get_main_queue(), ^{
        [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger count = assets.count>=9 ? 9 : assets.count;
        
        [self.imageArr removeAllObjects];
        for (int i=0; i<count; i++)
        {
            ALAsset *asset = assets[i];
            //查看资源的url路径
            //NSString* str =  [asset valueForProperty:ALAssetPropertyAssetURL];
            UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [self.imageArr addObject:tempImg];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showImg];
        });
    });
}
//展示拼接后的图片
-(void)showImg{
    if(self.imageArr.count == 0){
        self.btn.hidden = YES;
        return;
    }
    self.btn.hidden = NO;
    CGFloat totalH = 0;
    for(NSInteger i = 0; i<self.imageArr.count;i++){
        UIImage *tempImg = self.imageArr[i];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:tempImg];
        CGFloat imageViewH = kScreenW*tempImg.size.height/tempImg.size.width;
        [self.bgScrollView addSubview:imageView];
        imageView.frame = CGRectMake(0, totalH, kScreenW, imageViewH);
        totalH = totalH + imageViewH;
    }
    self.bgScrollView.contentSize = CGSizeMake(kScreenW, totalH);
    [PNCGifWaitView hideWaitViewInController:self];
}
//保存
-(void)eutQueryBtnAction{
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    UIImage *image2 = [self screenShotWithSize:self.bgScrollView.contentSize];
    
    NSData* imageData =  UIImagePNGRepresentation(image2);
    UIImage *newImage = [UIImage imageWithData:imageData];
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [PNCGifWaitView hideWaitViewInController:self];
    if(error){
        [CommonTool toastMessage:@"保存失败!"];
    }else{
        [CommonTool toastMessage:@"保存成功!"];
    }
}
//生成长图方法
- (UIImage *)screenShotWithSize:(CGSize )size {
    UIImage* image = nil;
    /*
     *UIGraphicsBeginImageContextWithOptions有三个参数
     *size    bitmap上下文的大小，就是生成图片的size
     *opaque  是否不透明，当指定为YES的时候图片的质量会比较好
     *scale   缩放比例，指定为0.0表示使用手机主屏幕的缩放比例
     */
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    //保存tableView当前的偏移量
    CGPoint savedContentOffset = self.bgScrollView.contentOffset;
    CGRect saveFrame = self.bgScrollView.frame;
    
    //将tableView的偏移量设置为(0,0)
    self.bgScrollView.contentOffset = CGPointZero;
    self.bgScrollView.frame = CGRectMake(0, EUTNaviBarHeight, self.bgScrollView.contentSize.width, self.bgScrollView.contentSize.height);
    //在当前上下文中渲染出tableView
    [self.bgScrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //恢复tableView的偏移量
    self.bgScrollView.frame = saveFrame;
    [self.bgScrollView setContentOffset:savedContentOffset animated:NO];
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}

-(void)dealloc{
    if (@available(iOS 11, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
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
