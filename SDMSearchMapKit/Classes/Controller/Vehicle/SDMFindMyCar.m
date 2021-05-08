//
//  SDMFindMyCar.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/25.
//

#import "SDMFindMyCar.h"
#import "SDMMyCarLocationView.h"
@interface SDMFindMyCar ()<UIGestureRecognizerDelegate,SDMMyCarLocationViewDelegate>{
    CLLocationCoordinate2D CarLocation;
}
@property(nonatomic,strong)SDMMyCarLocationView*locationView;
@property(nonatomic,strong)NSMutableDictionary*dic;

@end

@implementation SDMFindMyCar
-(void)viewWillAppear:(BOOL)animated{
    self.dic=[USER_DEFAULT objectForKey:@"MyCar"];
    [self createlocationView:self.dic];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchView.hidden=YES;
    self.landView.hidden=YES;
    self.titleLabel.text=@"Vehicle Location";
    self.dic=[[NSMutableDictionary alloc]init];
    
    double lat=33.767270172369734;
    double lng=-118.19243887780138;
   
       // [[SDMSwiftToOC sharedInstance] FindMyCar];
        NSString*jsonString=[USER_DEFAULT objectForKey:@"MyCarLocation"];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
          NSError *err;
            NSDictionary*jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
           
                                                    error:&err];
            double mylng= [DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue];
            if (mylng>110&&mylng<120) {
                if (jsonDic[@"Latitude"]) {
                    lat=[jsonDic[@"Latitude"] doubleValue];
                }
                if (jsonDic[@"Longitude"]) {
                    lng=[jsonDic[@"Longitude"] doubleValue];
                }
            }
        
            [self.dic setValue:@(lat) forKey:@"lat"];
            [self.dic setValue:@(lng) forKey:@"lng"];

           
            [USER_DEFAULT setObject:self.dic forKey:@"MyCar"];

    }
   
   
    
   
   // GMSCameraPosition*camera =[[GMSCameraPosition alloc]initWithLatitude:[self.dic[@"lat"] doubleValue] longitude:[self.dic[@"lng"] doubleValue] zoom:15];
   // self.mapView.camera=camera;

  
}
-(SDMMyCarLocationView*)locationView{
    if (!_locationView) {
        _locationView=(SDMMyCarLocationView*)[[ToolManager shareManager] creatAllreadAlterView:@"SDMMyCarLocationView"];
        [self.view addSubview:self.shadowView];
        DSLog(@"%f",[UIScreen mainScreen].bounds.size.height/2);
        self.shadowView.frame=CGRectMake(0,self.view.frame.size.height-400, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.shadowView addSubview:_locationView];
        _locationView.delegate=self;
        _locationView.frame=self.shadowView.bounds;
    }
    return _locationView;
}
#pragma mark---------locationView
-(void)createlocationView:(NSMutableDictionary*) dic{

   // [self.marker.map clear];
    //self.marker.map=nil;
   
    self.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,self.shadowView.frame.origin.y-60, 56, 56);
    CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([dic[@"lat"] doubleValue], [dic[@"lng"] doubleValue]);

    CLLocationCoordinate2D coor2=CLLocationCoordinate2DMake([DEF_PERSISTENT_GET_OBJECT(@"userLat") doubleValue], [DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue]);
 
   // self.marker = [GMSMarker markerWithPosition:coor];
   // self.marker.groundAnchor=CGPointMake(0.5, 0.5);
   // self.marker.map = self.mapView;
  
   // self.marker.icon=[UIImage imageNamed:@"markerCarIcon"];

    
    double Distance=[[ToolManager shareManager] getDistanceMetresBetweenLocationCoordinatesLocation1:coor Location2:coor2];
   
    self.locationView.distancelabel.text=[[ToolManager shareManager] setDistanceStr:Distance];
    NSDate*date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*str=[formatter stringFromDate:date];
    self.locationView.TimeLabel.text=[NSString stringWithFormat:@"Last Updated %@",str];
    if (Distance<100) {
        self.locationView.NavigateBtn.backgroundColor=[UIColor lightGrayColor];
        [self.locationView.NavigateBtn setEnabled:NO];
    }else{
         self.locationView.NavigateBtn.backgroundColor=[UIColor blackColor];

        [self.locationView.NavigateBtn setEnabled:YES];

    }
    kWeakSelf;
//    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coor completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
//
//        GMSAddress* addressObj=[response results].firstObject;
//        NSString*str=@"";
//        if (addressObj.thoroughfare) {
//           str= [str stringByAppendingString:[NSString stringWithFormat:@"%@",addressObj.thoroughfare]];
//        }
//        if (addressObj.subLocality) {
//           str= [str stringByAppendingString:[NSString stringWithFormat:@",%@",addressObj.subLocality]];
//        }
//        if (addressObj.locality) {
//           str= [str stringByAppendingString:[NSString stringWithFormat:@",%@",addressObj.locality]];
//        }
//        if (addressObj.administrativeArea) {
//           str= [str stringByAppendingString:[NSString stringWithFormat:@",%@",addressObj.administrativeArea]];
//        }
//        if (addressObj.country) {
//           str= [str stringByAppendingString:[NSString stringWithFormat:@",%@",addressObj.country]];
//        }
//        weakSelf.locationView.LocationLabel.text=str;
//
//    }];
    
                    

                
    
  
    UIPanGestureRecognizer*pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate=self;
    [self.locationView addGestureRecognizer:pan];
  
   
}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    if (pan.state == UIGestureRecognizerStateChanged){
    
    //返回的是相对于self.view的偏移量
    CGPoint point = [pan translationInView:self.view] ;
       
    if (self.shadowView.frame.origin.y <= Y1) {
        self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, 0) ;
    }else{
       
    self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, point.y) ;
            if(self.MyLocationBtn.origin.y>100){
        self.MyLocationBtn.transform=CGAffineTransformTranslate(self.MyLocationBtn.transform, 0, point.y) ;
            
        }
    }
        
        
   // }

//    NSLog(@"----- y = %f ------", self.shadowView.frame.origin.y);
     //每次移动完成之后需要将偏移量清零（如果不清零，偏移量是叠加的）
    [pan setTranslation:CGPointZero inView:self.view] ;
        if(point.y<0){
            self.UpOrDown=1;//向上
        }
        if(point.y>0){
            self.UpOrDown=2;//向下
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        float stopY = 0;
        
        if (self.UpOrDown==1) {
            
            // 停在y1的位置
            stopY = self.view.size.height-400;

            
        }
        else{
            // 停在y2的位置
            stopY = self.view.size.height-400;
        }
        kWeakSelf;
//        NSLog(@"     %f        ", stopY);
        [UIView animateWithDuration:0.4 animations:^{
            
            weakSelf.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width,SCREEN_HEIGHT-Y1-10);
            weakSelf.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,stopY-60, 56, 56);

            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
}

-(void)SDMMyCarLocationViewClickNavigate{
    [self doNavigationWithEndLocation:@[@(CarLocation.latitude),@(CarLocation.longitude)]];
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
