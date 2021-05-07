//
//  CallRSACell.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import "CallRSACell.h"
#import "SearchResultModel.h"
@implementation CallRSACell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(SearchResultModel *)model{
    _model=model;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ClickCallPhone:(id)sender {
    
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_model.phone]] options:@{} completionHandler:^(BOOL success) {
          }];
}

- (IBAction)ClickServiceBtn:(id)sender {
}

- (IBAction)LookOwnDetailBtn:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(CallRSACellClickCallPhone:)]) {
        [self.delegate CallRSACellClickCallPhone:self];
    }
        
}
@end
