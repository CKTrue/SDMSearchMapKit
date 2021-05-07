//
//  SDMMapSearchResultCell.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import "SDMMapSearchResultCell.h"
#import "SearchResultModel.h"
@implementation SDMMapSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(SearchResultModel *)Model{
    _Model=Model;
    
//
//    if([Model.local_provider_enum intValue]==2){
//        [self.HeadImgV setImage:[UIImage imageNamed:@"toyota"]];
//        self.TitleLabel.text=[NSString stringWithFormat:@"%@",Model.title];
//        self.DescLabel.text=[NSString stringWithFormat:@"%@",Model.sub_title];
//        self.VRBtn.hidden=YES;
//
//    }
//
    if([Model.local_provider_enum intValue]==6){
        
        [self.HeadImgV setImage:[UIImage imageNamed:@"gis"]];
        self.TitleLabel.text=[NSString stringWithFormat:@"%@",Model.name];
        self.DescLabel.text=[NSString stringWithFormat:@"%@",Model.address];

    }
   
    if(Model.vehiclestatus){
        NSDictionary*dic=Model.vehiclestatus;
        if ([dic[@"odometer"] integerValue]<[Model.distance doubleValue]/1000) {
            NSString*string=[NSString stringWithFormat:@"%@\n Low Fule",[[ToolManager shareManager] setDistanceStr:[Model.distance doubleValue]]];
           
            NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString: string]; //创建一个NSMutableAttributedString
           
            [AttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:235/255.0 green:10/255.0 blue:30/255.0 alpha:1] range:NSMakeRange(0,string.length)];
           
            self.DistanceLabel.attributedText=AttributedString;
        
        }else{
            
            self.DistanceLabel.textColor=[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1];
            self.DistanceLabel.text=[[ToolManager shareManager] setDistanceStr:[Model.distance doubleValue]];

        }
    }else{
        self.DistanceLabel.textColor=[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1];

        self.DistanceLabel.text=[[ToolManager shareManager] setDistanceStr:[Model.distance doubleValue]];

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ClickSeeAllBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickSeeAllBtnByMapSearchRsultCell:)]) {
        [self.delegate ClickSeeAllBtnByMapSearchRsultCell:self];
    }
}
- (IBAction)SendToCarBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickSendToCarBtnByMapSearchRsultCell:)]) {
        [self.delegate ClickSendToCarBtnByMapSearchRsultCell:self];
    }
}

- (IBAction)LookFillingBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickLookFillingBtnByMapSearchRsultCell:)]) {
        [self.delegate ClickLookFillingBtnByMapSearchRsultCell:self];
    }
}

- (IBAction)LookCharageBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickLookCharageBtnByMapSearchRsultCell:)]) {
        [self.delegate ClickLookCharageBtnByMapSearchRsultCell:self];
    }
}

- (IBAction)GotoParkBtn:(id)sender {

if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickGotoParkBtnByMapSearchRsultCell:)]) {
    [self.delegate ClickGotoParkBtnByMapSearchRsultCell:self];
}
}
@end
