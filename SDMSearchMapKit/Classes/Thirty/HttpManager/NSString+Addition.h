//
//  NSString+Addition.h
//  Chinaware
//
//  Created by 岳永超 on 15/9/2.
//  Copyright (c) 2015年 yungui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

// md5
- (NSString *)md5;

// 编码
- (NSString *)encode;

// 解码
- (NSString *)decode;


// 字符串转字典对象
- (id)object;


/**
 *  去空格和换行符，一般在网络请求过来的数据出用
 *
 *  @return 结果
 */
- (NSString *)trim;


/**
 *  查找这个字符串是否包含另外一个字符串，一般用于模糊查找(ios8已有)
 *
 *  @param string 要对比的字符串
 *
 *  @return YES : NO
 */
- (BOOL)containOfYYCString:(NSString *)string;


/**
 *  获得Documents路径
 *
 *  @return 路径地址
 */
+ (NSString *)getDocumentsPath;

/**
 *  获得Documents下得某个目录，而且确保这个目录一定会存在
 *
 *  @param path 目录名称
 *
 *  @return 目录路径
 */
+ (NSString *)getDirectoryWithPath:(NSString *)path;
/**
 *  判断手机号码
 *
 *  @return YES : NO
 */
-(BOOL)isMobileNumberClassification;


//判断字符串是否包含表情

- (BOOL)stringContainsEmoji:(NSString *)string;

//获得设备型号
- (NSString *)getCurrentDeviceModel;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
@end
