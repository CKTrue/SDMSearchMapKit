//
//  ToolManager.h

//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MacroDefinition.h"
#import "YCHeader.h"
typedef enum : NSUInteger {
    LocationStatusDefault,
    LocationStatusSuccess,
    LocationStatusLocationFailure,
    LocationStatusDecompilingFailure,
    LocationStatusUnauthorized
} LocationStatus;

typedef void(^LocationStatusBlock)(LocationStatus status , CLLocationCoordinate2D coordinate, NSString *city);

@interface ToolManager : NSObject

@property (nonatomic, copy) LocationStatusBlock locationBlock;


//中心点
@property (nonatomic, assign) CGPoint centent;


//当前的位置
//@property (nonatomic,strong)AMapLocationReGeocode*regeocode;

//当前的经纬度信息
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//是否显示官方通知
@property (nonatomic, assign) BOOL isNoticeRedShow;


//屏幕宽
@property (nonatomic, assign) CGFloat screenWidth;

//屏幕高
@property (nonatomic, assign) CGFloat screenHeight;

//头像占位符
@property (nonatomic,strong) UIImage *placeholderHeadImage;

//图片占位符
@property (strong) UIImage *placeholderImage;

+ (instancetype)shareManager;

/**
 *   @return 获取字符串的宽度
 */
+ (CGFloat)widthFromStr:(NSString *)aString fountSize:(CGFloat)size;

/**
 *   @return 格式化输出的日期
 */
+ (NSString *)setDate:(NSDate *)confromTimesp;

/**
 *
 */
/**
 *   系统定位封装
 */
- (void)starLocationResult:(LocationStatusBlock)result;
/**
 *   是否开启了定位
 */
+ (BOOL)isLocationServer;

/**
 *   对图片尺寸进行压缩
 *
 *   @param image 原图片
 *
 *   @param newSize 需要压缩的尺寸
 *
 *   @return 压缩好的图片
 **/

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)GetScaleImage:(UIImage *)image scaledToSize:(CGSize)Size;
//获取当前时间
- (NSDate *)getCurrentTime;
//两个时间相比较
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
//距离换算
-(NSString *)setDistanceStr:(double) distance;
// 计算文字高度，允许换行计算
- (CGFloat)sizeLineFeedWithFont:(CGFloat)fontSize text:(NSString*)text textSizeWidth:(CGFloat)width;

//获取两点之间的距离
-(double)getDistanceMetresBetweenLocationCoordinatesLocation1:(CLLocationCoordinate2D) coord1 Location2:(CLLocationCoordinate2D) coord2;

//nsuserdefalut保存数据
-(void)SaveDataWithUserDefalutKey:(NSString*)key ArchiverDataObject:(id)object;
//取出数据
-(id)getDataWithUserDefalutKey:(NSString*)key;
-(void)LoginOut:(NSURL*)url WithViewController:(UIViewController*)controller;
//根据地图缩放比例获取查询范围
-(double)GetDistanceByMapScale:(int)mapscale;

//加载xib文件
-(UIView*)creatAllreadAlterView:(NSString*)name;
//加载图片文件
-(UIImage*)creatZhujianImgView:(NSString*)name;

-(NSBundle*)subBundleWithBundleName;


@end
