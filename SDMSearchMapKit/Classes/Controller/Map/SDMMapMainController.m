//
//  SDMMapMainController.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/20.
//

#import "SDMMapMainController.h"
#import "SearchView.h"
#import "SDMMapHistoryViewController.h"
#import "SDMChooseKindView.h"
#import "FavoriteListModel.h"
#import "SDMMapSearchResultViewController.h"
#import "SearchResultModel.h"
@interface SDMMapMainController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,SDMLandingViewDelegate>
@property(nonatomic,strong)SDMChooseKindView*chooseKindView;

@end

@implementation SDMMapMainController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.searchView.SearchTF endEditing:YES];
    self.searchView.SearchTF.text=@"";

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.searchView.ShowMapViewControllerBtn.hidden=NO;
    [self.searchView.ShowMapViewControllerBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    self.landView.deleagte=self;
    [self.view addSubview:self.LandgingScreenView];
    self.chooseKindView=(SDMChooseKindView*)[[ToolManager shareManager] creatAllreadAlterView:@"SDMChooseKindView"];
    self.chooseKindView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.LandgingScreenView addSubview:self.chooseKindView];
    self.chooseKindView.backgroundColor=[UIColor whiteColor];
    //self.chooseKindView.ScrollView.scrollEnabled=NO;
    UIPanGestureRecognizer*pan1= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pandetail:)];
        pan1.delegate = self;
    [self.chooseKindView addGestureRecognizer:pan1];
    self.chooseKindView.ChooseOneKindView.BgscrollV.delegate=self;
    
    self.chooseKindView.ChooseOneKindView.DataArray=[[NSMutableArray alloc]initWithArray: @[@"latest1",@"latest2",@"latest3",@"latest4",@"latest5"]];
    self.chooseKindView.ChooseTwoKindView.DataArray=[[NSMutableArray alloc]initWithArray: @[@"Rectangle1",@"Rectangle2",@"Rectangle5"]];
    self.chooseKindView.ChooseThreeKindView.DataArray=[[NSMutableArray alloc]initWithArray: @[@"Rectangle3",@"Rectangle4",@"Rectangle6"]];


}

#pragma mark------LandViewDelegate
-(void)ClickCoffeeView:(SDMLandingView *)landingView{

    SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
    vc.SearchStr=@"Coffee";
    SearchResultModel*model=[[SearchResultModel alloc]init];
    model.local_provider_enum=@"6";
    vc.ResultModel=model;
    self.searchView.SearchTF.text=@"Coffee";
    [self.navigationController pushViewController:vc animated:NO];
    
}
-(void)ClickRestaurantsView:(SDMLandingView *)landingView{
    SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
    vc.SearchStr=@"restaurant";
    self.searchView.SearchTF.text=@"restaurant";

    SearchResultModel*model=[[SearchResultModel alloc]init];

    model.local_provider_enum=@"6";
    vc.ResultModel=model;
    [self.navigationController pushViewController:vc animated:NO];
    
}
-(void)ClickGasView:(SDMLandingView *)landingView{
    SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
    vc.SearchStr=@"gas";
    SearchResultModel*model=[[SearchResultModel alloc]init];
    self.searchView.SearchTF.text=@"gas";

    model.local_provider_enum=@"6";
    vc.ResultModel=model;
    [self.navigationController pushViewController:vc animated:NO];
    
}
-(void)ClickGroceriesView:(SDMLandingView *)landingView{
    SDMMapSearchResultViewController*vc=[[SDMMapSearchResultViewController alloc]init];
    vc.SearchStr=@"groceries";
    SearchResultModel*model=[[SearchResultModel alloc]init];
    self.searchView.SearchTF.text=@"groceries";

    model.local_provider_enum=@"6";
    vc.ResultModel=model;
    [self.navigationController pushViewController:vc animated:NO];
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([[otherGestureRecognizer view] isKindOfClass:[SDMCKScrollView class]]) {

        return NO;

    }
    
        if (self.chooseKindView.ScrollView.scrollEnabled == YES) {
            if (self.chooseKindView.ScrollView.contentOffset.y==0&&self.UpOrDown==2) {

                self.chooseKindView.ScrollView.scrollEnabled=NO;
            }

            return YES;
        
        }
    
return NO;

}
//拖拽手势
- (void)pandetail:(UIPanGestureRecognizer *)pan
{
    
   // if (self.chooseKindView.ChooseOneKindView.BgscrollV.isScrollStoped==1&&self.chooseKindView.ChooseOneKindView.BgscrollV.isScrollStoped==1) {
   
    if (pan.state == UIGestureRecognizerStateChanged){
    
        if(self.LandgingScreenView.frame.origin.y!=Y5){
            self.chooseKindView.ScrollView.scrollEnabled=NO;
        }else{
            self.chooseKindView.ScrollView.scrollEnabled=YES;
        }
        
    //返回的是相对于self.view的偏移量
    CGPoint point = [pan translationInView:self.view] ;
        
        if(self.chooseKindView.ScrollView.contentOffset.y!=0){
            self.LandgingScreenView.transform = CGAffineTransformTranslate(self.LandgingScreenView.transform, 0, 0) ;

        }
        if(self.chooseKindView.ScrollView.contentOffset.y!=0){
            self.LandgingScreenView.transform = CGAffineTransformTranslate(self.LandgingScreenView.transform, 0, 0) ;

        }
       
        if (self.LandgingScreenView.frame.origin.y <Y5) {
            self.LandgingScreenView.transform = CGAffineTransformTranslate(self.LandgingScreenView.transform, 0, 0) ;
        }else
        {
            if(point.y<0&&self.LandgingScreenView.frame.origin.y==Y5){
                self.LandgingScreenView.transform = CGAffineTransformTranslate(self.LandgingScreenView.transform, 0, 0) ;
            } else if (self.LandgingScreenView.frame.origin.y >SCREEN_HEIGHT-100) {
                self.LandgingScreenView.transform = CGAffineTransformTranslate(self.LandgingScreenView.transform, 0, 0) ;
            }
//
            else if (self.chooseKindView.ScrollView.contentOffset.y!=0) {
                self.LandgingScreenView.transform = CGAffineTransformTranslate(self.LandgingScreenView.transform, 0, 0) ;
            }
            else{
            self.LandgingScreenView.transform = CGAffineTransformTranslate(self.LandgingScreenView.transform, 0, point.y) ;
            }
        }
  

    NSLog(@"----- y = %f ------", (self.LandgingScreenView.frame.origin.y));
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
        float currentY = self.LandgingScreenView.frame.origin.y;
        
        float stopY = 0;
        
        if (self.UpOrDown==1) {
            
            // 停在y5的位置
            stopY = Y5;
            self.chooseKindView.ScrollView.scrollEnabled=YES;


            
        }else if (self.UpOrDown==2&&self.chooseKindView.ScrollView.contentOffset.y!=0) {
            
            // 停在y1的位置
            stopY = Y5;
            self.chooseKindView.ScrollView.scrollEnabled=YES;

            
        }
        else if (currentY <= Y2 && currentY > Y5)
        {
            // 停在y2的位置
            stopY = Y2;
            self.chooseKindView.ScrollView.scrollEnabled=YES;

        }else
        {
            // 停在y3的位置
            stopY = Y7;
            self.chooseKindView.ScrollView.scrollEnabled=YES;

        }
        kWeakSelf;
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.LandgingScreenView.frame = CGRectMake(0, stopY, self.view.frame.size.width,SCREEN_HEIGHT-40);
            
        } completion:^(BOOL finished) {

            
        }];
        
        
    }
    //}
}

-(void)clickBtn{
    self.searchView.SearchTF.text=@"";
    SDMMapHistoryViewController*vc=[[SDMMapHistoryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
     
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
