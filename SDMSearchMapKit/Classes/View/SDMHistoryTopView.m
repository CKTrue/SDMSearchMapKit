//
//  SDMHistoryTopView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/22.
//

#import "SDMHistoryTopView.h"

@implementation SDMHistoryTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)ClickClearAll:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickClearAllByTopView:)]) {
        [self.delegate ClickClearAllByTopView:self];
    }
}

- (IBAction)ClickBack:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickBackByTopView:)]) {
        [self.delegate ClickBackByTopView:self];
    }
}



@end
