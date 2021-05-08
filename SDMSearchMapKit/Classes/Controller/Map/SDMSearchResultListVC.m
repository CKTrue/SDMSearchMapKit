//
//  SearchResultListVC.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import "SDMSearchResultListVC.h"
#import "SearchResultModel.h"
#import "SearchResultCell.h"
#import "HistoryModel.h"
@interface SDMSearchResultListVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
{
  
    NSString*token;
    int scale;
}

@property (weak, nonatomic) IBOutlet BaseTableView *SearchListTableV;
@property(nonatomic,strong)NSMutableArray*sourceArray;
@property(nonatomic,copy)NSString*searchString;
@property (nonatomic, assign) NSInteger PageNum;
@property(nonatomic,strong)SearchResultModel*resultListModel;

@end

@implementation SDMSearchResultListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text=@"Search Results";
    [self.SearchListTableV registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"SearchResultCell"];
    self.SearchListTableV.delegate=self;
    self.SearchListTableV.dataSource=self;
    self.SearchListTableV.refreshDelegate=self;
    self.SearchListTableV.refreshStyle=RefreshStyleOnlyLoad;
    self.SearchListTableV.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.SearchListTableV.separatorColor=[UIColor whiteColor];
    self.sourceArray=[[NSMutableArray alloc]init];
    self.PageNum=0;
}
-(void)setResultModel:(SearchResultModel *)resultModel WithSearchStr:(NSString*)str AndMapScale:(int)mapscale{
    _resultListModel=resultModel;
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
    [cell setModel:self.sourceArray[indexPath.row]];
    if(indexPath.row==self.sourceArray.count-1){
        cell.LineLabel.hidden=YES;
    }else{
        cell.LineLabel.hidden=NO;
    }
    cell.KindTypeView.hidden=YES;
    cell.OtherTopViewHeight.constant=0;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResultModel*indexmodel=self.sourceArray[indexPath.row];
            if([indexmodel.local_provider_enum intValue]==3||[indexmodel.local_provider_enum intValue]==1||[indexmodel.local_provider_enum intValue]==5||[indexmodel.local_provider_enum intValue]==7){
                
                [[SearchResultViewModel defaultModel] requestSearchResultDetailSuccess:indexmodel.custom_id local_provider_num:indexmodel.local_provider_enum succeed:^(id  _Nonnull data) {

                    SearchResultModel*model=[SearchResultModel mj_objectWithKeyValues:data[@"data"]];
                 
                    
                    CustomWebView*vc=[[CustomWebView alloc]init];
                    vc.titleStr=model.title;
                    vc.urlString=model.link;
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

                    [self.navigationController pushViewController:vc animated:NO];
                    
                  
                    
                } fail:^(NSError * _Nonnull error) {
                    
                }];
                
                
              
            }
        if([indexmodel.local_provider_enum intValue]==4){
            [JumpVC JumpViewControllerWithGetModel:indexmodel TitleName:indexmodel.title WithViewController:self.navigationController];
          }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark-------request请求
-(void)goRequestWithIsRefresh:(BOOL)isRefresh{
    if(isRefresh){
        self.PageNum=0;
        [self ResultListRequest:self.resultListModel WithSearchStr:self.searchString AndMapScale:scale];

    }else{
        [self ResultListRequest:self.resultListModel WithSearchStr:self.searchString AndMapScale:scale];

    }

}
-(void)ResultListRequest:(SearchResultModel*)model  WithSearchStr:(NSString*)str AndMapScale:(int)mapscale{
    kWeakSelf;
    scale=mapscale;

    NSString* lat=[NSString stringWithFormat:@"%@",DEF_PERSISTENT_GET_OBJECT(@"userLat")];
    NSString* lng=[NSString stringWithFormat:@"%@",DEF_PERSISTENT_GET_OBJECT(@"userLng")];
    
    NSString*provier;
    
    //1:Junction 2:Dealer 3:OwnerManual 4:Native 5:Video 6:Gis
    if([model.local_provider_enum intValue]==1){
        provier=@"JUNCTION";
    }
    if([model.local_provider_enum intValue]==2){
        provier=@"DEALER";

    }
    if([model.local_provider_enum intValue]==3){
        provier=@"OWNER_MANUAL";

    }
    if([model.local_provider_enum intValue]==4){
        provier=@"NATIVE";

    }
    if([model.local_provider_enum intValue]==5){
        provier=@"VIDEO";

    }
   
    if([model.local_provider_enum intValue]==7){
        provier=@"EVENT";

    }
   
    if (self.PageNum==0) {

        [[SearchResultViewModel defaultModel] requestSearchResultSuccess:str MapSearchRadius:[[ToolManager shareManager] GetDistanceByMapScale:mapscale] Lat:lat Lng:lng PageNum:self.PageNum Provider:provier token:@"" succeed:^(id  _Nonnull data) {


            weakSelf.sourceArray=[[NSMutableArray alloc]init];
            weakSelf.sourceArray=[SearchResultModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"items"]];
            if(weakSelf.sourceArray.count>0){
                self->token=[NSString stringWithFormat:@"%@",data[@"data"][@"next_page_token"]];
            //1代表最后一页
            NSInteger currentPage=[data[@"data"][@"last"] integerValue];
               
            if(currentPage!=1){
                weakSelf.PageNum=1;
                [weakSelf.SearchListTableV.mj_footer endRefreshing];

            }else{
                [weakSelf.SearchListTableV.mj_footer endRefreshingWithNoMoreData];

            }
            
           
           
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.SearchListTableV reloadData];

            });

            
                } fail:^(NSError * _Nonnull error) {

                }];


    }else{

        [[SearchResultViewModel defaultModel] requestSearchResultSuccess:str MapSearchRadius:[[ToolManager shareManager] GetDistanceByMapScale:mapscale] Lat:lat Lng:lng PageNum:self.PageNum Provider:provier token:token succeed:^(id  _Nonnull data) {
              
            NSArray*array=[SearchResultModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"items"]];
                [self.sourceArray addObjectsFromArray:array];
                self->token=[NSString stringWithFormat:@"%@",data[@"data"][@"next_page_token"]];
                //1代表最后一页
                NSInteger currentPage=[data[@"data"][@"last"] integerValue];
                 
                if(currentPage!=1){
                    weakSelf.PageNum++;
                    [weakSelf.SearchListTableV.mj_footer endRefreshing];

                }else{
                    [weakSelf.SearchListTableV.mj_footer endRefreshingWithNoMoreData];

                }
                
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.SearchListTableV reloadData];

                });

                
                    } fail:^(NSError * _Nonnull error) {

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
