//
//  BaseViewModel.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import <Foundation/Foundation.h>
#import "APIModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewModel : NSObject

/**
 *  发起请求

 */
-(void)requestData:(APIModel*)model succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

//退出登录
-(void)GotoLogin;

-(void)ShowHuD;
-(void)HideHuD;
@end

NS_ASSUME_NONNULL_END
