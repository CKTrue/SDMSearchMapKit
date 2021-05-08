//
//  SDMFavoriteViewController.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import "SDMFavoriteViewController.h"
#import "FavoriteListCell.h"
#import "FavoriteListModel.h"
#import "SearchResultModel.h"
#import "CustomWebView.h"
#import "SDMMapSearchDetailViewController.h"
#import "SDMFavoriteTopView.h"
@interface SDMFavoriteViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,FavoritesViewDelegate>
{
    BOOL Isselect;
    NSInteger LastIndex;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray*deleteArray;

- (IBAction)ClickdeleteBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *DeleteBtn;
- (IBAction)ClickBackBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *EditBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delBtnHeight;
- (IBAction)ClickEditBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *CancelLabel;
@end

@implementation SDMFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text=@"Favorites";
    [self.MyFavoriteTableV registerNib:[UINib nibWithNibName:@"FavoriteListCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"FavoriteListCell"];
    self.MyFavoriteTableV.delegate=self;
    self.MyFavoriteTableV.dataSource=self;
    self.MyFavoriteTableV.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.MyFavoriteTableV.separatorColor=[UIColor whiteColor];
    self.MyFavoriteTableV.scrollEnabled=NO;
    
    self.dataArray=[[NSMutableArray alloc]init];
    self.favoriteView.delegate=self;
    self.favoriteView.BgscrollV.bounces=NO;
    kWeakSelf;
    
   [[SearchResultViewModel defaultModel] requestGetFavoriteSucceed:^(id  _Nonnull data) {
        weakSelf.dataArray=[FavoriteListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [[ToolManager shareManager] SaveDataWithUserDefalutKey:FavoriteData ArchiverDataObject:weakSelf.dataArray];

        
        [weakSelf.MyFavoriteTableV reloadData];
        [weakSelf UpdateFavoriteTopView];
        
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
    
    for (FavoriteListModel*model in self.dataArray) {
        model.delfavorite=NO;
    }
    
    LastIndex=-1;
    Isselect=NO;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.MyFavoriteTableV) {
        CGFloat offY = scrollView.contentOffset.y;
        if (offY < 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}
-(void)EditFavoriteList{
    Isselect=!Isselect;
    
    self.DeleteBtn.hidden=!self.DeleteBtn.hidden;
    
    
    if (Isselect==YES) {
        self.CancelLabel.text=@"Cancel";
        self.delBtnHeight.constant=50+BottomHeight;
        self.CancelLabel.hidden=NO;
        
    }else{
        
        
        self.delBtnHeight.constant=0;
        self.CancelLabel.hidden=YES;
        
        NSMutableArray*moveDataArr=[[NSMutableArray alloc]init];
        for (FavoriteListModel*model in self.dataArray) {
            model.delfavorite=NO;
            [moveDataArr addObject:model.ID];
        }
        if ([self.CancelLabel.text isEqualToString:@"save"]) {
            
            NSError *parseError = nil;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:moveDataArr options:NSJSONWritingPrettyPrinted  error:&parseError];
            
            NSString *jsonstr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            kWeakSelf;
            [[SearchResultViewModel defaultModel] requestMoveFavorite:jsonstr succeed:^(id  _Nonnull data) {
                
                weakSelf.dataArray=[FavoriteListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
                [[ToolManager shareManager] SaveDataWithUserDefalutKey:FavoriteData ArchiverDataObject:weakSelf.dataArray];

                [weakSelf.MyFavoriteTableV reloadData];
                [self UpdateFavoriteTopView];
                
            } fail:^(NSError * _Nonnull error) {
                
            }];
        }
        
    }
    [self.MyFavoriteTableV reloadData];
    
}
-(void)UpdateFavoriteTopView{
    NSInteger index=self.dataArray.count;
    
    if (self.dataArray.count>10) {
        index=10;
    }
    
    NSMutableArray*array=[[NSMutableArray alloc]initWithArray:[self.dataArray subarrayWithRange:NSMakeRange(0, index)]];
    if(![array isEqualToArray:self.favoriteView.DataArray]){
        self.favoriteView.DataArray=array;
    }
}

#pragma mark------------datasource&delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteListCell*cell=[tableView dequeueReusableCellWithIdentifier:@"FavoriteListCell" forIndexPath:indexPath];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [cell.contentView addGestureRecognizer:longPress];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    FavoriteListModel*model=self.dataArray[indexPath.row];
    [cell setModel:model];
    if(indexPath.row==self.dataArray.count-1){
        cell.LineLabel.hidden=YES;
    }else{
        cell.LineLabel.hidden=NO;
    }
    if(Isselect==YES){
        cell.contentView.userInteractionEnabled=YES;
        cell.SelectImgWidth.constant=24;
        cell.SelectImgView.hidden=NO;
        [cell.MoveBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"move"] forState:UIControlStateNormal];
        if (model.delfavorite==YES) {
            [cell.SelectImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"check_box"]];
            
        }else{
            [cell.SelectImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"check_box_outline"]];
            
        }
        
    }else{
        cell.contentView.userInteractionEnabled=NO;
        cell.SelectImgWidth.constant=0;
        cell.SelectImgView.hidden=YES;
        [cell.SelectImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"check_box_outline"]];
        [cell.MoveBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"right_arrow"] forState:UIControlStateNormal];
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteListModel*model=self.dataArray[indexPath.row];
    if(Isselect==YES){
        model.delfavorite=!model.delfavorite;
        [self.MyFavoriteTableV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
      
        SearchResultModel*resultmodel=[[SearchResultModel alloc]init];
        resultmodel.custom_id=model.custom_id;
        resultmodel.local_provider_enum=model.provider;
        SDMMapSearchDetailViewController*vc=[[SDMMapSearchDetailViewController alloc]init];
        vc.DetailModel=resultmodel;
        vc.SearchTFHidden=YES;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:NO];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(Isselect==YES){
        return NO;
    }
    return YES;
}
-(NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf;
    FavoriteListModel*model=self.dataArray[indexPath.row];
    
    UITableViewRowAction*EditAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController*AlertViewController=[UIAlertController alertControllerWithTitle:@"Set Note Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [AlertViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder=@"Set Note Name";
        }];
        UIAlertAction*OkAct=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField * sureFiled = AlertViewController.textFields.firstObject;
            NSString *temp = [sureFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if(temp.length==0){
                [weakSelf AlertViewShowMsg:@"Note name can not be empty"];
                
                return;
            }
            self->LastIndex=indexPath.row;
            
            
            [[SearchResultViewModel defaultModel] requestEditFavorite:sureFiled.text favoiteId:model.ID succeed:^(id  _Nonnull data) {
                
                FavoriteListModel*model=[FavoriteListModel mj_objectWithKeyValues:data[@"data"]];
                [weakSelf.dataArray replaceObjectAtIndex:self->LastIndex withObject:model];
                [[ToolManager shareManager] SaveDataWithUserDefalutKey:FavoriteData ArchiverDataObject:weakSelf.dataArray];

                [weakSelf AlertViewShowMsg:@"Update success"];
                
                [weakSelf.MyFavoriteTableV reloadData];
                [weakSelf UpdateFavoriteTopView];
                
                
            } fail:^(NSError * _Nonnull error) {
                
                
            }];
            
        }];
        UIAlertAction*CancelAct=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [AlertViewController addAction:OkAct];
        [AlertViewController addAction:CancelAct];
        [weakSelf presentViewController:AlertViewController animated:YES completion:nil];
        
    }];
    UITableViewRowAction*DeleteAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController*CancelAlertViewController=[UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to delete the collection ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*OkAct=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->LastIndex=indexPath.row;
            
            
            [[SearchResultViewModel defaultModel] requestDeleteFavorite:model.ID succeed:^(id  _Nonnull data) {
                
                [weakSelf.dataArray removeObjectAtIndex:self->LastIndex];
                [[ToolManager shareManager] SaveDataWithUserDefalutKey:FavoriteData ArchiverDataObject:weakSelf.dataArray];

                [weakSelf AlertViewShowMsg:@"Cancel collection success"];
                
                [weakSelf.MyFavoriteTableV reloadData];
                [weakSelf UpdateFavoriteTopView];
                
            } fail:^(NSError * _Nonnull error) {
                
            }];
            
            
        }];
        UIAlertAction*CancelAct=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [CancelAlertViewController addAction:OkAct];
        [CancelAlertViewController addAction:CancelAct];
        [weakSelf presentViewController:CancelAlertViewController animated:YES completion:nil];
        
    }];
    EditAction.backgroundColor=[UIColor colorWithPatternImage:[[ToolManager shareManager] creatZhujianImgView:@"edit_slider"]];
    DeleteAction.backgroundColor=[UIColor colorWithPatternImage:[[ToolManager shareManager] creatZhujianImgView:@"delete_slider"]];
    
    return @[DeleteAction,EditAction];
    
    
    
    
    
    
    
    
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



#pragma mark----
-(void)ClickFavoritesViewWithContentView:(UIView *)contentView{
    FavoriteListModel*model=self.dataArray[contentView.tag-100];
    
    SearchResultModel*resultmodel=[[SearchResultModel alloc]init];
    resultmodel.custom_id=model.custom_id;
    resultmodel.local_provider_enum=model.provider;
    SDMMapSearchDetailViewController*vc=[[SDMMapSearchDetailViewController alloc]init];
    vc.DetailModel=resultmodel;
    vc.SearchTFHidden=YES;
    vc.hidesBottomBarWhenPushed=YES;

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

- (IBAction)ClickdeleteBtn:(id)sender {
    self.deleteArray=[[NSMutableArray alloc]init];
    NSMutableArray*delArray=[[NSMutableArray alloc]init];;
    for (FavoriteListModel*model in self.dataArray) {
        
        if (model.delfavorite==YES) {
            [delArray addObject:model.ID];
            [self.deleteArray addObject:model];
        }
    }
    if (self.deleteArray.count==0) {
        [self AlertViewShowMsg:@"Please select delete target"];
        
        return;
    }
    kWeakSelf;
    UIAlertController*CancelAlertViewController=[UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to delete the collection ?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*OkAct=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:delArray options:NSJSONWritingPrettyPrinted  error:&parseError];
        
        NSString *jsonstr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       
        [[SearchResultViewModel defaultModel] requestDeleteMoreFavorite:jsonstr succeed:^(id  _Nonnull data) {
            
            [weakSelf.dataArray removeObjectsInArray:weakSelf.deleteArray];
            [[ToolManager shareManager] SaveDataWithUserDefalutKey:FavoriteData ArchiverDataObject:weakSelf.dataArray];

            [weakSelf AlertViewShowMsg:@"Cancel collection success"];
            
            [weakSelf.MyFavoriteTableV reloadData];
            [weakSelf UpdateFavoriteTopView];
            
            
        } fail:^(NSError * _Nonnull error) {
            
        }];
        
        
    }];
    UIAlertAction*CancelAct=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [CancelAlertViewController addAction:OkAct];
    [CancelAlertViewController addAction:CancelAct];
    [weakSelf presentViewController:CancelAlertViewController animated:YES completion:nil];
    
}
-(void)longPressGestureRecognized:(UIGestureRecognizer*)longPressgesture{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)longPressgesture;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.MyFavoriteTableV];
    NSIndexPath *indexPath = [self.MyFavoriteTableV indexPathForRowAtPoint:location];
    
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // ... update data source.
                [self.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.MyFavoriteTableV moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
                self.CancelLabel.text=@"save";
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.MyFavoriteTableV reloadData];
            
            
        }
            break;
        default: {
            
            break;
        }
    }
}
//-(UIColor *)colorWithPatternImage:(UIImage *)image{
//
//UIImage *(^GetImageWithView)(UIView *) = ^(UIView *view) {
//  UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
//  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//  UIGraphicsEndImageContext();
//  return image;
//};
//}
- (IBAction)ClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (IBAction)ClickEditBtn:(id)sender {
    [self EditFavoriteList];
    
}
@end

