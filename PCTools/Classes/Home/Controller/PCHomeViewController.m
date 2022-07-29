//
//  PCHomeViewController.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCHomeViewController.h"
#import "PCHomeMenuCell.h"
#import "PCHomeWeatherCell.h"

#import <WebKit/WebKit.h>
#import <AssetsLibrary/AssetsLibrary.h>//访问相册权限
#import <AVFoundation/AVCaptureDevice.h>//访问相机权限
@interface PCHomeViewController ()<UITableViewDataSource,UITableViewDelegate,PCHomeWeatherCellDelegate,PCHomeMenuCellDelegate,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) WKWebView *HwebView;

@property (nonatomic,strong) NSString *token;

@end

@implementation PCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainBgColor;
    [self setupSubViews];
}
- (CGFloat)screenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
- (CGFloat)screenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}
- (CGFloat)getBarBottomSafeHeight{
    return PCTabbarHeight - 49;
}
- (NSString *)getSaveData{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveData"];
    return str;
}
-(void)btnAction:(NSInteger)index title:(NSString *)currentTitle{
    [self openPageWithIndex:index andTitle:currentTitle];
}
-(void)setupSubViews{
    UIImageView*backImageView = [[UIImageView alloc]init];
    [self.view addSubview:backImageView];
    backImageView.backgroundColor = MainColor;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(87.5+PCNaviBarHeight);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"首页";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:19.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PCStatusBarHeight);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor =  [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PCHomeMenuCell class] forCellReuseIdentifier:@"PCHomeMenuCell"];
    [self.tableView registerClass:[PCHomeWeatherCell class] forCellReuseIdentifier:@"PCHomeWeatherCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(PCNaviBarHeight);
        make.height.mas_equalTo(self.view.frame.size.height-PCTabbarHeight-PCNaviBarHeight);
    }];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    self.tableView.estimatedRowHeight=10;
}
-(UITableView*)tableView{
    if(!_tableView){
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}
#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        static NSString *cellid = @"PCHomeWeatherCell";
        PCHomeWeatherCell*cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(cell== nil){
            cell= [[PCHomeWeatherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.delegate = self;
        return cell;
    }else{
        static NSString *cellid = @"PCHomeMenuCell";

        PCHomeMenuCell*cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell== nil){
            cell= [[PCHomeMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        if(indexPath.row == 1){
            cell.headerViewTitle = @"小工具";
            cell.dataArr = @[
                             @{@"title":@"设备信息",@"img":@"homeMenu_SBXX"},
                             @{@"title":@"网络测速",@"img":@"homeMenu_WLCS"},
                             @{@"title":@"手持弹幕",@"img":@"homeMenu_SCDM"},
                             @{@"title":@"全屏计时器",@"img":@"homeMenu_QPJSQ"},
                             @{@"title":@"拼长图",@"img":@"homeMenu_PCT"},
                             @{@"title":@"城市",@"img":@"homeMenu_DXSZ"},
            ];
        }else if(indexPath.row == 2){
            cell.headerViewTitle = @"娱乐";
            cell.dataArr = @[
                             @{@"title":@"今日禁忌",@"img":@"homeMenuJinJi"},
                             @{@"title":@"周公解梦",@"img":@"homeMenuJieMeng"},
                             @{@"title":@"手机号吉凶",@"img":@"homeMenuJiXiong"},
            ];
        }
        else if(indexPath.row == 3){
            cell.headerViewTitle = @"查一查";
            cell.dataArr = @[
                
                @{@"title":@"IP地址",@"img":@"homeMenuIP"},
                @{@"title":@"手机归属地",@"img":@"homeMenuGuiShuDi"},
                @{@"title":@"垃圾分类查询",@"img":@"homeMenu_LJFL"},
                @{@"title":@"大写数字",@"img":@"homeMenu_DXSZ"},
                @{@"title":@"我的位置",@"img":@"homeMenuWeiZhi"},
                @{@"title":@"文字识别",@"img":@"homeMenuWenZi"},
                @{@"title":@"票据识别",@"img":@"homeMenu_PJSB"},
                @{@"title":@"火车票查询",@"img":@"homeMenuTicket"},
                @{@"title":@"天天壁纸",@"img":@"homeMenuBiZhi"},
                             
            ];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 300;
    }else if(indexPath.row == 1){
        return 300;
    }else if(indexPath.row == 2){
        return 180;
    }
    else if(indexPath.row == 3){
        return 400;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark - UIWebViewDeleagte

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

#pragma mark - WKWebViewDeleagte

/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
}

/** 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

/** 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

/** 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
}

/* 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"--  %@",urlStr);
    
    NSRange range = [urlStr rangeOfString:@"www.WebH5bridgeLogin"];
    NSRange range1 = [urlStr rangeOfString:@"www.H5BridgeLoginOut.com"];
    NSRange range2 = [urlStr rangeOfString:@"www.H5BridgeOpenApp.com"];
    if (range.length > 0) {
        NSRange dataRange = [urlStr rangeOfString:@"?"];
        if (dataRange.length > 0) {
            NSString *str = [urlStr substringWithRange:NSMakeRange(dataRange.location + dataRange.length, urlStr.length - dataRange.location - dataRange.length)];
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"saveData"];
        }
    }
    if (range1.length > 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saveData"];
    }
    
    if (range2.length > 0) {
        NSRange dataRange = [urlStr rangeOfString:@"data="];
        if (dataRange.length > 0) {
            NSString *openUrl = [urlStr substringWithRange:NSMakeRange(dataRange.location + dataRange.length, urlStr.length - dataRange.location - dataRange.length)];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
            
            //不允许跳转
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    }
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

/* 在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"--%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    NSLog(@"createWebViewWithConfiguration");
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark -  更换
- (void)getChangeHeadImageUrlData
{
    //应用名称, 提示信息里会用到
    NSDictionary * mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
    
    UIAlertController*alertConntroller = [UIAlertController alertControllerWithTitle:nil message:@"修改头像" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertConntroller addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertConntroller dismissViewControllerWithAnimation];
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
    
    [alertConntroller addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertConntroller dismissViewControllerWithAnimation];
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
    
    [alertConntroller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}]];
    UIViewController * currentVC = [[CommonTool shareInstance] getCurrentVC];
    [currentVC presentViewController:alertConntroller animated:YES completion:^{
    }];
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
    
    NSString * url = [NSString stringWithFormat:@"%@/phpu/uploadImg.phpx?token=%@",@"http://h.5988cai.com",self.token];
    
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
            
            
            NSDictionary *RespDict = response[@"Resp"];
            int code = [NSString stringWithFormat:@"%@",response[@"code"]].intValue;
            NSString * desc = RespDict[@"desc"];
            
            if (code == 0){
                [CommonTool toastMessage:desc];
                [self.webView stringByEvaluatingJavaScriptFromString:@"h5Reload()"];
            }else{
                [CommonTool toastMessage:@"上传失败"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [PNCGifWaitView hideWaitViewInController:self];
    }];
}



@end
