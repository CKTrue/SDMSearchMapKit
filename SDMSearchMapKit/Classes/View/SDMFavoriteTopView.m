//
//  SDMFavoriteTopView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/22.
//

#import "SDMFavoriteTopView.h"

@implementation SDMFavoriteTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)ClickEdit:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickClickEditByTopView:)]) {
        [self.delegate ClickClickEditByTopView:self];
    }
}

- (IBAction)ClickBack:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ClickBackByTopView:)]) {
        [self.delegate ClickBackByTopView:self];
    }
}
@end
