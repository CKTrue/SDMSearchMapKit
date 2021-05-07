//
//  SDMMyCarLocationView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/25.
//

#import "SDMMyCarLocationView.h"

@implementation SDMMyCarLocationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)ClickNavigate:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SDMMyCarLocationViewClickNavigate)]) {
        [self.delegate SDMMyCarLocationViewClickNavigate];
    }
}
@end
