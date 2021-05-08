//
//  SDMFaVoriteAndHistoryViewController.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/22.
//

#import "SDMFaVoriteAndHistoryViewController.h"
#import "SDMFavoriteViewController.h"
#import "SDMHistoryViewController.h"
#import "FavoritesView.h"
@interface SDMFaVoriteAndHistoryViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    NSInteger IsScroll;
}
@property(nonatomic,strong)SDMFavoriteViewController*FavoriteVC;
@property(nonatomic,strong)SDMHistoryViewController*HistoryVC;

@property(nonatomic,strong)BaseTableView*ResultTabV;

@end

@implementation SDMFaVoriteAndHistoryViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchView.hidden=YES;
    self.landView.hidden=YES;
    if(self.GotoFavorite==YES){
    self.FavoriteVC=[[SDMFavoriteViewController alloc]initWithNibName:@"SDMFavoriteViewController" bundle:[[ToolManager shareManager] subBundleWithBundleName]];
        
    [self addChildViewController:self.FavoriteVC];
    self.FavoriteVC.view.frame=self.shadowView.bounds;
    [self.shadowView addSubview:self.FavoriteVC.view];
    [self.view addSubview:self.shadowView];
    self.ResultTabV=self.FavoriteVC.MyFavoriteTableV;
        UIPanGestureRecognizer*pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTop:)];
        pan.delegate=self;
        [self.FavoriteVC.favoriteTopView addGestureRecognizer:pan];
    }else{
        
        self.HistoryVC=[[SDMHistoryViewController alloc]initWithNibName:@"SDMHistoryViewController" bundle:[[ToolManager shareManager] subBundleWithBundleName]];
        [self addChildViewController:self.HistoryVC];
        self.HistoryVC.view.frame=self.shadowView.bounds;
        [self.shadowView addSubview:self.HistoryVC.view];
        [self.view addSubview:self.shadowView];
        self.ResultTabV=self.HistoryVC.SDMHistoryTabV;
        UIPanGestureRecognizer*pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTop:)];
        pan.delegate=self;
        [self.HistoryVC.historyTopView addGestureRecognizer:pan];
    }
    self.shadowView.frame = CGRectMake(0, Y5, self.view.frame.size.width,SCREEN_HEIGHT-Y5);
    UIPanGestureRecognizer*pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate=self;
    IsScroll=NO;
    self.ResultTabV.scrollEnabled=NO;
    [self.ResultTabV addGestureRecognizer:pan];
    
    self.UpOrDown=0;
}

//拖拽手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
 
    
    DSLog(@"--------------%@========%@",gestureRecognizer,otherGestureRecognizer);
    
    
   
    if ([[otherGestureRecognizer view] isMemberOfClass:[UIScrollView class]]) {

        return NO;

    }
    if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
        if (self.ResultTabV.scrollEnabled == YES) {

            return YES;
           }
          return NO;

}


- (void)pan:(UIPanGestureRecognizer *)pan
{
    

    if (pan.state == UIGestureRecognizerStateChanged){
    
    //返回的是相对于self.view的偏移量
    CGPoint point = [pan translationInView:self.view] ;
       // NSLog(@"----- x = %f ------", point.x);

        if(self.shadowView.frame.origin.y!=Y5){
            self.ResultTabV.scrollEnabled=NO;
        }else{
            self.ResultTabV.scrollEnabled=YES;

        }
   
    if (self.shadowView.frame.origin.y <= Y5) {
        self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, 0) ;
    }else{
        if(point.y>0&&self.ResultTabV.contentOffset.y>0){
            self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, 0) ;

        }else{
            
            if (self.ResultTabV.editing==YES) {
                self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, 0);

            }else{
                self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, point.y);
            }
            }
            
        }
    
        
        
   // }

    //NSLog(@"----- y = %f ------", self.shadowView.frame.origin.x);
     //每次移动完成之后需要将偏移量清零（如果不清零，偏移量是叠加的）
    [pan setTranslation:CGPointZero inView:self.view] ;
        if(point.y<0){
            self.UpOrDown=1;//向上
        }
        if(point.y>0){
            self.UpOrDown=2;//向下
        }
        if (self.ResultTabV.editing==YES) {
            self.UpOrDown=0;
        }
       
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {

        float currentY = self.shadowView.frame.origin.y;
        
        float stopY = 0;
        
        if ( currentY < Y2&&self.UpOrDown==1) {
            
            // 停在y5的位置
            stopY = Y5;
            self.ResultTabV.scrollEnabled=YES;

            
        } else if (self.UpOrDown==2&&self.ResultTabV.contentOffset.y!=0) {
            
            // 停在y5的位置
            stopY = Y5;
            self.ResultTabV.scrollEnabled=YES;

            
        }
        else{
            if (self.UpOrDown==0){
                stopY=currentY;
            
               }else{
            // 停在y2的位置
              stopY = Y2;
              }
            self.ResultTabV.scrollEnabled=NO;
        }
        kWeakSelf;
//        NSLog(@"     %f        ", stopY);
        [UIView animateWithDuration:0.4 animations:^{
            
            weakSelf.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width,SCREEN_HEIGHT-Y5);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
}

- (void)panTop:(UIPanGestureRecognizer *)pan
{
   
    if (pan.state == UIGestureRecognizerStateChanged){
    
    //返回的是相对于self.view的偏移量
    CGPoint point = [pan translationInView:self.view] ;
       // NSLog(@"----- x = %f ------", point.x);

        if(self.shadowView.frame.origin.y!=Y5){
            self.ResultTabV.scrollEnabled=NO;
        }else{
            self.ResultTabV.scrollEnabled=YES;

        }
   
    if (self.shadowView.frame.origin.y <= Y5) {
        self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, 0) ;
    }else{

    self.shadowView.transform = CGAffineTransformTranslate(self.shadowView.transform, 0, point.y);
        
    }
        

    //NSLog(@"----- y = %f ------", self.shadowView.frame.origin.x);
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
            stopY = Y5;
            self.ResultTabV.scrollEnabled=YES;


            
        } else if (self.UpOrDown==2&&self.ResultTabV.contentOffset.y!=0) {
            
            // 停在y2的位置
            stopY = Y5;
            self.ResultTabV.scrollEnabled=YES;

            
        }
        else{
            if (self.UpOrDown==0){
                stopY=currentY;
            
               }else{
            // 停在y2的位置
              stopY = Y2;
              }
            self.ResultTabV.scrollEnabled=NO;
        }
        kWeakSelf;
//        NSLog(@"     %f        ", stopY);
        [UIView animateWithDuration:0.4 animations:^{
            
            weakSelf.shadowView.frame = CGRectMake(0, stopY, self.view.frame.size.width,SCREEN_HEIGHT-Y5);
            
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
