//
//  ToolManager.m
//  Starwinwin
//
//  Created by mac os on 16/5/24.
//  Copyright © 2016年 岳永超. All rights reserved.
//

#import "ToolManager.h"
#import <math.h>
#import <SafariServices/SafariServices.h>
#import <AuthenticationServices/AuthenticationServices.h>

API_AVAILABLE(ios(11.0))
@interface ToolManager ()<CLLocationManagerDelegate,SFSafariViewControllerDelegate,ASWebAuthenticationPresentationContextProviding>

{
    BOOL _isLocationSuccess;
    UIViewController*_presentViewController;
    __weak SFSafariViewController *_safariVC;
    SFAuthenticationSession *_authenticationVC;
    ASWebAuthenticationSession *_webAuthenticationVC;
    
}


@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ToolManager

#define kShareContentDefaultStr @""


+ (instancetype)shareManager {
    static ToolManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ToolManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
    }
    return self;
}



/**
 *   @return 获取字符串的宽度
 */
+ (CGFloat)widthFromStr:(NSString *)aString fountSize:(CGFloat)size {
    
    return [aString boundingRectWithSize:CGSizeMake(MAXFLOAT, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size.width;
    
}

+ (NSString *)setDate:(NSDate *)confromTimesp {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:confromTimesp];
    NSDate *todate = [calendar dateFromComponents:dateComponent];//把目标时间
    
    
    NSDate *today = [self zeroOfDate];
    NSDateComponents *d = [calendar components:unitFlags fromDate:todate toDate:today options:0];
    

    //是否大于一天
    if ((long)[d day] > 0)
    {
        //大于一天
      return  [self timeString:d todate:todate];
    }
    else
    {
        //没有大于一天
        
        today = [NSDate date];
        d = [calendar components:unitFlags fromDate:todate toDate:today options:0];
        
        return  [self timeString:d todate:todate];
        
    }
}

+ (NSString *)timeString:(NSDateComponents *)DateComponents todate:(NSDate *)todate
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = threadDictionary[@"mydateformatter"];
    if(!dateFormatter){
        @synchronized(self){
            if(!dateFormatter){
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm"];
                //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@”Asia/Shanghai”]];
                threadDictionary[@"mydateformatter"] = dateFormatter;
            }
        }
    }
   // NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"HH:mm"];
    NSString *showDate = [dateFormatter stringFromDate:todate];

    
    NSString *dateContent = nil;

    if ((long)[DateComponents year] > 0)
    {
        dateContent = [[NSString alloc] initWithFormat:@"%li年前",(long)[DateComponents year]];
    }
    else if ((long)[DateComponents month] > 0)
    {
        dateContent = [[NSString alloc] initWithFormat:@"%li个月前",(long)[DateComponents month]];
    }
    else if ((long)[DateComponents day] > 0)
    {
        if ([DateComponents day] == 1)
        {
            dateContent = [[NSString alloc] initWithFormat:@"昨天 %@",showDate];
        }
        else if ([DateComponents day] == 2)
        {
            dateContent = [[NSString alloc] initWithFormat:@"前天 %@",showDate];
        }
        else
        {
            dateContent = [[NSString alloc] initWithFormat:@"%li天前",(long)[DateComponents day]];
        }
        
    }
    else if ((long)[DateComponents hour] > 0)
    {
        dateContent = [[NSString alloc] initWithFormat:@"%li小时前",(long)[DateComponents hour]];
    }
    else
    {
        if ([DateComponents minute] == 0)
        {
            dateContent = @"刚刚";
        }
        else
        {
            dateContent = [[NSString alloc] initWithFormat:@"%li分钟前",(long)[DateComponents minute]];
        }
        
    }
    return dateContent;

}
//获取当前时间
- (NSDate *)getCurrentTime{
    
    //2017-04-24 08:57:29
    NSDate*date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
  
    return localeDate;
}
//时间比较
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}
+ (NSDate *)zeroOfDate
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    return endDate;
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:self];
//    components.hour = 0;
//    components.minute = 0;
//    components.second = 0;
//
//    // components.nanosecond = 0 not available in iOS
//    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
//    return [NSDate dateWithTimeIntervalSince1970:ts];
}




//- (UIImage *)placeholderImage {
//
//    if (_placeholderImage == nil) {
//        _placeholderImage = [UIColor createImageWithColor:[UIColor colorWithHexString:QIANHUICOLORSTR]];
//    }
//
//    return _placeholderImage;
//}

- (UIImage *)placeholderHeadImage {
    if (_placeholderHeadImage == nil) {
        _placeholderHeadImage = DEF_IMAGE(@"Settingtouxiang");
    }
    
    return _placeholderHeadImage;
}

- (CLLocationCoordinate2D)coordinate {
    
    if (_coordinate.latitude <= 0) {
        
       _coordinate.latitude = [DEF_PERSISTENT_GET_OBJECT(@"userLat") doubleValue];
        _coordinate.longitude = [DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue];
        
    }
    
    return _coordinate;
}

- (CLLocationManager *)locationManager {
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}


- (void)starLocationResult:(LocationStatusBlock)result {
    
    if ([ToolManager isLocationServer]) {
        
        self.locationBlock = result;
        
        /** 由于IOS8中定位的授权机制改变 需要进行手动授权
         * 获取授权认证，两个方法：
         * [self.locationManager requestWhenInUseAuthorization];
         * [self.locationManager requestAlwaysAuthorization];
         */
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            
            [self.locationManager requestAlwaysAuthorization];
        }
        //开始定位，不断调用其代理方法
        [self.locationManager startUpdatingLocation];
   }
    else if (result) {
        CLLocationCoordinate2D coordinate = {0, 0};
        result(LocationStatusUnauthorized, coordinate, nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please open the App location function " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set up", nil];
        [alertView show];
        alertView.tag = 3234;
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please open the App location function " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set up", nil];
        [alertView show];
        alertView.tag = 3234;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setDouble:0 forKey:@"userLat"];
        [defaults setDouble:0 forKey:@"userLng"];
        
    }
}

+ (BOOL)isLocationServer {
    //第一个判断是获取系统定位开启状态   第二个是获取应用定位开启状态
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
            return YES;
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        return NO;
    }
    return NO;
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    self.coordinate = location.coordinate;
    
    //存储到本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:_coordinate.latitude forKey:@"userLat"];
    [defaults setDouble:_coordinate.longitude forKey:@"userLng"];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
    _isLocationSuccess = NO;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.locationManager.location
    completionHandler:^(NSArray *placemarks, NSError *error) {
       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");

       if (error){
           NSLog(@"Geocode failed with error: %@", error);
           return;

       }

       if(placemarks && placemarks.count > 0)

       {
           //do something
           CLPlacemark *topResult = [placemarks objectAtIndex:0];
           NSString *addressTxt = [NSString stringWithFormat:@"%@ %@,%@ %@",
                                   [topResult subThoroughfare],[topResult thoroughfare],
                                   [topResult locality], [topResult administrativeArea]];
           NSLog(@"%@",addressTxt);
       }
        }];

    
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
//     {
//
//         if (!self->_isLocationSuccess) {
//             self->_isLocationSuccess = YES;
//
//             NSString *city = nil;
//             if (array.count > 0)
//             {
//                 CLPlacemark *placemark = [array objectAtIndex:0];
//                 NSLog(@"%@",placemark.name);//具体位置
//                 //获取城市
//                city = placemark.locality;
//                 if (!city) {
//                     //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                     city = placemark.administrativeArea;
//                 }
//
//                 if ([city hasSuffix:@"市"]) {
//                     city = [city substringToIndex:city.length - 1];
//                 }
//                 kWeakSelf;
//                 if (self.locationBlock) {
//                     weakSelf.locationBlock(LocationStatusSuccess, weakSelf.coordinate, city);
//                     weakSelf.locationBlock = nil;
//                 }
//                 DEF_PERSISTENT_SET_OBJECT(city,@"CurrentCity");
//             }
//             else
//             {
//                 NSString *info = nil;
//                 if (error) {
//                     NSLog(@"Geocode failed with error: %@", error);
//                          return;
//
//                 }
//                 kWeakSelf;
//                 if (self.locationBlock) {
//                     weakSelf.locationBlock(LocationStatusDecompilingFailure, weakSelf.coordinate, info);
//                     weakSelf.locationBlock = nil;
//                 }
//
//             }
//
//             self.coordinate = self->_coordinate;
//
//         }
//
//     }];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
       // CLLocationCoordinate2D coordinate = {0, 0};
        
        if (self.locationBlock) {
           // self.locationBlock(LocationStatusLocationFailure, coordinate, [error.userInfo jsonStringEncoded]);
            self.locationBlock = nil;
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3234) {
        if (buttonIndex == 1) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                  //  [self starLocationResult:nil];
                    
                }];
            }
        }
    }
}




//对图片尺寸进行压缩
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)Size {
    
    double hfactor = image.size.width / SCREEN_WIDTH;
    double vfactor = image.size.height / SCREEN_HEIGHT;
    double factor = fmax(hfactor, vfactor);
    //画布大小
    CGFloat newWidth= image.size.width/factor;
    CGFloat newHeigth = image.size.height/factor;
  CGSize newSize = CGSizeMake(newWidth,newHeigth);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
    
}

//对图片尺寸进行压缩
- (UIImage *)GetScaleImage:(UIImage *)image scaledToSize:(CGSize)Size {
    
//    double hfactor = image.size.width / SCREEN_WIDTH;
//    double vfactor = image.size.height / SCREEN_HEIGHT;
//    double factor = fmax(hfactor, vfactor);
//    //画布大小
   // CGFloat newWidth= image.size.width/factor;
    //CGFloat newHeigth = image.size.height/factor;
   // CGSize newSize = CGSizeMake(newWidth,newHeigth);
    // Create a graphics image context
    UIGraphicsBeginImageContext(Size);
    
    [image drawInRect:CGRectMake(0,0,Size.width,Size.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
    
}

-(UIImage*)FromFileGetImg:(NSString*)imgName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:imgName ofType:@"png"];
   UIImage*image= [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}

-(NSString *)setDistanceStr:(double) distance{
    

    //是否大于1000
    if (distance<1000)
    {
      return  [NSString stringWithFormat:@"%.f m",distance];
    }
    else
    {
        NSNumberFormatter*formatter=[[NSNumberFormatter alloc]init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        if(distance>100000){
        formatter.positiveFormat = @"###,###";
        }else{
        formatter.positiveFormat = @"###,###.#";
        }
        NSString*str=[NSString stringWithFormat:@"%@ km",[formatter stringFromNumber:@(distance/1000)]];
        
        return str;

    }
}

/**
 计算文字高度，允许换行计算

 @param fontSize 文字大小
 @param width 文字宽度
 @return 返回文字的高度
 */
- (CGFloat)sizeLineFeedWithFont:(CGFloat)fontSize text:(NSString*)text textSizeWidth:(CGFloat)width {
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    textlabel.text = text;
    textlabel.numberOfLines=0;
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [currentBundle pathForResource:@"ToyotaTypeW02-regular.ttf" ofType:nil inDirectory:@"SDMSearchMapKit"];
    textlabel.font = [UIFont fontWithName:path size:fontSize];
    CGSize size = CGSizeMake(width, MAXFLOAT);
    CGSize constraint = [textlabel sizeThatFits:size];
    return constraint.height;
}

#pragma mark------获取两点之间的距离
-(double)rad:(double)lat{
    return lat * M_PI/ 180.0;
}
-(double)getDistanceMetresBetweenLocationCoordinatesLocation1:(CLLocationCoordinate2D) coord1 Location2:(CLLocationCoordinate2D) coord2
{
//    CLLocation* location1 =
//        [[CLLocation alloc]
//            initWithLatitude:coord1.latitude
//            longitude: coord1.longitude];
//    CLLocation* location2 =
//        [[CLLocation alloc]
//            initWithLatitude: coord2.latitude
//            longitude: coord2.longitude];
//
//    return [location1 distanceFromLocation: location2];
    
         double lat1 =coord1.latitude;
    double lng1 = coord1.longitude;
    double lat2 = coord2.latitude;
    double lng2 = coord2.longitude;
         double patm = 2;
       double radLat1 = [self rad:lat1];
      double radLat2 = [self rad:lat2];
         double difference = radLat1 - radLat2;
    double mdifference = [self rad:lng1] - [self rad:lng2];
    double distance= patm *asin(sqrt(pow(sin(difference/patm), patm)+cos(radLat1)*cos(radLat2)*pow(sin(mdifference/patm), patm)));
         
         distance = distance * 6371.004*1000;
         return distance;
     

}
-(void)SaveDataWithUserDefalutKey:(NSString*)key ArchiverDataObject:(id)object{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedAuthState = [NSKeyedArchiver archivedDataWithRootObject:object];
    [userDefaults setObject:archivedAuthState
                     forKey:key];
    [userDefaults synchronize];
}
-(id)getDataWithUserDefalutKey:(NSString*)key {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedData = [userDefaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
;
}
-(void)LoginOut:(NSURL*)url WithViewController:(UIViewController*)controller{
    _presentViewController=controller;

    if (@available(iOS 12.0, *)) {

      // ASWebAuthenticationSession doesn't work with guided access (rdar://40809553)
      if (!UIAccessibilityIsGuidedAccessEnabled()) {
          ASWebAuthenticationSession*authenticationVC
=
          [[ASWebAuthenticationSession alloc] initWithURL:url
                                          callbackURLScheme:@"sdmtoyotapoisearch"
                                          completionHandler:^(NSURL * _Nullable callbackURL,
                                                              NSError * _Nullable error) {
             
        if (callbackURL) {
            DSLog(@"%@",callbackURL);

        } else {
            NSLog(@"%@",error);
        }
              
        }];
  
          if (@available(iOS 13.0, *)) {
//              UIWindow*window=[UIApplication sharedApplication].keyWindow;
//              UIViewController*vc=[[UIViewController alloc]init];
//              [window addSubview:vc];
              authenticationVC.presentationContextProvider = self;
          } else {
              // Fallback on earlier versions
          }
          _webAuthenticationVC=authenticationVC;
           [authenticationVC start];

      }
    }           // iOS 11, use SFAuthenticationSession
    if (@available(iOS 11.0, *)) {
      // SFAuthenticationSession doesn't work with guided access (rdar://40809553)
       
      if (!UIAccessibilityIsGuidedAccessEnabled()) {
          SFAuthenticationSession*authenticationVC =
            [[SFAuthenticationSession alloc] initWithURL:url
                                       callbackURLScheme:@"sdmtoyotapoisearch"
                                       completionHandler:^(NSURL * _Nullable callbackURL,
                                                           NSError * _Nullable error) {
               
          if (callbackURL) {
              DSLog(@"%@",callbackURL);

          } else {
              DSLog(@"%@",error);
          }
                
                
        }];
          _authenticationVC=authenticationVC;
        [authenticationVC start];
      }
    }
    // iOS 9 and 10, use SFSafariViewController
    if (@available(iOS 9.0, *)) {

        SFSafariViewController *safariVC =
            [[SFSafariViewController alloc] initWithURL:url];
        safariVC.delegate = self;
      //  [_presentViewController presentViewController:safariVC animated:YES completion:nil];
        _safariVC=safariVC;
      }

    // iOS 8 and earlier, use mobile Safari

  

   
}
#pragma mark - ASWebAuthenticationPresentationContextProviding

-(ASPresentationAnchor)presentationAnchorForWebAuthenticationSession:(ASWebAuthenticationSession *)session  API_AVAILABLE(ios(12.0)){
  return _presentViewController.view.window;
}
- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(nullable NSString *)title{
    
    return nil;
}
- (void)safariViewController:(SFSafariViewController *)controller initialLoadDidRedirectToURL:(NSURL *)URL{
    
}
-(double)GetDistanceByMapScale:(int)mapscale{
    switch (mapscale) {
        case 8:
        {
            return 100000;
        }
            break;
        case 9:
        {
            return 50000;
        }
            break;
        case 10:
        {
            return 20000;
        }
            break;
        case 11:
        {
            return 10000;
        }
            break;
        case 12:
        {
            return 5000;
        }
            break;
        case 13:
        {
            return 2000;
        }
            break;
        case 14:
        {
            return 2000;
        }
            break;
        case 15:
        {
            return 1000;
        }
            break;
        case 16:
        {
            return 500;
        }
        case 17:
        {
            return 200;
        }
            break;
        default:
        {
            return 2000;
        }
            break;
    }
}


-(UIView*)creatAllreadAlterView:(NSString*)name{
   
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"SDMSearchMapKit" ofType:@"bundle"];
    NSBundle *bundel = [NSBundle bundleWithPath:path];
    return [[bundel loadNibNamed:name owner:self options:nil] lastObject];
}

-(NSBundle*)subBundleWithBundleName{
    //并没有拿到子bundle
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    //在这个路径下找到子bundle的路径
    NSString *path = [bundle pathForResource:@"SDMSearchMapKit" ofType:@"bundle"];
    //根据路径拿到子bundle
    return path?[NSBundle bundleWithPath:path]:[NSBundle mainBundle];
}
-(UIImage*)creatZhujianImgView:(NSString*)name{
    NSInteger scale=[[UIScreen mainScreen] scale];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString*imagename=[NSString stringWithFormat:@"%@@%ldx.png",name,scale];
    NSString *path = [bundle pathForResource:imagename ofType:nil inDirectory:@"SDMSearchMapKit.bundle"];
    
    return [UIImage imageWithContentsOfFile:path];
}
@end
