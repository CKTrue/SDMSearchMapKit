//
//  LoginOutView.h
//  ANN
//
//  Created by Kyle Li on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LoginOutView;
@protocol SelectLoginOutViewDelegate <NSObject>

-(void)ClickLoginOutBtnByView;
-(void)ClickCancelBtnByView;

@end
@interface LoginOutView : UIView<SelectLoginOutViewDelegate>
- (IBAction)LoginOutBtn:(id)sender;
- (IBAction)ClickCancelBtn:(id)sender;
@property(nonatomic,assign)id<SelectLoginOutViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
