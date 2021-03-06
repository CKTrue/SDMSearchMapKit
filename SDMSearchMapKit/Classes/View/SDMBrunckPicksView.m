//
//  SDMBrunckPicksView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/23.
//

#import "SDMBrunckPicksView.h"
#import "BrunckpickKindView.h"
@implementation SDMBrunckPicksView

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
    self.BgscrollV.contentSize=CGSizeMake(160*self.DataArray.count+16, 0);
    self.BgscrollV.showsVerticalScrollIndicator=NO;
    self.BgscrollV.showsHorizontalScrollIndicator=NO;
    [self addSubview:self.BgscrollV];
    NSArray*array=@[@"Creme De La Crepe...",@"The Ordinarie",@"The Ordinarie"];
    NSArray*scorearray=@[@"4.6",@"4.8",@"4.5"];

    for (int i=0; i<DataArray.count; i++) {
        BrunckpickKindView*ContentView=(BrunckpickKindView*)[[ToolManager shareManager] creatAllreadAlterView:@"BrunckpickKindView"];
        ContentView.frame=CGRectMake(160*i+16,0,144,210);
        [self.BgscrollV addSubview:ContentView];
        NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
           NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"SDMSearchMapKit" ofType:@"bundle"]];

        
        [ContentView.ImgView setImage:[UIImage imageNamed:DataArray[i] inBundle: resourcesBundle compatibleWithTraitCollection:nil]];

      //  [ContentView.ImgView setImage:[[ToolManager shareManager] creatZhujianImgView:DataArray[i]]];
        ContentView.NameLabel.text=array[i];
        
        [ContentView.StarImgV setImage:[[ToolManager shareManager] creatZhujianImgView:@"star"]];
        ContentView.ScoreLabel.text=scorearray[i];
        

    }
 
}
@end
