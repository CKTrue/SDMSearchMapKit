//
//  SDMMapSearchResultViewController.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import "SDMMapSearchResultViewController.h"
#import "SearchResultCell.h"
#import "SearchResultModel.h"
#import "SearchResultVC.h"
#import "SDMSearchResultListVC.h"
#import "SDMMapSearchDetailViewController.h"
@interface SDMMapSearchResultViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@end

@implementation SDMMapSearchResultViewController
-(void)viewWillAppear:(BOOL)animated{
    kWeakSelf;
    if (self.resultVC.sourceArray.count>0) {
  
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.shadowView.frame=CGRectMake(0, Y1+10, SCREEN_WIDTH, SCREEN_HEIGHT-40);
    }];
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchView.SearchTF.text=self.SearchStr;

    self.landView.hidden=YES;
   [self ShowSearchResultByKeyWordsByModel:self.ResultModel];
    
    self.searchView.ShowMapViewControllerBtn.hidden=NO;
   
   [self.searchView.ShowMapViewControllerBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];

    [self.searchView.backBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"left_arrow"] forState:UIControlStateNormal];

    if (self.searchView.SearchTF.text.length==0){
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"mic"] forState:UIControlStateNormal];

    }else{
        [self.searchView.checkPasswordBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"close"] forState:UIControlStateNormal];

      }
    [self.searchView.checkPasswordBtn addTarget:self action:@selector(clearSearchTF) forControlEvents:UIControlEventTouchUpInside];

    
    UIPanGestureRecognizer*pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate=self;
    self.resultVC.CellResult=self.CellResult;
    [self.resultVC.SearchTabV addGestureRecognizer:pan];
    
    [self.searchView.backBtn addTarget:self action:@selector(PopController) forControlEvents:UIControlEventTouchUpInside];

}
-(void)PopController{
    if (self.CellResult==YES) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];

    }
}
-(void)clickBtn{
    [USER_DEFAULT setBool:YES forKey:@"editSearchTF"];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)clearSearchTF{
    if ([self.searchView.checkPasswordBtn.currentImage isEqual:[[ToolManager shareManager] creatZhujianImgView:@"close"]]) {
        [USER_DEFAULT setBool:YES forKey:@"clearSearchTF"];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
#pragma mark--------ShowSearchResultByKeyWords
-(void)ShowSearchResultByKeyWordsByModel:(SearchResultModel*)model{

    kWeakSelf;
    if([model.local_provider_enum intValue]==2||[model.local_provider_enum intValue]==6){

    
    [self.resultVC setResultModel:model WithSearchStr:self.searchView.SearchTF.text AndMapScale:0];
        self.resultVC.block = ^(SearchResultModel * _Nonnull model) {
            [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.shadowView.frame=CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-40);
            } completion:^(BOOL finished) {
                SDMMapSearchDetailViewController*vc=[[SDMMapSearchDetailViewController alloc]init];
                vc.DetailModel=model;
                vc.SearchStr=weakSelf.SearchStr;
                vc.hidesBottomBarWhenPushed=YES;

                [weakSelf.navigationController pushViewController:vc animated:NO];
            }];
           
        };
        
    self.resultVC.markerBlock = ^(NSMutableArray * _Nonnull Array) {
       //  [weakSelf.marker.map clear];
        //  weakSelf.marker.map=nil;
        
        
        for(SearchResultModel*model in Array){
            CLLocationCoordinate2D coor=CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
            
         //   weakSelf.marker = [GMSMarker markerWithPosition:coor];
          //  weakSelf.marker.map = weakSelf.mapView;
            
            if([model.local_provider_enum intValue]==2){
            //    weakSelf.marker.icon=[UIImage imageNamed:@"markericon"];
            }else{
            //    weakSelf.marker.icon=[UIImage imageNamed:@"graymarkericon"];

            }

            [weakSelf GetAllMarkerInScreen];

        }
        [weakSelf.shadowView addSubview:weakSelf.resultVC.view];
        [weakSelf.view addSubview:weakSelf.shadowView];
        weakSelf.resultVC.view.frame=weakSelf.shadowView.bounds;
        [UIView animateWithDuration:0.2 animations:^{
          
            weakSelf.resultVC.SearchTabV.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-Y1-10-TabBarHeight);

        }];
        weakSelf.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,Y2-60, 56, 56);

    };
    }else{
        SDMSearchResultListVC*searchlistVC=[[SDMSearchResultListVC alloc]initWithNibName:@"SDMSearchResultListVC" bundle:[[ToolManager shareManager] subBundleWithBundleName]];
        searchlistVC.hidesBottomBarWhenPushed=YES;
        [searchlistVC setResultModel:model WithSearchStr:self.searchView.SearchTF.text AndMapScale:0];//0:加载地图时等于地图缩放比例
        [self.navigationController pushViewController:searchlistVC animated:NO];


    }
   
}


//拖拽手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
 
        if (self.resultVC.SearchTabV.scrollEnabled == YES) {

            return YES;
        
    }
return NO;

}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged){
    
    //返回的是相对于self.view的偏移量
    CGPoint point = [pan translationInView:self.view] ;
    NSLog(@"%f",self.resultVC.SearchTabV.contentOffset.y);
        if(self.shadowView.frame.origin.y!=Y1+10){
            self.resultVC.SearchTabV.scrollEnabled=NO;
        }else{
            self.resultVC.SearchTabV.scrollEnabled=YES;

        }
   
    if (self.shadowView.frame.origin.y <= Y1+10) {
        self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, 0) ;
    }else{
        if(point.y>0&&self.resultVC.SearchTabV.contentOffset.y>0){
            self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, 0) ;

        }else{
    self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, point.y) ;
            if(self.MyLocationBtn.origin.y>200){
        self.MyLocationBtn.transform=CGAffineTransformTranslate(self.MyLocationBtn.transform, 0, point.y) ;
            }
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
        float currentY = self.shadowView.frame.origin.y;
        
        float stopY = 0;
        
        if ( currentY < Y2&&self.UpOrDown==1) {
            
            // 停在y1的位置
            stopY = Y1+10;
            self.resultVC.SearchTabV.scrollEnabled=YES;

            
        } else if (self.UpOrDown==2&&self.resultVC.SearchTabV.contentOffset.y!=0) {
            
            // 停在y1的位置
            stopY = Y1+10;
            self.resultVC.SearchTabV.scrollEnabled=YES;

            
        }
        else{
            // 停在y2的位置
            stopY = Y2;
            self.resultVC.SearchTabV.scrollEnabled=NO;
        }
        kWeakSelf;
//        NSLog(@"     %f        ", stopY);
        [UIView animateWithDuration:0.4 animations:^{
            
            weakSelf.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width,SCREEN_HEIGHT-Y1-10);
            weakSelf.MyLocationBtn.frame=CGRectMake(SCREEN_WIDTH-66,Y2-60, 56, 56);

            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
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
