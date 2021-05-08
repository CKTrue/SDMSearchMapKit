//
//  MapViewController.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/22.
//

#import "SDMMapHistoryViewController.h"
#import "SearchResultCell.h"
#import "SearchResultModel.h"
#import "TempOneView.h"
#import "CustomWebView.h"
#import "MapHistoryView.h"
#import "SearchResultVC.h"
#import "SDMFavoriteViewController.h"
#import "SDMSearchResultListVC.h"
#import "FavoriteListModel.h"
#import "HistoryModel.h"
#import "SDMHistoryViewController.h"
#import "VoiceSpeechView.h"
#import "SearchResultViewModel.h"
#import "SDMDrivingRangeCell.h"
#import "SDMMapSearchResultCell.h"
#import "SDMVehicleLocationCell.h"
#import "CallRSACell.h"
#import "SDMMapSearchDetailViewController.h"
#import "SDMMapSearchResultViewController.h"
#import "SDMFaVoriteAndHistoryViewController.h"
@interface SDMMapHistoryViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SearchResultCellDelegate,MapHistoryViewDelegate,VoiceSpeechViewDelegate,SDMMapSearchResultCellDelegate,CallRSACellDelegate>{
    UIView*MengView;//蒙版
    double distance;//人距车的距离
}


@property(nonatomic,strong)BaseTableView*ReslutTableView;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)MapHistoryView*historyView;
@property(nonatomic,strong)SearchResultModel*resultModel;

@property (assign, nonatomic)CGFloat ResultHeight;//结果集页面高度
@property(nonatomic,strong)NSMutableArray*FavoriteArray;
@property(nonatomic,strong)NSMutableArray*HistoryArray;
@property(nonatomic,strong)UIScrollView*HistoryScrollView;
@property(nonatomic,strong)VoiceSpeechView*speechView;
@property(nonatomic,strong)NSDictionary*VehicleStatus;
@property(nonatomic,strong)NSDictionary*MyCar;

@property(nonatomic,strong)SearchResultModel*ResponseListModel;

@end

@implementation SDMMapHistoryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([USER_DEFAULT boolForKey:@"clearSearchTF"] ==YES) {
        self.searchView.SearchTF.text=@"";
        [_ReslutTableView removeFromSuperview];
        [self.searchView.SearchTF becomeFirstResponder];
    }
    [USER_DEFAULT removeObjectForKey:@"clearSearchTF"];
    
    if ([USER_DEFAULT boolForKey:@"editSearchTF"] ==YES) {
        [_ReslutTableView removeFromSuperview];
        [self.searchView.SearchTF becomeFirstResponder];
    }
    [USER_DEFAULT removeObjectForKey:@"editSearchTF"];
    
    

    kWeakSelf;
    self.FavoriteArray=[[ToolManager shareManager] getDataWithUserDefalutKey:FavoriteData];
    
        
    [[SearchResultViewModel defaultModel] requestGetFavoriteSucceed:^(id  _Nonnull data) {
        weakSelf.FavoriteArray=[FavoriteListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [[ToolManager shareManager] SaveDataWithUserDefalutKey:FavoriteData ArchiverDataObject:weakSelf.FavoriteArray];
        [weakSelf HistoryViewOnScrollV];


        
    } fail:^(NSError * _Nonnull error) {
        
    }];
    
    
    self.HistoryArray=[[ToolManager shareManager] getDataWithUserDefalutKey:HistoryData];
    
  //  if (self.HistoryArray.count==0) {
        
    [[SearchResultViewModel defaultModel] requestGetHistory:0 Pagesize:10 succeed:^(id  _Nonnull data) {
        
        weakSelf.HistoryArray=[HistoryModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
        
        [[ToolManager shareManager] SaveDataWithUserDefalutKey:HistoryData ArchiverDataObject:weakSelf.HistoryArray];
        [weakSelf.historyView.MapHistoryTabV reloadData];
        [weakSelf HistoryViewOnScrollV];

        
        } fail:^(NSError * _Nonnull error) {
            
        }];
    
   // }
    [self HistoryViewOnScrollV];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    if (self.tabBarController.selectedIndex==1) {
        
        
        
    }else{
        self.searchView.SearchTF.text=@"";
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"mic"] forState:UIControlStateNormal];
        
        [_ReslutTableView removeFromSuperview];
        
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //获取车辆信息
    
    self.VehicleStatus=[USER_DEFAULT objectForKey:@"VehicleStatus"];
    
    [self addChildViewController:self.resultVC];
    
    
    self.ResultHeight=0;
    
    self.dataArray=[[NSMutableArray alloc]init];
    self.FavoriteArray=[[NSMutableArray alloc]init];
    self.HistoryArray=[[NSMutableArray alloc]init];
    
    
    [self ShowSearchView];
    
    self.landView.hidden=YES;
    
    
    NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
    [nCenter addObserver:self selector:@selector(languageChanged:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
    
    
}


- (void)languageChanged:(NSNotification*)notification
{
    NSLog(@"Current: %@", [UIApplication sharedApplication].delegate.window.textInputMode.primaryLanguage);
    [HSpeechRecognizer share].Language= [UIApplication sharedApplication].delegate.window.textInputMode.primaryLanguage;
}


#pragma mark---------searchTF
-(void)ShowSearchView{
    
    self.searchView.SearchTF.delegate=self;
    [self.searchView.SearchTF becomeFirstResponder];
    [self.searchView.SearchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.searchView.checkPasswordBtn addTarget:self action:@selector(VoiceSpeech) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView.backBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"left_arrow"] forState:UIControlStateNormal];

    self.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,SCREEN_HEIGHT-TabBarHeight-66, 56, 56);
    
    
}

#pragma mark----------scrollView
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.searchView.SearchTF endEditing:YES];
}

#pragma mark----UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    kWeakSelf;
    if (self.searchView.SearchTF.text.length==0) {
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"mic"] forState:UIControlStateNormal];
            [self.HistoryScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView animateWithDuration:0.2 animations:^{
                
                weakSelf.HistoryScrollView.frame=CGRectMake(8, Y1, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
            }];
        
    }else{
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"close"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.HistoryScrollView.frame=CGRectMake(8, SCREEN_HEIGHT, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
        }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    kWeakSelf;
    if (self.searchView.SearchTF.text.length==0){
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"mic"] forState:UIControlStateNormal];
        [self.HistoryScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.HistoryScrollView.frame=CGRectMake(8, Y1, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
        }];
        
    }else{
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"close"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.HistoryScrollView.frame=CGRectMake(8, SCREEN_HEIGHT, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
        }];
    }
    [textField resignFirstResponder];
        
}
-(void)textFieldDidChange:(UITextField*)textField{
    
    // [self removeShadowAndDetailView];
    kWeakSelf;
    if(textField.text.length==0){
        [_ReslutTableView removeFromSuperview];
        [self.searchView.activityIndicator stopAnimating];
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"mic"] forState:UIControlStateNormal];
        [self.HistoryScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.HistoryScrollView.frame=CGRectMake(8, Y1, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
        }];
        
    }else{
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"close"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.HistoryScrollView.frame=CGRectMake(8, SCREEN_HEIGHT, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
        }];
    }
    
    
    if(textField.markedTextRange!=nil){
        return;
    }else{
        if(textField.text.length>0&&textField.text.length<500){
            [self.searchView.activityIndicator startAnimating];
            [self performSelector:@selector(DelayRequest:) withObject:textField.text afterDelay:0.5];
            
        }
    }
}
-(void)DelayRequest:(NSString*)text{
    //  [self removeShadowAndDetailView];
    kWeakSelf;
    [_ReslutTableView removeFromSuperview];
    
    if([text isEqualToString:self.searchView.SearchTF.text]){
       
        NSString* lat=[NSString stringWithFormat:@"%@",DEF_PERSISTENT_GET_OBJECT(@"userLat")];
        NSString* lng=[NSString stringWithFormat:@"%@",DEF_PERSISTENT_GET_OBJECT(@"userLng")];
       
        
        [[SearchResultViewModel defaultModel] requestSearchSuggestSuccess:self.searchView.SearchTF.text MapSearchRadius:[[ToolManager shareManager] GetDistanceByMapScale:0] Lat:lat Lng:lng succeed:^(id  _Nonnull data) {
            weakSelf.ResponseListModel=[[SearchResultModel alloc]init];
            weakSelf.ResultHeight=0;

            [weakSelf.searchView.activityIndicator stopAnimating];
            
            weakSelf.dataArray=[SearchResultModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
            if (weakSelf.dataArray.count==0) {
                [weakSelf AlertViewShowMsg:@"No Data"];
                
                return;
            }
            //计算suggest tableview页面高度
            for (SearchResultModel*model in weakSelf.dataArray) {
                
                if ([model.local_provider_enum intValue]==6) {
                    weakSelf.ResultHeight+=(SCREEN_WIDTH-34)*48/343+138+(model.search_response_list.count-1)*70;
                }
                else{
                    if ([model.local_provider_enum intValue]==8) {
                        weakSelf.ResultHeight+=model.search_response_list.count*58;
                        weakSelf.ResponseListModel=model;
                        
                    }else{
                        weakSelf.ResultHeight+=93+(model.search_response_list.count-1)*70;
                    }
                }
                
            }
            SearchResultModel*model1=[[SearchResultModel alloc]init];
            if (weakSelf.ResponseListModel.search_response_list.count>0) {
                model1.search_response_list=weakSelf.ResponseListModel.search_response_list;
            }
            if (weakSelf.VehicleStatus) {
                
                model1.vehiclestatus=weakSelf.VehicleStatus;
            }
            
            [weakSelf.dataArray removeObject:self.ResponseListModel];
            
            [weakSelf.dataArray insertObject:model1 atIndex:0];
            
            if (self->distance>100) {
                weakSelf.ResultHeight+=169;
            }else{
                weakSelf.ResultHeight=weakSelf.ResultHeight+93;
            }
            
            if (weakSelf.ResultHeight>SCREEN_HEIGHT-140-TabBarHeight-BottomHeight){
                weakSelf.ResultHeight=SCREEN_HEIGHT-140-TabBarHeight-BottomHeight;
            }
            
            
            if (weakSelf.searchView.SearchTF.text.length!=0){
                
                [weakSelf.view addSubview:weakSelf.ReslutTableView];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.ReslutTableView reloadData];
                    
                });
            }
        } fail:^(NSError * _Nonnull error) {
            [weakSelf.searchView.activityIndicator stopAnimating];
            
        }];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_ReslutTableView removeFromSuperview];
    SearchResultModel*model=[[SearchResultModel alloc]init];
    model.local_provider_enum=@"6";
    
    SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
    vc.ResultModel=model;
    vc.SearchStr=self.searchView.SearchTF.text;
    [self.navigationController pushViewController:vc animated:NO];
    
    return YES;
    
}

#pragma mark-----------语音识别
-(void)VoiceSpeech{
    if ([self.searchView.checkPasswordBtn.currentImage isEqual:[[ToolManager shareManager]creatZhujianImgView:@"close"]]) {
        kWeakSelf;
            self.searchView.SearchTF.text=@"";
        [self.searchView.SearchTF becomeFirstResponder];
            [_ReslutTableView removeFromSuperview];
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"mic"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                
                weakSelf.HistoryScrollView.frame=CGRectMake(8, Y1, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
            }];
       
    }
    else if ([self.searchView.checkPasswordBtn.currentImage isEqual:[[ToolManager shareManager]creatZhujianImgView:@"mic"]]) {
        
        
          // [self CreateVoiceView];
        
    }else{
        NSLog(@"3");
    }
    
}

#pragma mark----------创建录音页面
-(void)CreateVoiceView{
    self.speechView=(VoiceSpeechView*)[[ToolManager shareManager] creatAllreadAlterView:@"VoiceSpeechView"];
;
    self.speechView.frame=CGRectMake(0, SCREEN_HEIGHT-270, SCREEN_WIDTH, 270);
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    MengView=[[UIView alloc]initWithFrame:window.bounds];
    MengView.backgroundColor=[UIColor blackColor];
    MengView.alpha=0.2;
    
    [window addSubview:MengView];
    [window addSubview:self.speechView];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CloseVoiceView)];
    [MengView addGestureRecognizer:tap];
    self.speechView.delegate=self;
}
-(void)VoiceTextChange:(NSString *)changetext{
    self.searchView.SearchTF.text=changetext;
}
//关闭
-(void)CloseVoiceView{
    if ([[HSpeechRecognizer share].audioEngine isRunning]) {
        return;
    }
    [self.speechView removeFromSuperview];
    self.speechView=nil;
    [MengView removeFromSuperview];
    [HSpeechRecognizer share].speechRecognizer=nil;
    
    
}
//语音录入结束
-(void)VoiceTextEnd{
    [self.speechView removeFromSuperview];
    self.speechView=nil;
    [MengView removeFromSuperview];
    
    [HSpeechRecognizer share].speechRecognizer=nil;
    [self textFieldDidChange:self.searchView.SearchTF];
}
#pragma mark--------history视图
-(MapHistoryView*)historyView{
    if(!_historyView){
        self.HistoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(8, Y1, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight)];
        self.HistoryScrollView.bounces=NO;
        
        self.HistoryScrollView.delegate=self;
        self.HistoryScrollView.backgroundColor=[UIColor whiteColor];
        _historyView=(MapHistoryView*)[[ToolManager shareManager] creatAllreadAlterView:@"MapHistoryView"];
        _historyView.frame=self.HistoryScrollView.bounds;
        self.historyView.MapHistoryTabV.scrollsToTop=NO;
        
        [self.HistoryScrollView addSubview:_historyView];
        
        [self.view addSubview:self.HistoryScrollView];
        
    }
    _historyView.delegate=self;
    return _historyView;
    
}
-(void)HistoryViewOnScrollV{
    NSInteger index=self.FavoriteArray.count;
    if (self.FavoriteArray.count>10) {
        index=10;
    }
    NSInteger count=self.HistoryArray.count;
    if (self.HistoryArray.count>10) {
        count=0;
    }
    kWeakSelf;
    
    
    //获取车的位置信息
    self.MyCar=[USER_DEFAULT objectForKey:@"MyCar"];
    
    CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([DEF_PERSISTENT_GET_OBJECT(@"userLat") doubleValue], [DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue]);
    CLLocationCoordinate2D coor2=CLLocationCoordinate2DMake([self.MyCar[@"lat"] doubleValue], [self.MyCar[@"lng"] doubleValue]);
    
     distance=[[ToolManager shareManager] getDistanceMetresBetweenLocationCoordinatesLocation1:coor Location2:coor2];
    self.historyView.MyCarDistanceLabel.text=[[ToolManager shareManager] setDistanceStr:distance];
  
//    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coor2 completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
//        
//        GMSAddress* addressObj=[response results].firstObject;
//        NSString*str=@"";
//        if (addressObj.thoroughfare) {
//            str= [str stringByAppendingString:[NSString stringWithFormat:@"%@",addressObj.thoroughfare]];
//        }
//        if (addressObj.subLocality) {
//            str= [str stringByAppendingString:[NSString stringWithFormat:@",%@",addressObj.subLocality]];
//        }
//        if (addressObj.locality) {
//            str= [str stringByAppendingString:[NSString stringWithFormat:@",%@",addressObj.locality]];
//        }
//        if (addressObj.administrativeArea) {
//            str= [str stringByAppendingString:[NSString stringWithFormat:@",%@",addressObj.administrativeArea]];
//        }
//        if (addressObj.country) {
//            str= [str stringByAppendingString:[NSString stringWithFormat:@",%@",addressObj.country]];
//        }
//        weakSelf.historyView.MyCarAddressLabel.text=str;
//        
//    }];
    
    
    
    NSMutableArray*array=[[NSMutableArray alloc]initWithArray:[self.FavoriteArray subarrayWithRange:NSMakeRange(0, index)]];
    if(![array isEqualToArray:self.historyView.FavoritesView.DataArray]){
        self.historyView.FavoritesView.width=self.historyView.bounds.size.width;
        self.historyView.FavoritesView.DataArray=array;
        
    }
    
    self.HistoryScrollView.contentSize=CGSizeMake(0, 315+self.HistoryArray.count*70);
    _historyView.frame=CGRectMake(0, 0, SCREEN_WIDTH-16, 315+self.HistoryArray.count*70);
    
    NSMutableArray*subarray=[[NSMutableArray alloc]initWithArray:[self.HistoryArray subarrayWithRange:NSMakeRange(0, count)]];

    if(![subarray isEqualToArray:self.historyView.HistoryArray]){
        self.historyView.HistoryArray=subarray;
        
    }
    [self.historyView.MapHistoryTabV reloadData];
    
    
    
//    if(self.searchView.SearchTF.text.length==0){
//        [self.HistoryScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [UIView animateWithDuration:0.2 animations:^{
//
//            weakSelf.HistoryScrollView.frame=CGRectMake(8, Y1, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
//
//        }];
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            weakSelf.HistoryScrollView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH-16, SCREEN_HEIGHT-Y1-TabBarHeight);
//
//        }];
//    }
}

#pragma mark-----懒加载tableview
-(BaseTableView*)ReslutTableView{
    if (!_ReslutTableView) {
        _ReslutTableView=[[BaseTableView alloc]init];
        _ReslutTableView.backgroundColor=[UIColor clearColor];
        _ReslutTableView.separatorColor=[UIColor clearColor];
        [_ReslutTableView registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"SearchResultCell"];
        [_ReslutTableView registerNib:[UINib nibWithNibName:@"SDMDrivingRangeCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"SDMDrivingRangeCell"];
        [_ReslutTableView registerNib:[UINib nibWithNibName:@"SDMMapSearchResultCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"SDMMapSearchResultCell"];
        [_ReslutTableView registerNib:[UINib nibWithNibName:@"MapSearchOtherCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"MapSearchOtherCell"];
        [_ReslutTableView registerNib:[UINib nibWithNibName:@"CallRSACell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"CallRSACell"];
        [_ReslutTableView registerNib:[UINib nibWithNibName:@"SDMVehicleLocationCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"SDMVehicleLocationCell"];

        _ReslutTableView.bounces=NO;
    }
    _ReslutTableView.frame=CGRectMake(10, Y1, SCREEN_WIDTH-20, self.ResultHeight);
    _ReslutTableView.scrollsToTop=NO;
    
    _ReslutTableView.dataSource=self;
    _ReslutTableView.delegate=self;
    return _ReslutTableView;
}
#pragma mark----------tableviewDelegate&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SearchResultModel*model=self.dataArray[section];
    
    if (section==0) {
        if(distance>100){
            return model.search_response_list.count+2;

        }
        return model.search_response_list.count+1;
    }
    return model.search_response_list.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultModel*model=self.dataArray[indexPath.section];
    
    if (indexPath.section==0) {
        if (distance>100) {
           if (indexPath.row==0) {
               SDMVehicleLocationCell*locationCell=[tableView dequeueReusableCellWithIdentifier:@"SDMVehicleLocationCell" forIndexPath:indexPath];
               locationCell.selectionStyle=UITableViewCellSelectionStyleNone;
               locationCell.AddressLabel.text=self.historyView.MyCarAddressLabel.text;
               locationCell.DistanceLabel.text=self.historyView.MyCarDistanceLabel.text;
               return locationCell;
            }
            if (indexPath.row==1) {

            SDMDrivingRangeCell*Rangecell=[tableView dequeueReusableCellWithIdentifier:@"SDMDrivingRangeCell" forIndexPath:indexPath];
            
            Rangecell.selectionStyle=UITableViewCellSelectionStyleNone;
            Rangecell.KindTypeHeight.constant=0;
            [Rangecell setModel:model];
            return Rangecell;
            }
            CallRSACell*CallCell=[tableView dequeueReusableCellWithIdentifier:@"CallRSACell" forIndexPath:indexPath];
            CallCell.delegate=self;
            [CallCell setModel:model.search_response_list[indexPath.row-2]];
            
            CallCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            return CallCell;
        }else{
            if (indexPath.row==0) {

            SDMDrivingRangeCell*Rangecell=[tableView dequeueReusableCellWithIdentifier:@"SDMDrivingRangeCell" forIndexPath:indexPath];
            
            Rangecell.selectionStyle=UITableViewCellSelectionStyleNone;
            Rangecell.KindTypeHeight.constant=17;
            [Rangecell setModel:model];
            return Rangecell;
            }
            CallRSACell*CallCell=[tableView dequeueReusableCellWithIdentifier:@"CallRSACell" forIndexPath:indexPath];
            CallCell.delegate=self;
            [CallCell setModel:model.search_response_list[indexPath.row-1]];
            
            CallCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            return CallCell;
            
            
        }
        
        
        
    }
    
    
    if (indexPath.row==0) {
        if ([model.local_provider_enum intValue]==6) {
            
            SDMMapSearchResultCell*MapCell=[tableView dequeueReusableCellWithIdentifier:@"SDMMapSearchResultCell" forIndexPath:indexPath];
            MapCell.delegate=self;
            SearchResultModel*mapmodel=model.search_response_list[indexPath.row];
            mapmodel.vehiclestatus=self.VehicleStatus;
            [MapCell setModel:mapmodel];
            MapCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            return MapCell;
        }
    }
    SearchResultCell*EventCell=[tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    EventCell.delegate=self;
    EventCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    SearchResultModel*eventmodel=model.search_response_list[indexPath.row];
    eventmodel.vehiclestatus=self.VehicleStatus;
    
    [EventCell setModel:eventmodel];
    if (indexPath.row==0) {
        EventCell.OtherTopViewHeight.constant=25;
        EventCell.KindTypeView.hidden=NO;
    }else{
        EventCell.OtherTopViewHeight.constant=0;
        EventCell.KindTypeView.hidden=YES;
    }
    
    if (indexPath.row==model.search_response_list.count-1){
        EventCell.LineLabel.hidden=YES;
    }else{
        EventCell.LineLabel.hidden=NO;
    }
    
    if ([eventmodel.local_provider_enum intValue]==2||[eventmodel.local_provider_enum intValue]==6){
        EventCell.DateWidth.constant=80;
        EventCell.DateLabel.hidden=NO;
    }else{
        EventCell.DateWidth.constant=0;
        
        EventCell.DateLabel.hidden=YES;
    }
    return EventCell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
            if(distance>100){
                if (indexPath.row==0) {
                self.tabBarController.selectedIndex=2;
            }
                if (indexPath.row==1) {
                
               SDMFindMyCar*vc=[[SDMFindMyCar alloc]init];
               vc.hidesBottomBarWhenPushed=YES;
               [self.navigationController pushViewController:vc animated:NO];
             }
        }else{
            if (indexPath.row==0) {
           SDMFindMyCar*vc=[[SDMFindMyCar alloc]init];
           vc.hidesBottomBarWhenPushed=YES;
           [self.navigationController pushViewController:vc animated:NO];
         }
        }
    }else{
        
        SearchResultModel*resultmodel=self.dataArray[indexPath.section];
        SearchResultModel*detailmodel=resultmodel.search_response_list[indexPath.row];
        
        if ([detailmodel.local_provider_enum intValue]==2||[detailmodel.local_provider_enum intValue]==6) {
            
           
            SDMMapSearchDetailViewController*vc=[[SDMMapSearchDetailViewController alloc]init];
            vc.DetailModel=detailmodel;
            vc.SearchStr=self.searchView.SearchTF.text;
            vc.hidesBottomBarWhenPushed=YES;

            [self.navigationController pushViewController:vc animated:NO];
          
            
        }
        else if ([resultmodel.local_provider_enum intValue]==4){
            SDMFindMyCar*vc=[[SDMFindMyCar alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:NO];
        }
        else{
            CustomWebView*vc=[[CustomWebView alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.titleStr=detailmodel.title;
            vc.urlString=detailmodel.link;
            [self.navigationController pushViewController:vc animated:NO];
            
        }
        
        
        
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 93;
        }
        if (distance>100) {
            if (indexPath.row==1) {
                return 66;
            }
        }
        return 58;
    }
    SearchResultModel*model=self.dataArray[indexPath.section];
    if ([model.local_provider_enum intValue]==6) {
        if (indexPath.row==0) {
            return 138+(SCREEN_WIDTH-34)*48/343;
        }
        return 70;
    }
    if (indexPath.row==0) {
        return 93;
        
    }
    
    
    return 70;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView*footV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 6)];
    footV.backgroundColor=[UIColor colorWithRed:244/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    return footV;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0||section==self.dataArray.count-1) {
        return 0;
    }
    return 6;
}
#pragma mark-------CallRSACelldelegate
-(void)CallRSACellClickCallPhone:(CallRSACell *)cell{
    CustomWebView*vc=[[CustomWebView alloc]init];
    vc.urlString=cell.model.link;
    vc.titleStr=cell.model.title;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark----------SDMMapSearchResultCellDelegate
-(void)ClickSeeAllBtnByMapSearchRsultCell:(SDMMapSearchResultCell *)cell{
    if ([cell.Model.local_provider_enum intValue]==2||[cell.Model.local_provider_enum intValue]==6) {
        SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
        vc.ResultModel=cell.Model;
        vc.SearchStr=self.searchView.SearchTF.text;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        SDMSearchResultListVC*searchlistVC=[[SDMSearchResultListVC alloc]initWithNibName:@"SDMSearchResultListVC" bundle:[[ToolManager shareManager] subBundleWithBundleName]];
        searchlistVC.hidesBottomBarWhenPushed=YES;
        [searchlistVC setResultModel:cell.Model WithSearchStr:self.searchView.SearchTF.text AndMapScale:0];
        
        [self.navigationController pushViewController:searchlistVC animated:NO];
        
    }
    
    
}
-(void)ClickGotoParkBtnByMapSearchRsultCell:(SDMMapSearchResultCell *)cell{
    
    SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
    vc.ResultModel=cell.Model;
    vc.SearchStr=@"Parking";
    vc.CellResult=YES;
    [self.navigationController pushViewController:vc animated:NO];
    
}
-(void)ClickLookCharageBtnByMapSearchRsultCell:(SDMMapSearchResultCell *)cell{
    
    SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
    vc.ResultModel=cell.Model;
    vc.SearchStr=@"gas";
    vc.CellResult=YES;
    [self.navigationController pushViewController:vc animated:NO];
    
}
-(void)ClickLookFillingBtnByMapSearchRsultCell:(SDMMapSearchResultCell *)cell{
    
    
    SDMFindMyCar*vc=[[SDMFindMyCar alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:NO];
    
}
-(void)ClickSendToCarBtnByMapSearchRsultCell:(SDMMapSearchResultCell *)cell{
    NSString*name;
    if ([cell.Model.local_provider_enum intValue]==6) {
        name=cell.Model.name;
    }else{
        name=cell.Model.title;
        
    }
    if (!cell.Model.place_id) {
        cell.Model.place_id=@"ChIJ7SMTt5OOtTURkpz21qWdvtk";
    }
  //  NSDictionary*dic=@{@"poiname":name,@"placeId":cell.Model.place_id,@"latitude":cell.Model.latitude,@"longitude":cell.Model.longitude,@"address":cell.Model.address};
    //[[SDMSwiftToOC sharedInstance] pullingRefreshActionWithDic:dic];
}


#pragma mark----------SearchResultCellDelegate
-(void)ClickSeeAllBtnBySearchResultCell:(SearchResultCell *)cell{
    if ([cell.Model.local_provider_enum intValue]==2||[cell.Model.local_provider_enum intValue]==6) {
        SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
        vc.ResultModel=cell.Model;
        vc.SearchStr=self.searchView.SearchTF.text;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        SDMSearchResultListVC*searchlistVC=[[SDMSearchResultListVC alloc]initWithNibName:@"SDMSearchResultListVC" bundle:[[ToolManager shareManager] subBundleWithBundleName]];
        searchlistVC.hidesBottomBarWhenPushed=YES;
        [searchlistVC setResultModel:cell.Model WithSearchStr:self.searchView.SearchTF.text AndMapScale:0];
        
        [self.navigationController pushViewController:searchlistVC animated:NO];
        
    }
    
}
#pragma mark---------查看详情

#pragma mark-------historyviewDelgate
-(void)MapHistoryViewClickMoreFavoriteBtn{
    
    SDMFaVoriteAndHistoryViewController*vc=[[SDMFaVoriteAndHistoryViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.GotoFavorite=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)MapHistoryViewClickMoreSearchBtn{
    
    SDMFaVoriteAndHistoryViewController*vc=[[SDMFaVoriteAndHistoryViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)MapHistoryViewClickFavorite:(UIView *)favoriteView{
    [self.searchView.SearchTF endEditing:YES];
    FavoriteListModel*model=self.FavoriteArray[favoriteView.tag-100];
    
    SearchResultModel*resultmodel=[[SearchResultModel alloc]init];
    resultmodel.custom_id=model.custom_id;
    resultmodel.local_provider_enum=model.provider;
    
    SDMMapSearchDetailViewController*vc=[[SDMMapSearchDetailViewController alloc]init];
    vc.DetailModel=resultmodel;
    vc.SearchTFHidden=YES;
    vc.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:vc animated:NO];
    
}
-(void)MapHistoryViewClickSearch:(HistoryModel *)historymodel{
    [self.searchView.SearchTF endEditing:YES];
    kWeakSelf;
    
    
    if ([historymodel.provider intValue]==2||[historymodel.provider intValue]==6) {
        SearchResultModel*resultmodel=[[SearchResultModel alloc]init];
        resultmodel.custom_id=historymodel.custom_id;
        resultmodel.local_provider_enum=historymodel.provider;
        
        SDMMapSearchDetailViewController*vc=[[SDMMapSearchDetailViewController alloc]init];
        vc.DetailModel=resultmodel;
        vc.SearchTFHidden=YES;
        vc.hidesBottomBarWhenPushed=YES;

        vc.SearchStr=self.searchView.SearchTF.text;
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }
    else if ([historymodel.provider intValue]==4){
        SDMFindMyCar*vc=[[SDMFindMyCar alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [weakSelf.navigationController pushViewController:vc animated:NO];
    }
    else{

        [[SearchResultViewModel defaultModel] requestSearchResultDetailSuccess:historymodel.custom_id local_provider_num:historymodel.provider succeed:^(id  _Nonnull data) {

            SearchResultModel*model=[SearchResultModel mj_objectWithKeyValues:data[@"data"]];
            
            CustomWebView*vc=[[CustomWebView alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.titleStr=model.title;
            vc.urlString=model.link;
            [weakSelf.HistoryArray removeObject:historymodel];

            [weakSelf.HistoryArray insertObject:historymodel atIndex:0];
            [[ToolManager shareManager] SaveDataWithUserDefalutKey:HistoryData ArchiverDataObject:weakSelf.HistoryArray];

            
            [weakSelf.navigationController pushViewController:vc animated:NO];
            
        } fail:^(NSError * _Nonnull error) {
            
            
        }];
    }
    
    
    
    
    
    
}



@end
