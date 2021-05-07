//
//  MapSearchOtherCell.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import "SearchResultCell.h"
#import "SearchResultModel.h"
#import "HistoryModel.h"
#import "ToolManager.h"
@implementation SearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(SearchResultModel *)Model{
    _Model=Model;
    if([_Model.local_provider_enum intValue]==1){
        self.KindTypeLabel.text=@"Junctions";
        [self.HeadImgV setImage:[UIImage imageNamed:@"junction"]];

    }
    if([_Model.local_provider_enum intValue]==2){
        self.KindTypeLabel.text=@"Dealer";
        [self.HeadImgV setImage:[UIImage imageNamed:@"toyota"]];
       
    }
    if([_Model.local_provider_enum intValue]==3){
        self.KindTypeLabel.text=@"Owners Manual";
        [self.HeadImgV setImage:[UIImage imageNamed:@"own"]];

    }
    if([_Model.local_provider_enum intValue]==4){
        self.KindTypeLabel.text=@"Native";
        [self.HeadImgV setImage:[UIImage imageNamed:@"native"]];

    }
    if([_Model.local_provider_enum intValue]==5){
        self.KindTypeLabel.text=@"Video";
        [self.HeadImgV setImage:[UIImage imageNamed:@"video"]];

    }
    if([_Model.local_provider_enum intValue]==6){
        self.KindTypeLabel.text=@"Gis";
        [self.HeadImgV setImage:[UIImage imageNamed:@"gis"]];

    }
  
  
    if([_Model.local_provider_enum intValue]==7){
        self.KindTypeLabel.text=@"Events";
        [self.HeadImgV setImage:[UIImage imageNamed:@"event"]];

    }
   
    if ([_Model.local_provider_enum intValue]==6) {
        
        self.TitleLabel.text=[NSString stringWithFormat:@"%@",Model.name];
        self.descLabel.text=[NSString stringWithFormat:@"%@",Model.address];
    }else{
    
        self.TitleLabel.text=[NSString stringWithFormat:@"%@",Model.title];
        self.descLabel.text=[NSString stringWithFormat:@"%@",Model.sub_title];
    }
    if(Model.vehiclestatus){
        NSDictionary*dic=Model.vehiclestatus;
        if ([dic[@"odometer"] integerValue]<[Model.distance doubleValue]/1000) {
            NSString*string=[NSString stringWithFormat:@"%@\n Low Fule",[[ToolManager shareManager] setDistanceStr:[Model.distance doubleValue]]];
           
            NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString: string]; //创建一个NSMutableAttributedString
           
            [AttributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ToyotaTypeW02-regular" size:8] range:NSMakeRange(string.length-8,8)];

            [AttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:235/255.0 green:10/255.0 blue:30/255.0 alpha:1] range:NSMakeRange(0,string.length)];

           
            self.DateLabel.attributedText=AttributedString;
        
        }else{
            
            self.DateLabel.textColor=[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1];
            self.DateLabel.text=[[ToolManager shareManager] setDistanceStr:[Model.distance doubleValue]];

        }
    }else{
        self.DateLabel.textColor=[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1];

        self.DateLabel.text=[[ToolManager shareManager] setDistanceStr:[Model.distance doubleValue]];

    }
    
}

-(void)setHistorymodel:(HistoryModel *)historymodel{
    _historymodel=historymodel;
    
    if([historymodel.provider intValue]==1){
        [self.HeadImgV setImage:[UIImage imageNamed:@"junction"]];
    }
    if([historymodel.provider intValue]==2){
        [self.HeadImgV setImage:[UIImage imageNamed:@"toyota"]];


    }
    if([historymodel.provider intValue]==3){
        [self.HeadImgV setImage:[UIImage imageNamed:@"own"]];


    }
    if([historymodel.provider intValue]==4){
        [self.HeadImgV setImage:[UIImage imageNamed:@"native"]];


    }
    if([historymodel.provider intValue]==5){
        [self.HeadImgV setImage:[UIImage imageNamed:@"video"]];


    }
    if([historymodel.provider intValue]==6){
        
        [self.HeadImgV setImage:[UIImage imageNamed:@"gis"]];

       
    }
    self.TitleLabel.text=[NSString stringWithFormat:@"%@",_historymodel.title];
    self.descLabel.text=[NSString stringWithFormat:@"%@",_historymodel.sub_title];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ClickSeeAllBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickSeeAllBtnBySearchResultCell:)]) {
        [self.delegate ClickSeeAllBtnBySearchResultCell:self];
    }
}
@end
