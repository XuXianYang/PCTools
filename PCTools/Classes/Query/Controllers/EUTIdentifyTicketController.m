//
//  NCHelperTextPhotoController.m
//  NCCalculator
//
//  Created by 陈凯 on 2019/12/16.
//  Copyright © 2019 NongCai. All rights reserved.
//

#import "EUTIdentifyTicketController.h"
#import "EUTIdentifyResultController.h"
#import <AssetsLibrary/AssetsLibrary.h>//访问相册权限
#import <AVFoundation/AVCaptureDevice.h>//访问相机权限

@interface EUTIdentifyTicketController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/** UI */
/** 扫描框 */
@property(nonatomic, strong) UIImageView *saoMiaoImageView;
/** 拍照按钮 */
@property(nonatomic, strong) UIButton *photoBtn;

@end

@implementation EUTIdentifyTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.navigationItem.title = @"票据识别";
    [self eutSetupSubView];
}

#pragma mark -  contentView


- (void)eutSetupSubView
{
    [self.saoMiaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(EUTNaviBarHeight + 99);
    }];
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saoMiaoImageView.mas_bottom).offset(85);
        make.left.mas_equalTo(67.5);
        make.right.mas_equalTo(-67.5);
        make.height.mas_equalTo(45);
    }];
    
}

#pragma mark - alloc UI

- (UIImageView *)saoMiaoImageView
{
    if (_saoMiaoImageView == nil) {
        _saoMiaoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LittleHelper_saoMiao"]];
        [self.view addSubview:_saoMiaoImageView];
    }
    return _saoMiaoImageView;
}

- (UIButton *)photoBtn
{
    if (_photoBtn == nil) {
        _photoBtn =
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoBtn setTitle:@"票据识别拍照" forState:UIControlStateNormal];
        [_photoBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        _photoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_photoBtn setBackgroundColor:MainColor];
        [self.view addSubview:_photoBtn];
        
        _photoBtn.layer.cornerRadius = 5;
        _photoBtn.layer.masksToBounds = YES;
    }
    return _photoBtn;
}


- (void)photoBtnClick
{
    [self getPhotoFromLibrary];
}

#pragma mark -  文字识别拍照

- (void)getPhotoFromLibrary
{
    //应用名称, 提示信息里会用到
    NSDictionary * mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
    
    UIAlertController * selectImgAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [selectImgAlert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //相机功能
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            SHOWMESSAGE_(@"提示", @"该设备不支持相机功能");
            return;
        }
        //是否授权使用相机
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied)
        {
            NSString * title = [NSString stringWithFormat:@"%@没有权限访问相机", appName];
            NSString * message = [NSString stringWithFormat:@"请进入系统 好友分享>隐私>相机 允许\"%@\"访问您的相机",appName];
            SHOWMESSAGE_(title, message);
            return;
        }
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        
        UIViewController * currentVC = [[CommonTool shareInstance] getCurrentVC];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [currentVC presentViewController:pickerImage animated:YES completion:nil];
    }]];
    
    [selectImgAlert addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //是否支持相册功能
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            SHOWMESSAGE_(@"提示", @"该设备不支持相册功能");
            return;
        }
        
        //是否授权访问照片
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusDenied)
        {
            NSString * title = [NSString stringWithFormat:@"%@没有权限访问照片", appName];
            NSString * message = [NSString stringWithFormat:@"请进入系统 好友分享>隐私>照片 允许\"%@\"访问您的照片",appName];
            SHOWMESSAGE_(title, message);
            return;
        }
        
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        
        UIViewController * currentVC = [[CommonTool shareInstance] getCurrentVC];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [currentVC presentViewController:pickerImage animated:YES completion:nil];
       
    }]];
    
    [selectImgAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}]];
    selectImgAlert.view.tintColor = UIColorFromRGB(0x000000);
    [self presentViewController:selectImgAlert animated:YES completion:nil];

}

#pragma mark - Imagepicker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData * headImageData = UIImageJPEGRepresentation(image, 1.0);

    //1M = 1024K
    NSUInteger headImageSize = headImageData.length;
    if (headImageSize > 1024 * 4 * 1024)
    {
        UIImage * compressImage = [[CommonTool shareInstance] compressImage:image toTargetWidth:kScreenW];
        headImageData = UIImageJPEGRepresentation(compressImage, 0.5);
        headImageSize = headImageData.length;

        if (headImageSize > 1024 * 4 * 1024){
            SHOWMESSAGE_(@"提示",@"图片过大超过4M, 请重新选择图片");
            return;
        }
    }

    //上传图片
    [PNCGifWaitView showWaitViewInController:self style:DefaultWaitStyle];
    NSString *url = [NSString stringWithFormat:@"%@/%@",PCBaseUrl,EUTTicketIdentifyUrl];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSSet *set = [NSSet setWithObjects:@"text/xml",@"application/xml",@"application/json", @"text/json",@"text/html", @"text/plain",@"application/x-javascript",nil];
    if (set != nil && [set isKindOfClass:[NSSet class]])
    {
        manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = set;
    }
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //采用时间来防止名字重复
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:headImageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [PNCGifWaitView hideWaitViewInController:self];
        if ([responseObject isKindOfClass:[NSData class]]){
            id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if([response[@"status"] isEqualToString:@"0000"]){
                EUTIdentifyResultController *textVC = [[EUTIdentifyResultController alloc] init];
                textVC.dataArray = response[@"data"][@"words_result"];
                textVC.showImage = [UIImage imageWithData:headImageData];
                [[[CommonTool shareInstance] getMainController] pushViewController:textVC animated:YES];
            }else{
                [CommonTool toastMessage:@"识别失败，请重新上传"];
            }
        }else{
            [CommonTool toastMessage:@"识别失败，请重新上传"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [PNCGifWaitView hideWaitViewInController:self];
        [CommonTool toastMessage:@"识别失败，请重新上传"];
    }];
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
