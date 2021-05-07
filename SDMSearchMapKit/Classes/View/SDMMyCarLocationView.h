//
//  SDMMyCarLocationView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SDMMyCarLocationViewDelegate <NSObject>

-(void)SDMMyCarLocationViewClickNavigate;

@end
@interface SDMMyCarLocationView : UIView<SDMMyCarLocationViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *distancelabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
- (IBAction)ClickNavigate:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *NavigateBtn;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property(nonatomic,assign)id<SDMMyCarLocationViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
