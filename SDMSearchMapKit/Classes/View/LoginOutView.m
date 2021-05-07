//
//  LoginOutView.m
//  ANN
//
//  Created by Kyle Li on 2021/3/17.
//

#import "LoginOutView.h"

@implementation LoginOutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)ClickCancelBtn:(id)sender {
    if(self.delegate&&[self.delegate respondsToSelector:@selector(ClickCancelBtnByView)]) {
        [self.delegate ClickCancelBtnByView];
        
    }}

- (IBAction)LoginOutBtn:(id)sender {
    if(self.delegate&&[self.delegate respondsToSelector:@selector(ClickLoginOutBtnByView)]) {
        [self.delegate ClickLoginOutBtnByView];
        
    }
   
}
@end
