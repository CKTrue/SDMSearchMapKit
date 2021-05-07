//
//  SDMMapSearchDetailViewController.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import "SDMMapSearchDetailViewController.h"
#import "TempOneView.h"
#import "SearchResultModel.h"
#import "FavoriteListModel.h"
#import "HistoryModel.h"
@interface SDMMapSearchDetailViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,TempOneViewdelegate>

@end

@implementation SDMMapSearchDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    DSLog(@"----%@",self.navigationController.viewControllers);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchView.ShowMapViewControllerBtn.hidden=NO;
    [self.searchView.ShowMapViewControllerBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    if (self.SearchTFHidden==YES) {
        self.searchView.hidden=YES;
    }
    [self.searchView.backBtn setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    
    [self.searchView.checkPasswordBtn addTarget:self action:@selector(clearSearchTF) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.searchView.SearchTF.text=self.SearchStr;
    
    if (self.searchView.SearchTF.text.length==0){
        [self.searchView.checkPasswordBtn setImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
        
    }else{
        [self.searchView.checkPasswordBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    }
    
    self.landView.hidden=YES;
    UIPanGestureRecognizer*pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pandetail:)];
    pan.delegate = self;
    
    [self.oneView addGestureRecognizer:pan];
    self.oneView.delegate=self;
    
    kWeakSelf;
    
    [[SearchResultViewModel defaultModel] requestSearchResultDetailSuccess:self.DetailModel.custom_id local_provider_num:self.DetailModel.local_provider_enum succeed:^(id  _Nonnull data) {

        SearchResultModel*model=[SearchResultModel mj_objectWithKeyValues:data[@"data"]];
        [weakSelf LookSearchDetail:model];
        
        NSMutableArray*historyArr=[[ToolManager shareManager] getDataWithUserDefalutKey:HistoryData];
        HistoryModel*hismodel=nil;
        for ( HistoryModel*historymodel in historyArr ) {
            if ([historymodel.custom_id isEqualToString:model.custom_id]) {
                hismodel=historymodel;
            }
        }
        if (hismodel==nil) {
            hismodel=[[HistoryModel alloc]init];
            hismodel.custom_id=model.custom_id;
            if ([model.local_provider_enum intValue]==6) {
                hismodel.title=model.name;
                hismodel.sub_title=model.address;
            }
            else {
                hismodel.title=model.title;
                hismodel.sub_title=model.sub_title;
            }

        }else{
            [historyArr removeObject:hismodel];
        
        }
        [historyArr insertObject:hismodel atIndex:0];
        [[ToolManager shareManager] SaveDataWithUserDefalutKey:HistoryData ArchiverDataObject:historyArr];
      

    } fail:^(NSError * _Nonnull error) {
       
    }];
    
    
}
-(void)clickBtn{
    kWeakSelf;
    [USER_DEFAULT setBool:YES forKey:@"editSearchTF"];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        weakSelf.detailView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-40);
        
        
        
    } completion:^(BOOL finished) {
        [weakSelf.detailView removeFromSuperview];
        
        [weakSelf.navigationController popToViewController:self.navigationController.viewControllers[1] animated:NO];
        
    }];
    
}
-(void)clearSearchTF{
    if ([self.searchView.checkPasswordBtn.currentImage isEqual:[UIImage imageNamed:@"close"]]) {
        [USER_DEFAULT setBool:YES forKey:@"clearSearchTF"];
        [self.detailView removeFromSuperview];
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:NO];
    }
}
#pragma mark------查看详情
-(void)LookSearchDetail:(SearchResultModel*)model{
    kWeakSelf;
    
    if([model.local_provider_enum intValue]==3||[model.local_provider_enum intValue]==1||[model.local_provider_enum intValue]==5||[model.local_provider_enum intValue]==7){
        // [self openScheme:model.link];
        CustomWebView*vc=[[CustomWebView alloc]init];
        
        vc.urlString=model.link;
        vc.titleStr=model.title;
        vc.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if([model.local_provider_enum intValue]==4){
        
        [JumpVC JumpViewControllerWithGetModel:model TitleName:model.title WithViewController:self.navigationController];
    }
    else{
        
        CLLocationCoordinate2D coor1=CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
        CLLocationCoordinate2D coor2=CLLocationCoordinate2DMake([DEF_PERSISTENT_GET_OBJECT(@"userLat") doubleValue], [DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue]);
        
        double Distance=[[ToolManager shareManager] getDistanceMetresBetweenLocationCoordinatesLocation1:coor1 Location2:coor2];
        
        self.oneView.model=model;
        
        
       // UIWindow*window=[UIApplication sharedApplication].keyWindow;
        [self.detailView addSubview:self.oneView];
        
        [UIView  animateWithDuration:0.2 animations:^{
            
            weakSelf.oneView.frame=weakSelf.detailView.bounds;
        }];
        
        weakSelf.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,weakSelf.detailView.frame.origin.y-60, 56, 56);
        
        
        [self.view addSubview:self.detailView];
        self.oneView.distanceLabel.text=[[ToolManager shareManager] setDistanceStr:Distance];
        
        [self.marker.map clear];
        self.marker.map=nil;
        
        if([model.local_provider_enum intValue]==2||[model.local_provider_enum intValue]==6){
            
            self.marker = [GMSMarker markerWithPosition:coor1];
            self.marker.map = self.mapView;
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[model.latitude doubleValue] longitude:[model.longitude doubleValue] zoom:12];
            
            self.mapView.camera=camera;
            if([model.local_provider_enum intValue]==2){
                
                weakSelf.marker.icon=[UIImage imageNamed:@"markericon"];
                
            }else{
                weakSelf.marker.icon=[UIImage imageNamed:@"graymarkericon"];
                
            }
            
            
        }
        
    }
    
}

#pragma mark------TempOneViewDelegate
-(void)TempOneViewClickCloseBtn:(TempOneView*)oneView{
    kWeakSelf;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        weakSelf.detailView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-40);
        
        
        
    } completion:^(BOOL finished) {
        [weakSelf.detailView removeFromSuperview];
        
        [weakSelf.navigationController popViewControllerAnimated:NO];
        
    }];
}
-(void)TempOneViewClickFavoriteBtn:(TempOneView *)oneView{
    kWeakSelf;
    if([oneView.model.is_favorite isEqualToString:@"1"]){
        
        [[SearchResultViewModel defaultModel] requestDeleteFavorite:oneView.model.custom_id succeed:^(id  _Nonnull data) {
            
            [weakSelf.oneView.FavoritesBtn setImage:[UIImage imageNamed:@"nofavirate"] forState:UIControlStateNormal];
            weakSelf.oneView.model.is_favorite=@"0";
            NSMutableArray*array=[[ToolManager shareManager] getDataWithUserDefalutKey:FavoriteData];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FavoriteListModel*favoriemodel=(FavoriteListModel*)obj;
                    if ([favoriemodel.custom_id isEqualToString:weakSelf.oneView.model.custom_id]) {
                        [array removeObject:favoriemodel];
                    }
            }];
            [[ToolManager shareManager] SaveDataWithUserDefalutKey:FavoriteData ArchiverDataObject:array];

            
        } fail:^(NSError * _Nonnull error) {
            
        }];
        
        
    }else{
        NSString*provider;
        NSString*name;
       
        if([oneView.model.local_provider_enum intValue]==2){
            provider=@"DEALER";
            name=oneView.model.title;
        }
      
        if([oneView.model.local_provider_enum intValue]==6){
            provider=@"GIS";
            name=oneView.model.name;
        }
        [[SearchResultViewModel defaultModel] requestAddFavorite:oneView.model.custom_id Lat:oneView.model.latitude Lng:oneView.model.longitude local_provider_num:provider name:name succeed:^(id _Nonnull data) {
            
            [weakSelf.oneView.FavoritesBtn setImage:[UIImage imageNamed:@"favirate"] forState:UIControlStateNormal];
            weakSelf.oneView.model.is_favorite=@"1";
            
            NSMutableArray*array=[[ToolManager shareManager] getDataWithUserDefalutKey:FavoriteData];
            FavoriteListModel*favoriemodel=[[FavoriteListModel alloc]init];
            favoriemodel.custom_id=weakSelf.oneView.model.custom_id;
            favoriemodel.name=name;
            favoriemodel.latitude=weakSelf.oneView.model.latitude;
            favoriemodel.longitude=weakSelf.oneView.model.longitude;
            favoriemodel.provider=weakSelf.oneView.model.local_provider_enum;
            [array insertObject:favoriemodel atIndex:0];
            [[ToolManager shareManager] SaveDataWithUserDefalutKey:FavoriteData ArchiverDataObject:array];

            
        } fail:^(NSError * _Nonnull error) {
            
          
        }];
    }
}
//导航
-(void)TempOneViewClickNavigateView:(SearchResultModel *)model{
    [self doNavigationWithEndLocation:@[model.latitude,model.longitude]];
    
}

-(void)TempOneViewClickShareBtn:(SearchResultModel *)model{
    NSString*shareTitle;
    if ([model.local_provider_enum intValue]==6) {
        shareTitle=model.name;
    }
    else{
        shareTitle=model.title;
    }
    UIImage *shareImage =[UIImage imageNamed:@"markericon"];
    NSString*string=[NSString stringWithFormat:@"https://appdl.stationdm.com/toyotapoisearch/?SearchDetail=%@=%@",model.custom_id,model.local_provider_enum];

    NSURL*shareUrl=[NSURL URLWithString:string];
    NSArray*ActivityItems=@[shareImage,shareTitle,shareUrl];

    UIActivityViewController*vc=[[UIActivityViewController alloc]initWithActivityItems:ActivityItems applicationActivities:nil];
    
    vc.completionWithItemsHandler=^(UIActivityType _Nullable activityType, BOOL completed, NSArray*_Nullable returnedItems, NSError * _Nullable activityError) {
    };
    [self presentViewController:vc animated:YES completion:nil];
}

//拖拽手势

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([[otherGestureRecognizer view] isKindOfClass:[UICollectionView class]]) {
        
        return NO;
    }
    if([[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]){
        if (self.oneView.OneScrollV.contentOffset.y==0) {
            return YES;
        }
        return NO;
    }
    return NO;
}
- (void)pandetail:(UIPanGestureRecognizer *)pan
{
    
    if (pan.state == UIGestureRecognizerStateChanged){
        
        if(self.detailView.frame.origin.y!=Y5){
            self.oneView.OneScrollV.scrollEnabled=NO;
        }else{
            self.oneView.OneScrollV.scrollEnabled=YES;
        }
        
        //返回的是相对于self.view的偏移量
        CGPoint point = [pan translationInView:self.view] ;
        
        if(self.oneView.OneScrollV.contentOffset.y!=0){
            self.detailView.transform = CGAffineTransformTranslate(self.detailView.transform, 0, 0) ;
            
        }
        if(self.oneView.OneScrollV.contentOffset.y!=0){
            self.detailView.transform = CGAffineTransformTranslate(self.detailView.transform, 0, 0) ;
            
        }
        
        if (self.detailView.frame.origin.y <Y5) {
            self.detailView.transform = CGAffineTransformTranslate(self.detailView.transform, 0, 0) ;
        }else
        {
            if(point.y<0&&self.detailView.frame.origin.y==Y5){
                self.detailView.transform = CGAffineTransformTranslate(self.detailView.transform, 0, 0) ;
            } else if (self.detailView.frame.origin.y >SCREEN_HEIGHT-100) {
                self.detailView.transform = CGAffineTransformTranslate(self.detailView.transform, 0, 0) ;
            }
            
            else{
                self.detailView.transform = CGAffineTransformTranslate(self.detailView.transform, 0, point.y) ;
                if(self.MyLocationBtn.origin.y>=200){
                    self.MyLocationBtn.transform=CGAffineTransformTranslate(self.MyLocationBtn.transform, 0, point.y) ;
                }
            }
        }
        
        
        NSLog(@"----- y = %f ------", (self.detailView.frame.origin.y));
        //每次移动完成之后需要将偏移量清零（如果不清零，偏移量是叠加的）
        [pan setTranslation:CGPointZero inView:self.view] ;
        if(point.y<0){
            self.UpOrDown=1;//向上
        }
        if(point.y>0){
            self.UpOrDown=2;//向下
        }
        //        if(self.oneView.PhotosView.isScrollStoped==0){
        //            self.UpOrDown=1;
        //        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        float currentY = self.detailView.frame.origin.y;
        
        float stopY = 0;
        
        if (self.UpOrDown==1) {
            
            // 停在y5的位置
            stopY = Y5;
            self.oneView.OneScrollV.scrollEnabled=YES;
            
            
            
        }
        else if (currentY <= Y2 && currentY > Y5&&self.UpOrDown==2)
        {
            // 停在y2的位置
            stopY = Y2;
            self.oneView.OneScrollV.scrollEnabled=YES;
            
        }
        else
        {
            // 停在y7的位置
            stopY = Y7;
            self.oneView.OneScrollV.scrollEnabled=YES;
            
        }
        kWeakSelf;
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.detailView.frame = CGRectMake(0, stopY, weakSelf.view.frame.size.width,SCREEN_HEIGHT-40);
            if (stopY<200){
                weakSelf.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,200, 56, 56);
            }else{
                weakSelf.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,stopY-60, 56, 56);
                
            }
            
        } completion:^(BOOL finished) {
            
            
        }];
        
        
    }
}


#pragma mark-------懒加载页面


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
