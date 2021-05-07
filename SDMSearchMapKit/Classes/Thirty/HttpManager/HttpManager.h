//
//  HttpManager.h
//  Chinaware
//
//  Created by 岳永超 on 15/7/1.
//  Copyright (c) 2015年 yungui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> //md5加密
#import "NSString+Addition.h"
#import "NSObject+YCCategory.h"
#import "Reachability.h"
#pragma mark-- 请求工具类-
@interface HttpManager : NSObject
typedef NS_ENUM(NSInteger, NetworkRequestType) {
    NetworkRequestTypeGET,  // GET请求
    NetworkRequestTypePOST,  // POST请求
    NetworkRequestTypePUT,
    NetworkRequestTypeDELETE
};

+ (HttpManager *_Nullable)defaultManager;
/**
 *  判断当前的网络类型
 *
 *  @return NotReachable     - 没有网络连接
 *  @return ReachableViaWWAN - 移动网络(2G、3G)
 *  @return ReachableViaWiFi - WIFI网络
 */
- (NetworkStatus)networkStatus;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  Get请求 <若开启缓存，先读取本地缓存数据，再进行网络请求>
 *
 *  @param urlString  请求地址
 *  @param parameters 拼接的参数
 *  @param isCache    是否开启缓存
 *  @param succeed    请求成功
 *  @param fail       请求失败
 */
-(void)getNetworkRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

/**
 *  Get请求 <在缓存时间之内只读取缓存数据，不会再次网络请求，减少服务器请求压力。缺点：在缓存时间内服务器数据改变，缓存数据不会及时刷新>
 *
 *  @param urlString  请求地址
 *  @param parameters 拼接的参数
 *  @param time       缓存时间（单位：分钟）
 *  @param succeed    请求成功
 *  @param fail       请求失败
 */
-(void)getCacheRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers parameters:(id)parameters cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

/**
 *  Post请求 <若开启缓存，先读取本地缓存数据，再进行网络请求，>
 *
 *  @param urlString  请求地址
 *  @param parameters 拼接的参数
 *  @param isCache    是否开启缓存机制
 *  @param succeed    请求成功
 *  @param fail       请求失败
 */
-(void)postNetworkRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

/**
 *  Post请求 <在缓存时间之内只读取缓存数据，不会再次网络请求，减少服务器请求压力。缺点：在缓存时间内服务器数据改变，缓存数据不会及时刷新>
 *
 *  @param urlString  请求地址
 *  @param parameters 拼接的参数
 *  @param time       缓存时间（单位：分钟）
 *  @param succeed    请求成功
 *  @param fail       请求失败
 */
-(void)postCacheRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers parameters:(id)parameters cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

/**
 *  PUT请求 
 *
 *  @param urlString  请求地址
 *  @param parameters 拼接的参数
 *  @param time       缓存时间（单位：分钟）
 *  @param succeed    请求成功
 *  @param fail       请求失败
 */
-(void)putNetworkRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

/**
 *  DELETE请求
 *
 *  @param urlString  请求地址
 *  @param parameters 拼接的参数
 *  @param time       缓存时间（单位：分钟）
 *  @param succeed    请求成功
 *  @param fail       请求失败
 */
-(void)DeleteNetworkRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;


/**
 *  上传图片
 *
 *  @param URLString  请求地址
 *  @param parameters 拼接的参数
 @param       files     wenjian
 *  @param progress   上传进度(writeKB：已上传多少KB, totalKB：总共多少KB)
 *  @param succeed    上传成功
 *  @param fail       上传失败
 */
-(void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                      files:(NSArray *)files
                   progress:(void (^)(float writeKB, float totalKB)) progress
                   succeed:(void (^)(void))succeed
                       fail:(void (^)(NSError *error))fail;
/**
 *  上传图片
 *
 *  @param urlStr  请求地址
 *  @param succeed    上传成功
 *  @param fail       上传失败
 */
-(void)UploadVoicefileWithUrlString:(NSString*)urlStr
                         parameters:(id)parameters
                      WithVoiceData:(NSData*)data
                           progress:(void(^)(NSProgress * _Nonnull uploadProgress))process
                            succeed:(void(^)(id data))succeed
                               fail:(void(^)(NSError *error))fail;
/**
 *  清理缓存
 */
-(void)clearCacheFlies;

/**
 *  获取网络缓存文件大小
 *
 *  @return 多少KB
 */
-(float)getCacheFileSize:(NSString*)folderPath;
////数据请求
-(void)requestType:(NetworkRequestType)type url:(NSString *_Nullable)urlString headers:(NSDictionary*_Nullable)headers parameters:(id _Nullable )parameters isCache:(BOOL)isCache cacheTime:(float)time succeed:(void(^_Nullable)(id  _Nonnull data))succeed fail:(void(^_Nullable)(NSError * _Nonnull error))fail;
@end
