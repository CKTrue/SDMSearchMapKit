//
//  MapBaseViewController.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/20.
//

#import "MapBaseViewController.h"
#import "SearchResultCell.h"
#import "SearchResultVC.h"
#import "SearchResultModel.h"
#import "SDMSearchResultListVC.h"
#import "TempOneView.h"
@interface MapBaseViewController ()<GMSMapViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)SearchResultModel*resultModel;

@end

@implementation MapBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    double lat=0;
    double lng=0;

    if(DEF_PERSISTENT_GET_OBJECT(@"userLat")){
        lat=[DEF_PERSISTENT_GET_OBJECT(@"userLat") doubleValue];
        lng=[DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue];
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lng zoom:12];
       _mapView= [GMSMapView mapWithFrame:CGRectZero camera:camera];
       _mapView.delegate = self;
       _mapView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
       _mapView.settings.compassButton = YES;
       _mapView.myLocationEnabled = YES;
       _mapView.settings.myLocationButton = NO;
       [_mapView setMinZoom:1 maxZoom:19];

       [self.view addSubview:_mapView];
    [self CreateSearchView];
    [self CreateLandView];
}
-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    [self.searchView.SearchTF endEditing:YES];
}
#pragma mark---------searchTF
-(void)CreateSearchView{
    self.searchView=[[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]lastObject];
    [self.view addSubview:self.searchView];
    self.searchView.frame=CGRectMake(8,56, SCREEN_WIDTH-16, 48);
    
    [self.searchView.backBtn addTarget:self action:@selector(PopController) forControlEvents:UIControlEventTouchUpInside];

    
    self.MyLocationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //self.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,SCREEN_HEIGHT-TabBarHeight-10, 56, 56);
    [self.view addSubview:self.MyLocationBtn];
    self.MyLocationBtn.layer.cornerRadius=28;
    self.MyLocationBtn.layer.masksToBounds=YES;
    self.MyLocationBtn.backgroundColor=[UIColor whiteColor];
   
    [self.MyLocationBtn setImage:[UIImage imageNamed:@"MyLocation"] forState:UIControlStateNormal];
    [self.MyLocationBtn addTarget:self action:@selector(ShowMyCurrentLocation) forControlEvents:UIControlEventTouchUpInside];

  

}

-(void)ShowMyCurrentLocation{
    double lat=0;
    double lng=0;

    if(DEF_PERSISTENT_GET_OBJECT(@"userLat")){
        lat=[DEF_PERSISTENT_GET_OBJECT(@"userLat") doubleValue];
        lng=[DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue];
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lng zoom:12];
    self.mapView.camera=camera;

}
-(void)PopController{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
#pragma mark---------landView
-(void)CreateLandView{
    
    self.landView=[[[NSBundle mainBundle]loadNibNamed:@"SDMLandingView" owner:self options:nil]lastObject];
    [self.view addSubview:self.landView];
    self.landView.frame=CGRectMake(0,Y1+5, SCREEN_WIDTH,29);
  
}
#pragma mark - 懒加载
-(SearchResultVC *)resultVC
{
if (!_resultVC) {
    _resultVC = [[SearchResultVC alloc] init];
    
}
return _resultVC;
}

-(UIView *)detailView
{
if (!_detailView) {
    _detailView = [[UIView alloc] init];
    _detailView.frame = CGRectMake(0,Y7,SCREEN_WIDTH,SCREEN_HEIGHT-40);
    _detailView.layer.shadowColor = [UIColor blackColor].CGColor;
    _detailView.layer.shadowRadius = 10;
    _detailView.layer.shadowOffset = CGSizeMake(5, 5);
    _detailView.layer.shadowOpacity = 0.8;                       //      不透明度
    
  }
return _detailView;
}
-(TempOneView *)oneView
{
if (!_oneView) {
    _oneView=[[[NSBundle mainBundle]loadNibNamed:@"TempOneView" owner:self options:nil]lastObject];
    _oneView.PhotosView.isScrollStoped=1;
    _oneView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40);
   
}
return _oneView;
}



#pragma mark-------卡片视图

-(UIView *)LandgingScreenView
{
if (!_LandgingScreenView) {
    _LandgingScreenView = [[UIView alloc] init];
    _LandgingScreenView.frame = CGRectMake(0, Y2, self.view.frame.size.width,SCREEN_HEIGHT);
    _LandgingScreenView.layer.shadowColor = [UIColor blackColor].CGColor;
    _LandgingScreenView.layer.shadowRadius = 10;
    _LandgingScreenView.layer.shadowOffset = CGSizeMake(5, 5);
    _LandgingScreenView.layer.shadowOpacity = 0.8;
    //      不透明度
}
return _LandgingScreenView;
}

-(UIView *)shadowView
{
if (!_shadowView) {
    _shadowView = [[UIView alloc] init];
    _shadowView.frame = CGRectMake(0, Y2, self.view.frame.size.width,SCREEN_HEIGHT);
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowRadius = 10;
    _shadowView.layer.shadowOffset = CGSizeMake(5, 5);
    _shadowView.layer.shadowOpacity = 0.8;
    //      不透明度
}
return _shadowView;
}



#pragma mark------------地图方法
//将所有大头针放在屏幕内
-(void)GetAllMarkerInScreen{
    CLLocationCoordinate2D minCoordinate = CLLocationCoordinate2DMake(MAXFLOAT, MAXFLOAT);
    CLLocationCoordinate2D maxCoordinate = CLLocationCoordinate2DMake(-MAXFLOAT, -MAXFLOAT);
           for (SearchResultModel*model in self.resultVC.sourceArray) {
               NSString* latitude = model.latitude?model.latitude:@"0.0";
               NSString* longitude = model.longitude?model.longitude:@"0.0";
              
               if ([latitude doubleValue]< minCoordinate.latitude) {
                   minCoordinate.latitude = [latitude doubleValue];
               }
               if ([longitude doubleValue] < minCoordinate.longitude) {
                   minCoordinate.longitude  = [longitude doubleValue];
               }
               if ([latitude doubleValue] > maxCoordinate.latitude) {
                   maxCoordinate.latitude = [latitude doubleValue];
               }
               if ([longitude doubleValue] > maxCoordinate.longitude) {
                   maxCoordinate.longitude = [longitude doubleValue];
               }
           }
    
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minCoordinate.latitude + maxCoordinate.latitude) / 2.0, (minCoordinate.longitude + maxCoordinate.longitude) / 2.0);
         
    GMSCameraPosition*camera =[[GMSCameraPosition alloc]initWithLatitude:center.latitude longitude:center.longitude zoom:12 bearing:0 viewingAngle:0];
    self.mapView.camera=camera;
GMSCoordinateBounds *pointBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:maxCoordinate     coordinate:minCoordinate];
    GMSCameraUpdate *googleUpdate=[GMSCameraUpdate fitBounds:pointBounds withPadding:0];

    [self.mapView animateWithCameraUpdate:googleUpdate];
}
#pragma mark-----------导航
-(void)doNavigationWithEndLocation:(NSArray *)endLocation
{
    
    //NSArray * endLocation = [NSArray arrayWithObjects:@"26.08",@"119.28", nil];
    
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果原生地图-苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"Apple Map";
    [maps addObject:iosMapDic];
    
    
   
    
   
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"Google Map";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"ToyotaSearch",@"sdmtoyotapoisearch",endLocation[0], endLocation[1]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    //waze
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL
    URLWithString:@"waze://"]])
    {
        NSMutableDictionary *WazeDic = [NSMutableDictionary dictionary];
        WazeDic[@"title"] = @"Waze";
    NSString *urlStr = [[NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",[endLocation[0] doubleValue], [endLocation[1] doubleValue]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        WazeDic[@"url"] = urlStr;
        [maps addObject:WazeDic];
    }
    

    
    
    //选择
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Choose Map" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSInteger index = maps.count;
    
    for (int i = 0; i < index; i++) {
        
        NSString * title = maps[i][@"title"];
        
        //苹果原生地图方法
        if (i == 0) {
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMap:endLocation];
            }];
            [alert addAction:action];
            
            continue;
        }
        
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *urlString = maps[i][@"url"];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
                            
            }];
        }];
        
        [alert addAction:action];
        
    }
    UIAlertAction * cancelaction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
       
    }];
    
    [alert addAction:cancelaction];

    [self  presentViewController:alert animated:YES completion:nil];
    
    
}





//苹果地图
- (void)navAppleMap:(NSArray*)array
{
//    CLLocationCoordinate2D gps = [JZLocationConverter bd09ToWgs84:self.destinationCoordinate2D];
    
    //终点坐标
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([array[0] doubleValue], [array[1] doubleValue]);
    
    
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
    
    
    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    //第二个，都可以用
//    NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
//                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
