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
        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [currentBundle pathForResource:@"ToyotaTypeW02-Regular.ttf" ofType:nil inDirectory:@"SDMSearchMapKit"];
        nameLabel.font=[UIFont fontWithName:path size:14];

        nameLabel.textColor=[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1];
        nameLabel.text=array[i];
        NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
           NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"SDMSearchMapKit" ofType:@"bundle"]];

        
        [ImgBgView setImage:[UIImage imageNamed:DataArray[i] inBundle: resourcesBundle compatibleWithTraitCollection:nil]];



    }
 
}
-(void)ClickAction:(UIGestureRecognizer*)gesture{
//    if ([self.delegate respondsToSelector:@selector(ClickFavoritesViewWithContentView:)]) {
//        [self.delegate ClickFavoritesViewWithContentView:gesture.view];
//    }
}

@end
