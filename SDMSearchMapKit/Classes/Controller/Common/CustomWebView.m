//
//  CustomWebView.m
//  Icommunity
//
//  Created by CKTrue on 2017/11/6.
//  Copyright © 2017年 njsg. All rights reserved.
//

#import "CustomWebView.h"

@interface CustomWebView ()<WKNavigationDelegate>

@end

@implementation CustomWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CreateUI];
    [self.HUD showAnimated:YES];
    self.titleLabel.text=self.titleStr;

}


-(void)CreateUI{
    _webView=[[WKWebView alloc]init];
    //_webView.configuration=configuation;
    [self.view addSubview:_webView];
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
  
    [_webView loadRequest:request];
    
}

#pragma mark  ------webview代理
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
  
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    NSString *lastName =[[self.urlString lastPathComponent] lowercaseString];
//
//    if ([lastName containsString:@".pdf"])
//     {
//       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlString]];
//
//        if (@available(iOS 9.0, *)) {
//            [self.webView loadData:data MIMEType:@"application/pdf" characterEncodingName:@"GBK" baseURL:nil];
//        }
//    }
    DSLog(@"----------------%@",navigationAction.request.URL);
    NSString *urlStr=[NSString stringWithFormat:@"%@",navigationAction.request.URL];
    if([urlStr  isEqualToString:@"https://auth.kdi-libratest.com/logout"]){
        [self cleanCacheAndCookie];
        [self GotoLogin];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

    // 在收到响应开始加载后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
    {
        
        [self.HUD hideAnimated:YES];

        decisionHandler(WKNavigationResponsePolicyAllow);


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
