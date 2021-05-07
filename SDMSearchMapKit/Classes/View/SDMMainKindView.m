//
//  SDMMainKindView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import "SDMMainKindView.h"
@implementation SDMMainKindView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setDataArray:(NSMutableArray *)DataArray{
    [self removeAllSubviews];
    _DataArray=DataArray;
    self.BgscrollV=[[SDMCKScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height)];
    self.BgscrollV.contentSize=CGSizeMake(80*self.DataArray.count+16, 0);
    self.BgscrollV.showsVerticalScrollIndicator=NO;
    self.BgscrollV.showsHorizontalScrollIndicator=NO;
    self.BgscrollV.isScrollStoped=1;
    [self addSubview: self.BgscrollV];
    self.BgscrollV.delegate=self;
    NSArray*array=@[@"Brunch",@"Events",@"Coffee",@"Shop",@"Hotel"];
    for (int i=0; i<DataArray.count; i++) {
        UIView*ContentView=[[UIView alloc]init];
        ContentView.frame=CGRectMake(80*i+16,0,56,94);
        [self.BgscrollV addSubview:ContentView];
        UIImageView*ImgBgView=[[UIImageView alloc]init];
        ImgBgView.frame=CGRectMake(0,0,56,56);
        [ContentView addSubview:ImgBgView];
        ImgBgView.tag=100+i;
        ImgBgView.layer.cornerRadius=8;
        ImgBgView.layer.masksToBounds=YES;

        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickAction:)];
        [ImgBgView addGestureRecognizer:tap];
        
        UILabel*nameLabel=[[UILabel alloc]init];
        [ContentView addSubview:nameLabel];
        nameLabel.frame=CGRectMake(0, 60, ContentView.frame.size.width, 17);
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.font=[UIFont fontWithName:@"ToyotaTypeW02-Regular" size:14];
        nameLabel.textColor=[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1];
        nameLabel.text=array[i];
        NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
           NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"SDMSearchMapKit" ofType:@"bundle"]];

        
        [ImgBgView setImage:[UIImage imageNamed:DataArray[i] inBundle: resourcesBundle compatibleWithTraitCollection:nil]
];
//        UILabel*distancelabel=[[UILabel alloc]init];
//        [ContentView addSubview:distancelabel];
//        distancelabel.frame=CGRectMake(0, 77, ContentView.frame.size.width, 17);
//        distancelabel.textAlignment=NSTextAlignmentCenter;
//        distancelabel.font=[UIFont fontWithName:@"ToyotaTypeW02-Regular" size:12];
//        
//        distancelabel.textColor=[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1];
//        distancelabel.alpha=0.5;

        
//        if ([self.DataArray[i] isKindOfClass:[FavoriteListModel class]]) {
//            FavoriteListModel*model=self.DataArray[i];
//        if ([model.provider intValue]==1){
//            [imgV setImage:[UIImage imageNamed:@"white_junction"]];
//        }
//        if ([model.provider intValue]==2){
//            [imgV setImage:[UIImage imageNamed:@"white_toyota"]];
//            ImgBgView.backgroundColor=[UIColor colorWithRed:235/255.0 green:10/255.0 blue:30/255.0 alpha:1];
//
//
//        }
//        if ([model.provider intValue]==3){
//            [imgV setImage:[UIImage imageNamed:@"white_own"]];
//
//
//        }
//        if ([model.provider intValue]==4){
//            [imgV setImage:[UIImage imageNamed:@"white_native"]];
//
//
//        }
//        if ([model.provider intValue]==5){
//            [imgV setImage:[UIImage imageNamed:@"white_video"]];
//
//
//        }
//        if ([model.provider intValue]==6){
//
//            [imgV setImage:[UIImage imageNamed:@"white_gis"]];
//            ImgBgView.backgroundColor=[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1];
//
//
//        }
        
//        CLLocationCoordinate2D coor1=CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
//        CLLocationCoordinate2D coor2=CLLocationCoordinate2DMake([DEF_PERSISTENT_GET_OBJECT(@"userLat") doubleValue], [DEF_PERSISTENT_GET_OBJECT(@"userLng") doubleValue]);
//        double Distance =[[ToolManager shareManager] getDistanceMetresBetweenLocationCoordinatesLocation1:coor1 Location2:coor2];
//        distancelabel.text=[[ToolManager shareManager] setDistanceStr:Distance];
        
    }
 
}
-(void)ClickAction:(UIGestureRecognizer*)gesture{
//    if ([self.delegate respondsToSelector:@selector(ClickFavoritesViewWithContentView:)]) {
//        [self.delegate ClickFavoritesViewWithContentView:gesture.view];
//    }
}

@end
