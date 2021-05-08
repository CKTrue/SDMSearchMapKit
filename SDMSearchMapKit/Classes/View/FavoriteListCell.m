//
//  FavoriteListCell.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import "FavoriteListCell.h"
#import "FavoriteListModel.h"
@implementation FavoriteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
}
-(void)setModel:(FavoriteListModel *)model{
    _model=model;
    if([model.provider intValue]==1){
        [self.HeadTypeImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"junction"]];
    }
    if([model.provider intValue]==2){
        [self.HeadTypeImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"toyota"]];


    }
    if([model.provider intValue]==3){
        [self.HeadTypeImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"own"]];


    }
    if([model.provider intValue]==4){
        [self.HeadTypeImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"native"]];


    }
    if([model.provider intValue]==5){
        [self.HeadTypeImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"video"]];


    }
    if([model.provider intValue]==6){
        
        [self.HeadTypeImgView setImage:[[ToolManager shareManager] creatZhujianImgView:@"gis"]];

       
    }
    self.TitleLabel.text=model.name;
    CLLocationCoordinate2D coor1=CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
    CLLocationCoordinate2D coor2=CLLocationCoordinate2DMake([DEF_PERSISTENT_GET_OBJECT(@"userLat") doubleValue], [DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue]);
    double Distance =[[ToolManager shareManager] getDistanceMetresBetweenLocationCoordinatesLocation1:coor1 Location2:coor2];
    self.SubLabel.text=[[ToolManager shareManager] setDistanceStr:Distance];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
