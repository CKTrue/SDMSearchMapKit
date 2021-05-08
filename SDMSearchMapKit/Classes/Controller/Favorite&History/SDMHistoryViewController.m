//
//  SDMHistoryViewController.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/2.
//

#import "SDMHistoryViewController.h"
#import "SearchResultCell.h"
#import "HistoryModel.h"
#import "SearchResultModel.h"
#import "SDMMapSearchDetailViewController.h"
@interface SDMHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
{
    NSString*token;
    NSInteger LastIndex;

}
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,assign)NSInteger pageNum;
- (IBAction)ClickClearAll:(id)sender;
- (IBAction)GotoBack:(id)sender;

@end

@implementation SDMHistoryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
 
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text=@"Histories";
    self.pageNum=0;
    [self.SDMHistoryTabV registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"SearchResultCell"];
    self.SDMHistoryTabV.delegate=self;
    self.SDMHistoryTabV.refreshStyle=RefreshStyleOnlyLoad;
    self.SDMHistoryTabV.refreshDelegate=self;
    self.SDMHistoryTabV.dataSource=self;
    self.SDMHistoryTabV.scrollEnabled=NO;
    self.SDMHistoryTabV.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.SDMHistoryTabV.separatorColor=[UIColor whiteColor];
    self.dataArray=[[NSMutableArray alloc]init];
    kWeakSelf;

    [[SearchResultViewModel defaultModel] requestGetHistory:self.pageNum Pagesize:10 succeed:^(id  _Nonnull data) {
           
        weakSelf.dataArray=[HistoryModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
        self->token=[NSString stringWithFormat:@"%@",data[@"data"][@"next_page_token"]];
        //1代表最后一页
        NSInteger currentPage=[data[@"data"][@"last"] integerValue];

        if(currentPage!=1){
            weakSelf.pageNum=1;
            [weakSelf.SDMHistoryTabV.mj_footer endRefreshing];

        }else{
          
            [weakSelf.SDMHistoryTabV.mj_footer endRefreshingWithNoMoreData];

        }
        if (weakSelf.dataArray.count==0) {
            [weakSelf.SDMHistoryTabV addSubview:self.SDMHistoryTabV.TabcontenView];
            weakSelf.SDMHistoryTabV.DescLabel.text=@"No Recent Searches";

        }else{
            [weakSelf.SDMHistoryTabV.TabcontenView removeFromSuperview];
        }
        
        [[ToolManager shareManager] SaveDataWithUserDefalutKey:HistoryData ArchiverDataObject:weakSelf.dataArray];

        [weakSelf.SDMHistoryTabV reloadData];
        
        
        } fail:^(NSError * _Nonnull error) {
            
        }];

  
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.SDMHistoryTabV) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}

#pragma mark--------数据请求
-(void)goRequestWithIsRefresh:(BOOL)isRefresh{
    kWeakSelf;
    if(isRefresh){
       
    }else{
       
        [[SearchResultViewModel defaultModel] requestGetHistory:self.pageNum Pagesize:10 succeed:^(id  _Nonnull data) {
               
            NSArray*array=[HistoryModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.dataArray addObjectsFromArray:array];
            //1代表最后一页
            NSInteger currentPage=[data[@"data"][@"last"] integerValue];
              
            if(currentPage!=1){
                weakSelf.pageNum++;
                [weakSelf.SDMHistoryTabV.mj_footer endRefreshing];

            }else{
                [weakSelf.SDMHistoryTabV.mj_footer endRefreshingWithNoMoreData];

            }

            
            [weakSelf.SDMHistoryTabV reloadData];


            
            } fail:^(NSError * _Nonnull error) {
                
            }];
    }

}
   
#pragma mark------------datasource&delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultCell*cell=[tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
       HistoryModel*model=self.dataArray[indexPath.row];
    [cell setHistorymodel:model];
    cell.KindTypeView.hidden=YES;
    cell.OtherTopViewHeight.constant=0;
    if(indexPath.row==self.dataArray.count-1){
        cell.LineLabel.hidden=YES;
    }else{
        cell.LineLabel.hidden=NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf;
    HistoryModel*historymodel=self.dataArray[indexPath.row];
    
    if ([historymodel.provider intValue]==2||[historymodel.provider intValue]==6) {
        SearchResultModel*resultmodel=[[SearchResultModel alloc]init];
        resultmodel.custom_id=historymodel.custom_id;
        resultmodel.local_provider_enum=historymodel.provider;
        
        SDMMapSearchDetailViewController*vc=[[SDMMapSearchDetailViewController alloc]init];
        vc.DetailModel=resultmodel;
        vc.SearchTFHidden=YES;
        vc.hidesBottomBarWhenPushed=YES;

        [self.dataArray insertObject:historymodel atIndex:0];
        [self.dataArray removeObjectAtIndex:indexPath.row+1];
        [self.SDMHistoryTabV reloadData];
        
        
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
            
            [self.dataArray insertObject:historymodel atIndex:0];
            [self.dataArray removeObjectAtIndex:indexPath.row+1];
            [self.SDMHistoryTabV reloadData];
            
            [weakSelf.navigationController pushViewController:vc animated:NO];
            
        } fail:^(NSError * _Nonnull error) {
            
            
        }];
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf;
    HistoryModel*model=self.dataArray[indexPath.row];

       
    UITableViewRowAction*DeleteAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController*CancelAlertViewController=[UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to delete the history ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*OkAct=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            self->LastIndex=indexPath.row;

            [[SearchResultViewModel defaultModel] requestDeleteHistoryParams:model.ID succeed:^(id  _Nonnull data) {
                
                [weakSelf.dataArray removeObjectAtIndex:self->LastIndex];
                [[ToolManager shareManager] SaveDataWithUserDefalutKey:HistoryData ArchiverDataObject:weakSelf.dataArray];

                [weakSelf.SDMHistoryTabV reloadData];
                
                } fail:^(NSError * _Nonnull error) {
                            
                        }];
           
        }];
        UIAlertAction*CancelAct=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [CancelAlertViewController addAction:OkAct];
        [CancelAlertViewController addAction:CancelAct];
        [weakSelf presentViewController:CancelAlertViewController animated:YES completion:nil];
        
    }];
    DeleteAction.backgroundColor=[UIColor colorWithPatternImage:[[ToolManager shareManager] creatZhujianImgView:@"delete_slider"]];

      
    
    
    
    return @[DeleteAction];
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ClickClearAll:(id)sender{
    kWeakSelf;
    UIAlertController*CancelAlertViewController=[UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to delete the history ?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*OkAct=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

       
       
        //[weakSelf requestDeleteData:baseURL1(@"histories") params:@{} tag:requestDelAllHistory];
        [[SearchResultViewModel defaultModel] requestDeleteAllHistorySucceed:^(id  _Nonnull data) {
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.SDMHistoryTabV addSubview:self.SDMHistoryTabV.TabcontenView];
                weakSelf.SDMHistoryTabV.DescLabel.text=@"No Recent Searches";
               [[ToolManager shareManager] SaveDataWithUserDefalutKey:HistoryData ArchiverDataObject:weakSelf.dataArray];

                [weakSelf.SDMHistoryTabV reloadData];
            
                } fail:^(NSError * _Nonnull error) {
                    
                }];
       
    }];
    UIAlertAction*CancelAct=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [CancelAlertViewController addAction:OkAct];
    [CancelAlertViewController addAction:CancelAct];
    [weakSelf presentViewController:CancelAlertViewController animated:YES completion:nil];
    
}
- (IBAction)GotoBack:(id)sender {
[self.navigationController popViewControllerAnimated:NO];
}
@end
