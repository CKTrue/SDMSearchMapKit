//
//  SearchResultVC.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/25.
//

#import "SearchResultVC.h"
#import "SearchResultCell.h"
#import "SearchResultModel.h"
#import "SearchTopView.h"
#import "SearchResultViewModel.h"
@interface SearchResultVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
{
  
    NSString*token;
    int scale;
}

@property(nonatomic,strong)SearchTopView*TopView;
@property(nonatomic,copy)NSString*searchString;
@property(nonatomic,strong)SearchResultViewModel*searchResultViewModel;

@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.PageNum=0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 10;
    self.searchResultViewModel=[[SearchResultViewModel alloc]init];
}

#pragma mark-----懒加载tableview
-(BaseTableView*)SearchTabV{
    if (!_SearchTabV) {
        _SearchTabV=[[BaseTableView alloc]init];
        _SearchTabV.frame=CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-104-TabBarHeight);
        [self.view addSubview:_SearchTabV];
        _SearchTabV.separatorColor=[UIColor clearColor];
        [_SearchTabV registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchResultCell"];
        _SearchTabV.scrollEnabled=NO;
        _SearchTabV.userInteractionEnabled=YES;
        _SearchTabV.separatorStyle=UITableViewCellSeparatorStyleNone;
        _SearchTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _SearchTabV.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _SearchTabV.dataSource=self;
        _SearchTabV.delegate=self;
        
        _SearchTabV.refreshDelegate=self;
        _SearchTabV.refreshStyle=RefreshStyleOnlyLoad;
    }
    
    return _SearchTabV;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _SearchTabV) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}
-(void)setResultModel:(SearchResultModel *)resultModel WithSearchStr:(NSString*)str AndMapScale:(int)mapscale{
    _resultModel=resultModel;
    self.PageNum=0;
    self.searchString=str;
    [self ResultListRequest:resultModel WithSearchStr:self.searchString AndMapScale:mapscale];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultCell*cell=[tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    SearchResultModel*model=self.sourceArray[indexPath.row];
    [cell setModel:self.sourceArray[indexPath.row]];
    if(indexPath.row==self.sourceArray.count-1){
        cell.LineLabel.hidden=YES;
    }else{
        cell.LineLabel.hidden=NO;
    }
    cell.KindTypeView.hidden=YES;
    cell.OtherTopViewHeight.constant=0;
    if ([model.local_provider_enum intValue]==2||[model.local_provider_enum intValue]==6) {
        cell.DateLabel.hidden=NO;
        cell.DateWidth.constant=80;
    }else{
        cell.DateLabel.hidden=YES;
        cell.DateWidth.constant=0;
    }
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultModel*model=self.sourceArray[indexPath.row];
     
    if (self.block) {
        self.block(model);
    }
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}
#pragma mark-------request请求
-(void)goRequestWithIsRefresh:(BOOL)isRefresh{
    if(isRefresh){
        self.PageNum=0;
        [self ResultListRequest:self.resultModel WithSearchStr:self.searchString AndMapScale:scale];

    }else{
        [self ResultListRequest:self.resultModel WithSearchStr:self.searchString AndMapScale:scale];

    }

}
-(void)ResultListRequest:(SearchResultModel*)model  WithSearchStr:(NSString*)str AndMapScale:(int)mapscale{
    scale=mapscale;

    NSString*lat;
    NSString*lng;
    if (self.CellResult==YES) {
     
        lat=model.latitude;
        lng=model.longitude;
    }else{
      
        lat=[NSString stringWithFormat:@"%@",DEF_PERSISTENT_GET_OBJECT(@"userLat")];
        lng=[NSString stringWithFormat:@"%@",DEF_PERSISTENT_GET_OBJECT(@"userLng")];;
    }
    NSString*provier;
    //1:Junction 2:Dealer 3:OwnerManual 4:Native 5:Video 6:Gis
   
    if([model.local_provider_enum intValue]==2){
        provier=@"DEALER";
    }
  
    if([model.local_provider_enum intValue]==6){
        provier=@"GIS";

        self.TopView.TotalLabel.hidden=YES;
    }

    kWeakSelf;

    if (self.PageNum==0) {

        [[SearchResultViewModel defaultModel] requestSearchResultSuccess:str MapSearchRadius:[[ToolManager shareManager] GetDistanceByMapScale:mapscale] Lat:lat Lng:lng PageNum:self.PageNum Provider:provier token:@"" succeed:^(id  _Nonnull data) {

            weakSelf.sourceArray=[[NSMutableArray alloc]init];
            weakSelf.sourceArray=[SearchResultModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"items"]];
            if(weakSelf.sourceArray.count>0){
                self->token=[NSString stringWithFormat:@"%@",data[@"data"][@"next_page_token"]];
            //1代表最后一页
            NSInteger currentPage=[data[@"data"][@"last"] integerValue];
                if(weakSelf.markerBlock){
                    weakSelf.markerBlock(self.sourceArray);
                }
            if(currentPage!=1){
                weakSelf.PageNum=1;
                [weakSelf.SearchTabV.mj_footer endRefreshing];

            }else{
                [weakSelf.SearchTabV.mj_footer endRefreshingWithNoMoreData];

            }
            
            self.TopView.TotalLabel.text=[NSString stringWithFormat:@"%@ total",data[@"data"][@"total_size"]];
           
           
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.SearchTabV reloadData];

            });

            
                } fail:^(NSError * _Nonnull error) {

                }];


    }else{

        [self.searchResultViewModel requestSearchResultSuccess:str MapSearchRadius:[[ToolManager shareManager] GetDistanceByMapScale:mapscale] Lat:lat Lng:lng PageNum:self.PageNum Provider:provier token:token succeed:^(id  _Nonnull data) {

                NSArray*array=[SearchResultModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"items"]];
                [self.sourceArray addObjectsFromArray:array];
                self->token=[NSString stringWithFormat:@"%@",data[@"data"][@"next_page_token"]];
                //1代表最后一页
                NSInteger currentPage=[data[@"data"][@"last"] integerValue];
                    if(weakSelf.markerBlock){
                        weakSelf.markerBlock(self.sourceArray);
                    }
                if(currentPage!=1){
                    weakSelf.PageNum++;
                    [weakSelf.SearchTabV.mj_footer endRefreshing];

                }else{
                    [weakSelf.SearchTabV.mj_footer endRefreshingWithNoMoreData];

                }
                
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.SearchTabV reloadData];

                });

                
                    } fail:^(NSError * _Nonnull error) {

                    }];

    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
    self.TopView=[[[NSBundle mainBundle]loadNibNamed:@"SearchTopView" owner:self options:nil]lastObject];
    self.TopView.backgroundColor=[UIColor whiteColor];
    self.TopView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 118);
    return self.TopView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 118;
    
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
