//
//  MapHistoryView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/23.
//

#import "MapHistoryView.h"
#import "SearchResultCell.h"
#import "HistoryModel.h"
@interface MapHistoryView ()
@end
@implementation MapHistoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.MapHistoryTabV registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:[[ToolManager shareManager] subBundleWithBundleName]] forCellReuseIdentifier:@"SearchResultCell"];
    self.MapHistoryTabV.delegate=self;
    self.MapHistoryTabV.dataSource=self;
    self.MapHistoryTabV.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.MapHistoryTabV.separatorColor=[UIColor whiteColor];
    self.FavoritesView.delegate=self;
    self.MapHistoryTabV.scrollEnabled=NO;

}
-(void)setHistoryArray:(NSMutableArray *)HistoryArray{
    _HistoryArray=HistoryArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.HistoryArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultCell*cell=[tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
       HistoryModel*model=self.HistoryArray[indexPath.row];
    [cell setHistorymodel:model];
    cell.KindTypeView.hidden=YES;
    cell.OtherTopViewHeight.constant=0;
    if(indexPath.row==self.HistoryArray.count-1){
        cell.LineLabel.hidden=YES;
    }else{
        cell.LineLabel.hidden=NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryModel*model=self.HistoryArray[indexPath.row];

    if (self.delegate&&[self.delegate respondsToSelector:@selector(MapHistoryViewClickSearch:)]) {
        [self.delegate MapHistoryViewClickSearch:model];
    }
}
- (IBAction)LookFavoritesAllBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(MapHistoryViewClickMoreFavoriteBtn)]) {
        [self.delegate MapHistoryViewClickMoreFavoriteBtn];
    }
}
- (IBAction)LookAllHistoryBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(MapHistoryViewClickMoreSearchBtn)]) {
        [self.delegate MapHistoryViewClickMoreSearchBtn];
    }
}
-(void)ClickFavoritesViewWithContentView:(UIView *)contentView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(MapHistoryViewClickFavorite:)]) {
        [self.delegate MapHistoryViewClickFavorite:contentView];
    }
}
@end
