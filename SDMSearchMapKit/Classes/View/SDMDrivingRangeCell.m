//
//  SDMMapSearchResultCell.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/16.
//

#import "SDMDrivingRangeCell.h"
#import "SearchResultModel.h"
@implementation SDMDrivingRangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(SearchResultModel *)Model{
    
    _Model=Model;
    
    if (Model.vehiclestatus) {
        NSDictionary*ModelDic=Model.vehiclestatus;
        NSInteger odometer=[ModelDic[@"odometer"] integerValue];
        if (odometer>50) {
            self.CanDrivingDistanceLabel.text=[NSString stringWithFormat:@"%ld km",(long)odometer];
        }else{
            NSString*string=[NSString stringWithFormat:@"Low Fule · %ld km",(long)odometer];
            NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString: string]; //创建一个NSMutableAttributedString
            [AttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:235/255.0 green:10/255.0 blue:30/255.0 alpha:1] range:NSMakeRange(0,9)];
            self.CanDrivingDistanceLabel.attributedText=AttributedString;
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
