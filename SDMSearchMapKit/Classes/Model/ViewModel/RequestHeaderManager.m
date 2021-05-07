//
//  HeaderManager.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import "RequestHeaderManager.h"

@implementation RequestHeaderManager
+ (RequestHeaderManager *)defaultManager
{
    static dispatch_once_t once_t = 0;
    __strong static id defaultHeadManager = nil;
    dispatch_once(&once_t, ^{
        defaultHeadManager = [[self alloc] init];
    });
    return defaultHeadManager;
}
-(void)setRequestUrl:(NSString *)requestUrl{
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
    [userDefaults setValue:requestUrl forKey:@"requestUrl"];
    self.requestUrl=requestUrl;
}
-(NSDictionary*)defaultheader{
    
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.openid.appauth.Example"];
    //NSData *archivedAuthState = [userDefaults objectForKey:kAppAuthExampleAuthStateKey];
    //OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
    NSString*token=[userDefaults objectForKey:kAppAuthExampleAuthStateKey];
    
    //BOOL isStationIDMLoggedIn = [[userDefaults objectForKey:@"IsStationIDM"] boolValue];
//    if (!isStationIDMLoggedIn) {
//        if (!authState.lastTokenResponse.accessToken) {
//            return nil;
//        }
//
//    }
//    NSString* StationIDMToken = [userDefaults objectForKey:@"StationIDM"] ;
//    if (!StationIDMToken&&!authState.lastTokenResponse.accessToken) {
//
//        return nil;
//    }
    if (!token) {
        return nil;
    }
    NSDictionary*header=@{
        @"Authorization": token,@"Content-Type":@"application/json"
    };
    return header;

}
@end
