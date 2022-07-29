/**
demo.mg
*/

class PCHomeViewController : PCBaseViewController{
/*
- (void)viewDidLoad {
    super.viewDidLoad();
    self.view.backgroundColor = UIColor.blueColor();
    self.setupSubViews();
}
*/

- (void)setupSubViews
{
    UIWebView *webView = UIWebView.alloc().initWithFrame:(CGRectMake(0, 0, self.screenWidth(), self.screenHeight() - self.getBarBottomSafeHeight()));
    webView.delegate = self;

    NSString *urlStr = @"http://m.5988cai.com/#/?appOpen=1";
    NSString *string = self.getSaveData();
    NSString *str;
    if (string.length > 1){
        str = urlStr + @"&" + string;
    }else{
        str = urlStr;
    }
    NSURLRequest *request = NSURLRequest.requestWithURL:(NSURL.URLWithString:(str));
    webView.loadRequest:(request);
    self.webView = webView;
    UIApplication.sharedApplication.keyWindow.addSubview:(webView);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;

    NSRange range = urlStr.rangeOfString:(@"www.WebH5bridgeLogin");
    NSRange range1 = urlStr.rangeOfString:(@"www.H5BridgeLoginOut.com");
    NSRange range2 = urlStr.rangeOfString:(@"www.H5BridgeOpenApp.com");
    NSRange range3 = urlStr.rangeOfString:(@"WebH5bridgeChageUserImg");
    if (range.length > 0) {
        NSRange dataRange = urlStr.rangeOfString:(@"?");
        if (dataRange.length > 0) {
        NSString *str = urlStr.substringWithRange:(NSMakeRange(dataRange.location + dataRange.length, urlStr.length - dataRange.location - dataRange.length));
        NSUserDefaults.standardUserDefaults.setObject:forKey:(str,@"saveData");
        }
    }
    if (range1.length > 0) {
        NSUserDefaults.standardUserDefaults.removeObjectForKey:(@"saveData");
    }
    
    if (range2.length > 0) {
           NSRange dataRange = urlStr.rangeOfString:(@"data=");
           if (dataRange.length > 0) {
               NSString *openUrl = urlStr.substringWithRange:(NSMakeRange(dataRange.location + dataRange.length, urlStr.length - dataRange.location - dataRange.length));
               UIApplication.sharedApplication.openURL:(NSURL.URLWithString:(openUrl));
               return NO;
           }
       }
       if (range3.length > 0) {
           NSRange range = urlStr.rangeOfString:(@"data=");
           if (range.length > 0) {
               NSString *token = urlStr.substringFromIndex:(range.location + range.length);
               self.token = token;
           }
           self.getChangeHeadImageUrlData();
           return NO;
       }
       
    return YES;
}



}



