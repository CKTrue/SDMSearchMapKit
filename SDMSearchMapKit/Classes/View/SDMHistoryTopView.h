//
//  SDMHistoryTopView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SDMHistoryTopView;
@protocol SDMHistoryTopViewDelegate <NSObject>
-(void)ClickBackByTopView:(SDMHistoryTopView*)topView;
-(void)ClickClearAllByTopView:(SDMHistoryTopView*)topView;

@end
@interface SDMHistoryTopView : UIView<SDMHistoryTopViewDelegate>
- (IBAction)ClickBack:(id)sender;
- (IBAction)ClickClearAll:(id)sender;

@property(nonatomic,assign)id<SDMHistoryTopViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
