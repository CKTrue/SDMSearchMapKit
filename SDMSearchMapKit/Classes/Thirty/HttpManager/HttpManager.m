//
//  HttpManager.m
//  Chinaware
//
//  Created by 岳永超 on 15/7/1.
//  Copyright (c) 2015年 yungui. All rights reserved.
//

#import "HttpManager.h"
#import "NSString+Cache.h"
#import "NSString+CLTools.h"

#define CacheDefaults [NSUserDefaults standardUserDefaults]

/**
*  Http网络管理器-------------------网络请求-----------------------
*/

@interface HttpManager () {
    // 网络状态检测
        Reachability *reachability;
    // http请求管理器
    AFHTTPSessionManager *operationManager;
}
@end
// 缓存路径
static inline NSString *cachePath() {
    return [NSString cachesPathString];
}


@implementation HttpManager

+ (HttpManager *)defaultManager
{
    static dispatch_once_t once_t = 0;
    __strong static id defaultHttpManager = nil;
    dispatch_once(&once_t, ^{
        defaultHttpManager = [[self alloc] init];
    });
    return defaultHttpManager;
}
+ (AFHTTPSessionManager *)sharedHTTPSession{
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager=nil ;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30;

        [manager.requestSerializer  setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"application/json", nil];

    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // http接口请求管理器
     //   operationManager = [AFHTTPSessionManager manager];
      //  operationManager.requestSerializer.timeoutInterval=20;
      //  operationManager.responseSerializer.acceptableContentTypes = nil;
        operationManager=[HttpManager sharedHTTPSession];
        // 通过监听网址 www.baidu.com 来获取网络状态
        reachability = [Reachability reachabilityWithHostName:@"https://www.baidu.com"];
                [reachability startNotifier];
        // 设置缓存
        NSURLCache *urlCache = [NSURLCache sharedURLCache];

        // 设置缓存的大小为20MB
        [urlCache setMemoryCapacity:20*1024*1024];
        [NSURLCache setSharedURLCache:urlCache];
    }
    return self;
}


+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
#pragma mark - 返回当前网络类型
- (NetworkStatus)networkStatus
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    reachability = [Reachability reachabilityForInternetConnection];


    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", (long)status);
        /**
         AFNetworkReachabilityStatusUnknown          = -1,  // 未知
         AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
         AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
         AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络
         */
    }];
    //另一种方式
    return [reachability currentReachabilityStatus];
    
}


#pragma mark -- GET请求 --
- (void)getNetworkRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers  parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypeGET url:urlString headers:headers  parameters:parameters isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}

#pragma mark -- GET请求 <含缓存时间> --
-(void)getCacheRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers  parameters:(id)parameters cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypeGET url:urlString headers:headers  parameters:parameters isCache:YES cacheTime:time succeed:succeed fail:fail];
}


#pragma mark -- POST请求 --
- (void)postNetworkRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers  parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypePOST url:urlString headers:headers  parameters:parameters isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}

#pragma mark -- POST请求 <含缓存时间> --
- (void)postCacheRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers  parameters:(id)parameters cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypePOST url:urlString headers:headers  parameters:parameters isCache:YES cacheTime:time succeed:succeed fail:fail];
}
#pragma mark -- PUT请求 --
- (void)putNetworkRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers  parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypePUT url:urlString headers:headers  parameters:parameters isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}

#pragma mark -- Delete请求 --
- (void)DeleteNetworkRequestWithUrlString:(NSString *)urlString headers:(NSDictionary*)headers  parameters:(id)parameters isCache:(BOOL)isCache succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    
    [self requestType:NetworkRequestTypeDELETE url:urlString headers:headers  parameters:parameters isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}
#pragma mark -- 网络请求 --
/**
 *  网络请求
 *
 *  @param type       请求类型，get请求/Post请求
 *  @param urlString  请求地址字符串
 *  @param parameters 请求参数
 *  @param isCache    是否缓存
 *  @param time       缓存时间
 *  @param succeed    请求成功回调
 *  @param fail       请求失败回调
 */
-(void)requestType:(NetworkRequestType)type url:(NSString *)urlString headers:(NSDictionary*)headers parameters:(id)parameters isCache:(BOOL)isCache cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail{
    DSLog(@"接口:%@________>请求参数:%@------------>%ld",urlString,parameters,(long)self.networkStatus);
//    NSString *key = [self cacheKey:urlString params:parameters];
//
//    // 判断网址是否加载过，如果没有加载过 在执行网络请求成功时，将请求时间和网址存入UserDefaults，value为时间date、Key为网址
//    if ([CacheDefaults objectForKey:key]) {
//        // 如果UserDefaults存过网址，判断本地数据是否存在
//        id cacheData = [self cahceResponseWithURL:urlString parameters:parameters];
//        if (cacheData&&self.networkStatus==0) {
//            // 如果本地数据存在
//            // 判断存储时间，如果在规定直接之内，读取本地数据，解析并return，否则将继续执行网络请求
//           // if (time > 0) {
//             //   NSDate *oldDate = [CacheDefaults objectForKey:key];
//              //  float cacheTime = [[NSString stringNowTimeDifferenceWith:[NSString stringWithDate:oldDate]] floatValue];
//               // if (cacheTime < time) {
//                    id dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//                    if (succeed) {
//                        succeed(dict);
//                    }
//                //}
//           // }
//        }
//    }else{
//         //判断是否开启缓存
//       if (isCache) {
//            id cacheData = [self cahceResponseWithURL:urlString parameters:parameters];
//            if (cacheData) {
//                id dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//                if (succeed) {
//                    succeed(dict);
//                }
//            }
//        }
//    }
    
    AFHTTPSessionManager *manager = [HttpManager sharedHTTPSession];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为要获取text/plain类型数据

    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request;
  
    if (type == NetworkRequestTypeGET) {
           request.HTTPMethod = @"GET";
        request =[manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:parameters error:nil];
      
        
//        [manager GET:urlString parameters:parameters headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            // 请求成功，加入缓存，解析数据
//            if (isCache) {
//                    [CacheDefaults setObject:[NSDate date] forKey:key];
//
//                [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
//            }
//            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//
//            if (succeed) {
//                succeed(dict);
//            }
//                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    // 请求失败
//                    if (fail) {
//                        fail(error);
//                    }
//                }];
       
    }else if(type==NetworkRequestTypePOST){
        request.HTTPMethod = @"POST";
        request =[manager.requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:parameters error:nil];

        // POST请求
//         [manager POST:urlString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
//            // 请求的进度
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            // 请求成功，加入缓存，解析数据
//            if (isCache) {
//        //if (time > 0.0) {
//                    [CacheDefaults setObject:[NSDate date] forKey:key];
//             //   }
//                [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
//           }
//            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//
//            if (succeed) {
//                succeed(dict);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            // 请求失败
//            if (fail) {
//                fail(error);
//            }
//        }];

        
    }
    else if (type==NetworkRequestTypePUT){
        // PUT请求
        request.HTTPMethod = @"PUT";
        request =[manager.requestSerializer requestWithMethod:@"PUT" URLString:urlString parameters:parameters error:nil];

//
//       [manager PUT:urlString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            // 请求成功，加入缓存，解析数据
//            if (isCache) {
//        //if (time > 0.0) {
//                    [CacheDefaults setObject:[NSDate date] forKey:key];
//             //   }
//                [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
//           }
//            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//
//            if (succeed) {
//                succeed(dict);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            // 请求失败
//            if (fail) {
//                fail(error);
//            }
//        }];

    }else{
        // Delete请求
        request.HTTPMethod = @"DELETE";
        request =[manager.requestSerializer requestWithMethod:@"DELETE" URLString:urlString parameters:parameters error:nil];

//     [manager DELETE:urlString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            // 请求成功，加入缓存，解析数据
//            if (isCache) {
//        //if (time > 0.0) {
//                    [CacheDefaults setObject:[NSDate date] forKey:key];
//             //   }
//                [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
//           }
//            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//
//            if (succeed) {
//                succeed(dict);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            // 请求失败
//            if (fail) {
//                fail(error);
//            }
//        }];
    }
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        for (NSString *headerField in headers.keyEnumerator) {
            [request setValue:headers[headerField] forHTTPHeaderField:headerField];
        }
        if ([parameters isKindOfClass:[NSArray class]]) {

        }
       else if ([parameters isKindOfClass:[NSDictionary class]]) {
     
       }
       else if ([parameters isKindOfClass:[NSSet class]]) {
      
       }else{

     NSData *postData = [[NSData alloc] initWithData:[parameters dataUsingEncoding:NSUTF8StringEncoding]];

      request.HTTPBody=postData;
      
     }
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
           
           if (error) {
               fail(error);
           }else{
id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];

        if (succeed) {
            succeed(dict);
        }
           }
       }] resume];
}
#pragma mark------语音文件上传
-(void)UploadVoicefileWithUrlString:(NSString*)urlStr
                         parameters:(id)parameters
                      WithVoiceData:(NSData*)data
                            progress:(void(^)(NSProgress * _Nonnull uploadProgress))process
                            succeed:(void(^)(id data))succeed
                               fail:(void(^)(NSError *error))fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.aac", str];
        
        NSString*mimeType=@"amr/mp3/wmr/aac";
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (process) {
            process(uploadProgress);
        };
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        if (succeed) {
            succeed(dict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];

}
#pragma mark -- 上传图片 --
-(void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                      files:(NSArray *)files
                   progress:(void (^)(float writeKB, float totalKB)) progress
                    succeed:(void (^)())succeed
                       fail:(void (^)(NSError *error))fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary *fileItem in files) {
            id value = [fileItem objectForKey:@"file"];        //支持四种数据类型：NSData、UIImage、NSURL、NSString
            NSString *name = [fileItem objectForKey:@"key"];            //文件字段的key
            NSString *fileName = [fileItem objectForKey:@"name"];       //文件名称
            NSString *mimeType = [fileItem objectForKey:@"type"];       //文件类型
            mimeType = mimeType ? mimeType : @"image/jpeg";
            name = name ? name : @"file";
            
            if ([value isKindOfClass:[NSData class]]) {
                [formData appendPartWithFileData:value name:name fileName:fileName mimeType:mimeType];
            }else if ([value isKindOfClass:[UIImage class]]) {
                if (UIImagePNGRepresentation(value)) {  //返回为png图像。
                    [formData appendPartWithFileData:UIImagePNGRepresentation(value) name:name fileName:fileName mimeType:mimeType];
                }else {   //返回为JPEG图像。
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(value, 0.5) name:name fileName:fileName mimeType:mimeType];
                }
            }else if ([value isKindOfClass:[NSURL class]]) {
                [formData appendPartWithFileURL:value name:name fileName:fileName mimeType:mimeType error:nil];
            }else if ([value isKindOfClass:[NSString class]]) {
                [formData appendPartWithFileURL:[NSURL URLWithString:value]  name:name fileName:fileName mimeType:mimeType error:nil];
            }
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float uploadKB = uploadProgress.completedUnitCount/1024.0;
        float grossKB = uploadProgress.totalUnitCount/1024.0;
        if (progress) {
            progress(uploadKB, grossKB);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (succeed) {
            succeed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        if (fail) {
            fail(error);
        }
    }];
}

#pragma mark -- 缓存处理 --
/**
 *  缓存文件夹下某地址的文件名，及UserDefaulets中的key值
 *
 *  @param urlString 请求地址
 *  @param params    请求参数
 *
 *  @return 返回一个MD5加密后的字符串
 */
-(NSString *)cacheKey:(NSString *)urlString params:(id)params{
    NSString *absoluteURL = [NSString generateGETAbsoluteURL:urlString params:params];
    NSString *key = [NSString networkingUrlString_md5:absoluteURL];
    return key;
}

/**
 *  读取缓存
 *
 *  @param url    请求地址
 *  @param params 拼接的参数
 *
 *  @return 数据data
 */
-(id)cahceResponseWithURL:(NSString *)url parameters:(id)params {
    id cacheData = nil;
    if (url) {
        // 读取本地缓存
        NSString *key = [self cacheKey:url params:params];
        NSString *path = [cachePath() stringByAppendingPathComponent:key];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
        }
    }
    return cacheData;
}

/**
 *  添加缓存
 *
 *  @param responseObject 请求成功数据
 *  @param urlString      请求地址
 *  @param params         拼接的参数
 */
-(void)cacheResponseObject:(id)responseObject urlString:(NSString *)urlString parameters:(id)params {
    NSString *key = [self cacheKey:urlString params:params];
    NSString *path = [cachePath() stringByAppendingPathComponent:key];
    [self deleteFileWithPath:path];
    BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:responseObject attributes:nil];
    if (isOk) {
        DSLog(@"cache file success: %@\n", path);
    } else {
        DSLog(@"cache file error: %@\n", path);
    }
}

// 清空缓存
-(void)clearCacheFlies{
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
NSString*cachPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        DSLog(@"清理成功");
      });
    }

//单个文件的大小
-(long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少KB
-(float)getCacheFileSize:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:folderPath]) {
        return 0;
        }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0); //得到缓存大小M
}

/**
 *  判断文件是否已经存在，若存在删除
 *
 *  @param path 文件路径
 */
-(void)deleteFileWithPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        DSLog(@"file deleted success");
        if (err) {
            DSLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        DSLog(@"no file by that name");
    }
}

@end
