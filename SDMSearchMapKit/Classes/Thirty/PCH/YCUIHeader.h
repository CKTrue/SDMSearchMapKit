//
//  YCUIHeader.h
//  Chinaware
//
//  Created by 岳永超 on 15/7/1.
//  Copyright (c) 2015年 yungui. All rights reserved.
//

#ifndef Chinaware_YCUIHeader_h
#define Chinaware_YCUIHeader_h


/**
 *	获取视图宽度
 *
 *	@param 	view 	视图对象
 *
 *	@return	宽度
 */
#define DEF_WIDTH(view) view.bounds.size.width

/**
 *	获取视图高度
 *
 *	@param 	view 	视图对象
 *
 *	@return	高度
 */
#define DEF_HEIGHT(view) view.bounds.size.height

/**
 *	获取视图原点横坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	原点横坐标
 */
#define DEF_LEFT(view) view.frame.origin.x

/**
 *	获取视图原点纵坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	原点纵坐标
 */
#define DEF_TOP(view) view.frame.origin.y

/**
 *	获取视图右下角横坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	右下角横坐标
 */
#define DEF_RIGHT(view) (DEF_LEFT(view) + DEF_WIDTH(view))

/**
 *	获取视图右下角纵坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	右下角纵坐标
 */
#define DEF_BOTTOM(view) (DEF_TOP(view) + DEF_HEIGHT(view))

/**
 *  主屏的size
 */
#define DEF_SCREEN_SIZE   [[UIScreen mainScreen] bounds].size

/**
 *  主屏的frame
 */
#define DEF_SCREEN_FRAME  [UIScreen mainScreen].applicationFrame


//修改RGB颜色
#define DEF_RGB_COLOR(r,g,b)  DEF_RGBA_COLOR(r, g, b, 1)


/**
 *	判断当前系统版本是否大于iOS10
 */
#define systemVersionIsiOS10 [[[UIDevice currentDevice]systemVersion]floatValue] >= 10.f

/**
 *	返回当前系统版本
 */
#define systemVersionStr [[UIDevice currentDevice]systemVersion]

/**
 *	生成RGBA颜色
 *
 *	@param 	red 	red值（0~255）
 *	@param 	green 	green值（0~255）
 *	@param 	blue 	blue值（0~255）
 *
 *	@return	UIColor对象
 */

#define DEF_RGBA_COLOR(_red, _green, _blue, _alpha) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:(_alpha)]


/*绿色*/
#define GREENCOLOR DEF_RGB_COLOR(73, 203, 198)
/*朱红色*/
#define KScarletColor [UIColor colorWithHexString:@"#ee2e2f"]
/*banner 高*/
#define BANNER_HEIGHT [UIScreen mainScreen].bounds.size.width/ 320.f * 140.f

/*浅灰色*/
#define QIANHUICOLORSTR @"#f9f9f9"

/*紫色*/
#define ZICOLORSTR @"#8200ff"
/*粉色*/
#define FENCOLORSTR @"#fe0072"
/*黑色loading neme*/
#define HEIACTIONGIFNAME @"heigif"

//背景色
#define BaseViewColor DEF_RGB_COLOR(240, 240, 240)

/*主题色色值*/
#define themeColorStr [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"] ?: QIANHUICOLORSTR

/*主题色*/
#define themeColor  [UIColor colorWithHexString:themeColorStr]

#define KWhiteColor [UIColor whiteColor]
#define KBackgroundColor [UIColor colorWithHexString:@"#f0f0f0"]
#define KLineColor [UIColor colorWithHexString:@"#e5e5e5"]
#define kMainColor [UIColor colorWithHexString:@"#2f9cd4"]

#define DynamicCommentFont 14.0//评论字体
#define DynamicTimeFont 11.0//时间字体大小
#define DynamicCityFont 11.0//城市名字体大小
#define DynamicContentFont 15.0//正文内容
#define DynamicCountFont  12.0//阅读量文字大小
#define DynamicPraiseCountFont 13.0//点赞文字大小
#define DynamicNameFont 16.0//帖子昵称文字大小
#define DynamicFullTextFont 15.0//阅读全文大小
#define DynamicCommentCountFont 11.0//评论数文字大小
#define DEF_ZANCELLHEIGHT 35//点赞头像大小

#define UserNickNameShowMaxLength 24 //名字的最大显示长度

#define kChatDeafultUserId @"7121"

#endif
