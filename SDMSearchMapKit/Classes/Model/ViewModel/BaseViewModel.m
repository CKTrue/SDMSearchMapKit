//
//  BaseViewModel.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import "BaseViewModel.h"
@implementation BaseViewModel

-(void)ShowHuD{
   // AppDelegate *appDelegate =
     //   (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
}
-(void)HideHuD{
    //AppDelegate *appDelegate =
    //    (AppDelegate *)[UIApplication sharedApplication].delegate;
   // [MBProgressHUD hideHUDForView:appDelegate.window animated:YES];
}

//数据请求
-(void)requestData:(APIModel *)model succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    kWeakSelf;
   
   
    if (model.header==nil) {
        [self GotoLogin];
    }
    
    [self ShowHuD];
    
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];

    NSString*baseurl=[userDefaults objectForKey:@"RequestUrl"];
    model.path=[NSString stringWithFormat:@"%@/%@",baseurl,model.path];
      [[HttpManager defaultManager] requestType:model.httpMethod url:model.path headers:model.header parameters:model.body isCache:NO cacheTime:0 succeed:^(id data) {
        
        [weakSelf HideHuD];
        if ([[data objectForKey:@"code"] isEqualToString:@"200"]) {
        
            if (succeed) {
                succeed(data);
            }
            
        }
        if ([[data objectForKey:@"code"] isEqualToString:@"400"]) {
            NSString*string=[data objectForKey:@"message"];
            if (succeed) {
                succeed(nil);
            }
            alertShowNOcancelBtn(nil,string);

        }
        if ([[data objectForKey:@"code"] isEqualToString:@"401"]) {
            [weakSelf GotoLogin];
           

        }
    } fail:^(NSError *error) {
        [weakSelf HideHuD];
        NSString*string=@"The request failed. Please check the network";
        if (fail) {
            fail(error);
        }
        alertShowNOcancelBtn(nil,string);


    }];
    
}

-(void)GotoLogin{
   // kWeakSelf;
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
//        AppDelegate *appDelegate =
//            (AppDelegate *)[UIApplication sharedApplication].delegate;
//        appDelegate.window.rootViewController=vc;
//    }
//    if (authState.lastTokenResponse.accessToken) {
//        [userDefaults removeObjectForKey:kAppAuthExampleAuthStateKey];
//        [userDefaults synchronize];
//
//
//    AppDelegate *appDelegate =
//        (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.window.rootViewController=vc;
//    }
//    return;
//
}


@end
