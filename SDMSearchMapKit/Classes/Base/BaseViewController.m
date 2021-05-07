//
//  BaseViewController.m
//  ANN
//
//  Created by Kyle Li on 2021/3/16.
//

#import "BaseViewController.h"
#import "SDImageCache.h"
@interface BaseViewController ()<UINavigationControllerDelegate>


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
   // [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]  forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

   // [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];


    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];

    self.titleLabel = [[UILabel alloc] initWithFrame:view.bounds];

    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    [view addSubview:self.titleLabel];
    self.navigationItem.titleView=view;
    
    self.titleLabel.font=[UIFont fontWithName:@"ToyotaTypeW02-Semibold" size:16];
    if (DEF_PERSISTENT_GET_OBJECT(@"userLat")==nil) {
        [[ToolManager shareManager] starLocationResult:nil];
    }
    
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    _msgView=[[UIView alloc]init];
    [window addSubview:_msgView];
    _msgView.hidden=YES;
    _msglabel=[[UILabel alloc]init];
    _msglabel.numberOfLines = 0;
    _msglabel.textAlignment=NSTextAlignmentCenter;
    _msglabel.font = [UIFont systemFontOfSize:16];
    _msglabel.lineBreakMode = NSLineBreakByWordWrapping;
    _msglabel.textColor = [UIColor whiteColor];
    _msglabel.backgroundColor = [UIColor clearColor];
    _msglabel.alpha = 1.0;
  
    [self.msgView addSubview:_msglabel];
    
    
   
}

- (NSMutableArray *)sessionDataTaskMArr {
if (_sessionDataTaskMArr == nil) {
    _sessionDataTaskMArr = [NSMutableArray array];
    
    }
    return _sessionDataTaskMArr;
}
-(void)addSessionDataTask:(NSURLSessionDataTask *)task{
    if (task==nil) {
        return;
    }
    [self.sessionDataTaskMArr addObject:task];
}

-(void)cancelAllSessionDataTask{
    if (self.sessionDataTaskMArr.count==0) {
        return;
    }
    for (NSURLSessionDataTask*datatask in self.sessionDataTaskMArr) {
        if (datatask.state == NSURLSessionTaskStateRunning || datatask.state ==NSURLSessionTaskStateSuspended ) {
            [datatask cancel];
    }
        [self.sessionDataTaskMArr removeAllObjects];
}
}


-(void)AlertViewShowMsg:(NSString *)msg{
    kWeakSelf;
    // size the message label according to the length of the text
    
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
        weakSelf.msglabel.text =msg;

    [weakSelf.view bringSubviewToFront:weakSelf.msgView];
    CGSize expectedSizeMessage = [msg sizeWithFont:weakSelf.msglabel.font maxW:SCREEN_WIDTH *0.8-20];
    weakSelf.msglabel.frame = CGRectMake(10.0, 10.0, expectedSizeMessage.width, expectedSizeMessage.height);
    weakSelf.msgView.bounds=CGRectMake(0.0, 0.0, expectedSizeMessage.width+20, expectedSizeMessage.height+20);
    weakSelf.msgView.center=self.view.center;
    weakSelf.msgView.backgroundColor=[UIColor colorWithWhite:0.1 alpha:1];
    weakSelf.msgView.layer.cornerRadius=5;
    weakSelf.msgView.layer.masksToBounds=YES;
        weakSelf.msgView.hidden=NO;
   [weakSelf performSelector:@selector(HiddenMesgView) withObject:self.msgView afterDelay:3];
    });
}
-(void)HiddenMesgView{
    kWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.msgView.hidden=YES;
    });
   
}


-(MBProgressHUD*)HUD{
    if (!_HUD) {
      //  UIWindow*window=[UIApplication sharedApplication].keyWindow;
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view bringSubviewToFront:_HUD];
        [self.view addSubview:_HUD];
    }
    return _HUD;
}
////数据请求
//-(void)requestData:(NSString*)url params:(NSDictionary *)param tag:(requestStyle)tag
//{
//    kWeakSelf;
//    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
//    NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthExampleAuthStateKey];
//    OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
//    BOOL isStationIDMLoggedIn = [[userDefaults objectForKey:@"IsStationIDM"] boolValue];
//
//    if (!isStationIDMLoggedIn) {
//        if (!authState.lastTokenResponse.accessToken) {
//            return;
//        }
//    }
//    NSString* StationIDMToken = [userDefaults objectForKey:@"StationIDM"] ;
//    if (!StationIDMToken&&!authState.lastTokenResponse.accessToken) {
//        [self GotoLogin];
//
//        return;
//    }
//    NSDictionary*header=@{
//        @"Authorization": isStationIDMLoggedIn ? StationIDMToken :authState.lastTokenResponse.accessToken
//    };
//    [self.HUD showAnimated:YES];
//
//    [[HttpManager defaultManager] getNetworkRequestWithUrlString:url headers:header parameters:param isCache:NO succeed:^(id data) {
//        [weakSelf.HUD hideAnimated:YES];
//
//        if ([[data objectForKey:@"code"] isEqualToString:@"200"]) {
//
//            [weakSelf requestSuccess:data tag:tag];
//
//        }
//        if ([[data objectForKey:@"code"] isEqualToString:@"400"]) {
//            NSString*string=[data objectForKey:@"message"];
//            [weakSelf AlertViewShowMsg:string];
//        }
//        if ([[data objectForKey:@"code"] isEqualToString:@"401"]) {
//            [weakSelf GotoLogin];
//
//        }
//    } fail:^(NSError *error) {
//        [weakSelf.HUD hideAnimated:YES];
//        NSString*string=@"The request failed. Please check the network";
//         [weakSelf AlertViewShowMsg:string];
//
//
//    }];
//
//
//}
////数据请求
//-(void)requestPostData:(NSString*)url params:(id)param tag:(requestStyle)tag
//{
//    kWeakSelf;
//
//    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
//    NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthExampleAuthStateKey];
//    OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
//
//
//    BOOL isStationIDMLoggedIn = [[userDefaults objectForKey:@"IsStationIDM"] boolValue];
//    if (!isStationIDMLoggedIn) {
//        if (!authState.lastTokenResponse.accessToken) {
//            return;
//        }
//
//    }
//    NSString* StationIDMToken = [userDefaults objectForKey:@"StationIDM"] ;
//    if (!StationIDMToken&&!authState.lastTokenResponse.accessToken) {
//        [self GotoLogin];
//
//        return;
//    }
//    NSDictionary*header=@{
//        @"Authorization": isStationIDMLoggedIn ? StationIDMToken :authState.lastTokenResponse.accessToken
//    };
//    [self.HUD showAnimated:YES];
//
//    [[HttpManager defaultManager] postNetworkRequestWithUrlString:url headers:header parameters:param isCache:NO succeed:^(id data) {
//        [weakSelf.HUD hideAnimated:YES];
//
//        if ([[data objectForKey:@"code"] isEqualToString:@"200"]) {
//
//            [weakSelf requestSuccess:data tag:tag];
//        }
//        if ([[data objectForKey:@"code"] isEqualToString:@"400"]) {
//            NSString*string=[data objectForKey:@"message"];
//            [weakSelf AlertViewShowMsg:string];
//        }
//        if ([[data objectForKey:@"code"] isEqualToString:@"401"]) {
//            [weakSelf GotoLogin];
//
//        }
//
//    } fail:^(NSError *error) {
//        [weakSelf.HUD hideAnimated:YES];
//        NSString*string=@"The request failed. Please check the network";
//         [weakSelf AlertViewShowMsg:string];
//
//
//        }];
//
//
//
//
//}
//-(void)requestPutData:(NSString *)url params:(id)param tag:(requestStyle)tag{
//    kWeakSelf;
//
//    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
//    NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthExampleAuthStateKey];
//    OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
//
//
//    BOOL isStationIDMLoggedIn = [[userDefaults objectForKey:@"IsStationIDM"] boolValue];
//    if (!isStationIDMLoggedIn) {
//        if (!authState.lastTokenResponse.accessToken) {
//            return;
//        }
//
//    }
//    NSString* StationIDMToken = [userDefaults objectForKey:@"StationIDM"] ;
//    if (!StationIDMToken&&!authState.lastTokenResponse.accessToken) {
//        [self GotoLogin];
//
//        return;
//    }
//    NSDictionary*header=@{
//        @"Authorization": isStationIDMLoggedIn ? StationIDMToken :authState.lastTokenResponse.accessToken
//    };
//    [self.HUD showAnimated:YES];
//
//    [[HttpManager defaultManager] putNetworkRequestWithUrlString:url headers:header parameters:param isCache:NO succeed:^(id data) {
//        [weakSelf.HUD hideAnimated:YES];
//
//        if ([[data objectForKey:@"code"] isEqualToString:@"200"]) {
//
//            [weakSelf requestSuccess:data tag:tag];
//        }
//        if ([[data objectForKey:@"code"] isEqualToString:@"400"]) {
//            NSString*string=[data objectForKey:@"message"];
//            [weakSelf AlertViewShowMsg:string];
//        }
//        if ([[data objectForKey:@"code"] isEqualToString:@"401"]) {
//            [weakSelf GotoLogin];
//
//        }
//
//    } fail:^(NSError *error) {
//        [weakSelf.HUD hideAnimated:YES];
//        NSString*string=@"The request failed. Please check the network";
//         [weakSelf AlertViewShowMsg:string];
//
//        }];
//
//}
//-(void)requestDeleteData:(NSString *)url params:(id)param tag:(requestStyle)tag{
//    kWeakSelf;
//
//    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
//    NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthExampleAuthStateKey];
//    OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
//
//
//    BOOL isStationIDMLoggedIn = [[userDefaults objectForKey:@"IsStationIDM"] boolValue];
//    if (!isStationIDMLoggedIn) {
//        if (!authState.lastTokenResponse.accessToken) {
//            return;
//        }
//
//    }
//    NSString* StationIDMToken = [userDefaults objectForKey:@"StationIDM"] ;
//    if (!StationIDMToken&&!authState.lastTokenResponse.accessToken) {
//        [self GotoLogin];
//        return;
//    }
//    NSDictionary*header=@{
//        @"Authorization": isStationIDMLoggedIn ? StationIDMToken :authState.lastTokenResponse.accessToken
//    };
//    [self.HUD showAnimated:YES];
//
//    [[HttpManager defaultManager] DeleteNetworkRequestWithUrlString:url headers:header parameters:param isCache:NO succeed:^(id data) {
//        [weakSelf.HUD hideAnimated:YES];
//
//        if ([[data objectForKey:@"code"] isEqualToString:@"200"]) {
//
//            [weakSelf requestSuccess:data tag:tag];
//
//        }
//        if ([[data objectForKey:@"code"] isEqualToString:@"400"]) {
//            NSString*string=[data objectForKey:@"message"];
//            [weakSelf AlertViewShowMsg:string];
//
//        }
//        if ([[data objectForKey:@"code"] isEqualToString:@"401"]) {
//            [weakSelf GotoLogin];
//
//        }
//
//    } fail:^(NSError *error) {
//        [weakSelf.HUD hideAnimated:YES];
//        NSString*string=@"The request failed. Please check the network";
//         [weakSelf AlertViewShowMsg:string];
//
//        }];
//
//}
/**
 *  请求成功
 *
 *  @param result 请求结果
 *  @param tag    请求tag
 */
-(void)requestSuccess:(NSDictionary *)result tag:(requestStyle)tag
{
    
}

- (void)tt_requestSuccess:(NSDictionary *)result tag:(requestStyle)tag
{
}
//返回201
-(void)FailSuccess:(NSDictionary *)result tag:(requestStyle)tag{
    
}
/**
 *  请求失败
 */
-(void)requestFaild:(requestStyle)tag
{
    
}
-(void)GotoLogin{
//    kWeakSelf;
//    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
//
//    SDMLoginViewController*vc=[[SDMLoginViewController alloc]init];
//    DEF_PERSISTENT_REMOVE_ALLDATA;
//    NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthExampleAuthStateKey];
//
//    OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
//
//    BOOL isStationIDMLoggedIn = [[userDefaults objectForKey:@"IsStationIDM"] boolValue];
//    NSString *StationIDMToken = [userDefaults objectForKey:@"StationIDM"];
//    
//    [userDefaults removeObjectForKey:FavoriteData];
//    [userDefaults removeObjectForKey:HistoryData];
//    
//    if (isStationIDMLoggedIn&&StationIDMToken) {
//     
//        [userDefaults removeObjectForKey:@"IsStationIDM"];
//        [userDefaults removeObjectForKey:@"StationIDM"];
//
//        [userDefaults synchronize];
//       // AppDelegate *appDelegate =
//         //   (AppDelegate *)[UIApplication sharedApplication].delegate;
//       // appDelegate.window.rootViewController=vc;
//        [weakSelf AlertViewShowMsg:@"Token is invalid. Please login again"];
//    }
//    if (authState.lastTokenResponse.accessToken) {
//        [userDefaults removeObjectForKey:kAppAuthExampleAuthStateKey];
//        [userDefaults synchronize];
//
//  //  AppDelegate *appDelegate =
//      //  (AppDelegate *)[UIApplication sharedApplication].delegate;
//   // appDelegate.window.rootViewController=vc;
//    [weakSelf AlertViewShowMsg:@"Token is invalid. Please login again"];
//    }
    return;

}
// 打开外部链接
-(void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        }];
    
}
/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    if ([[[UIDevice currentDevice] systemVersion]intValue ] > 8) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeCookies]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[HttpManager defaultManager] clearCacheFlies];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.msgView removeFromSuperview];
}
-(void)dealloc{
    
    [self cancelAllSessionDataTask];
    NSLog(@"释放了-------%@", NSStringFromClass([self class]));
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
