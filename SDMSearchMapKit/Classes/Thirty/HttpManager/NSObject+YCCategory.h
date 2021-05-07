//
//  NSObject+YCCategory.h
//  Chinaware
//
//  Created by 岳永超 on 15/7/1.
//  Copyright (c) 2015年 yungui. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark--
#pragma mark---yyc注:-----类别的扩展------

@interface NSObject (YCCategory)

// json转字符串
- (NSString *)jsonTransformToString;

@end


//十六进制转rgb颜色
@interface UIColor (HexColor)
+ (UIColor *) colorWithHexString: (NSString *)color;
//创建颜色图片
+(UIImage*) createImageWithColor:(UIColor*) color;
//生成随机色
+(UIColor *) randomColor;


@end
//字典,数组中文编码
@interface NSDictionary (China_Description)
- (NSString *)descriptionChina;
@end

@interface NSArray (China_Description)
- (NSString *)descriptionChina;
@end