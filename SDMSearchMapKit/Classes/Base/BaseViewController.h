//
//  BaseViewController.h
//  ANN
//
//  Created by Kyle Li on 2021/3/16.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
typedef NS_ENUM(NSInteger, requestStyle){
    requestLogin=101,
    requestLoginOut

};

@property(strong,nonatomic) MBProgressHUD *HUD;
@property(strong,nonatomic) UILabel *titleLabel;
@property(nonatomic ,strong)UIImageView *gifImage;
@property(nonatomic ,strong) UIView *activeView;
@property(nonatomic ,assign)BOOL isCanSideBack;
@property(nonatomic,strong)UIView*msgView;
@property(nonatomic,strong)UILabel*msglabel;
@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> *sessionDataTaskMArr;

/**
 *  发起请求
 *
 *  @param url   请求地址
 *  @param param 参数
 *  @param tag   请求tag
 */
-(void)requestData:(NSString*)url params:(NSDictionary *)param tag:(requestStyle)tag;
-(void)requestPostData:(NSString*)url params:(id)param tag:(requestStyle)tag;
-(void)requestPutData:(NSString*)url params:(id)param tag:(requestStyle)tag;
-(void)requestDeleteData:(NSString*)url params:(id)param tag:(requestStyle)tag;


/**
 *  请求成功
 *
 *  @param result 请求结果
 *  @param tag    请求tag
 */
-(void)requestSuccess:(NSDictionary *)result tag:(requestStyle )tag ;


-(void)FailSuccess:(NSDictionary *)result tag:(requestStyle)tag;
/**
 *  请求失败
 *
 *  @param tag 请求tag
 */
-(void)requestFaild:(requestStyle)tag;

// 打开外部链接
-(void)openScheme:(NSString *)scheme;
//提示框
-(void)AlertViewShowMsg:(NSString *)msg;
//退出登录
-(void)GotoLogin;
//清除缓存
- (void)cleanCacheAndCookie;
@end

NS_ASSUME_NONNULL_END
