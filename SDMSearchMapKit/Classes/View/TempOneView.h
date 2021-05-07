//
//  TempOneView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "ChooseImgView.h"
#import "ToolManager.h"
NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;
@class TempOneView;
@protocol TempOneViewdelegate <NSObject>

-(void)TempOneViewClickCloseBtn:(TempOneView*)oneView;
-(void)TempOneViewClickFavoriteBtn:(TempOneView*)oneView;
-(void)TempOneViewClickNavigateView:(SearchResultModel*)model;
-(void)TempOneViewClickShareBtn:(SearchResultModel*)model;

@end
@interface TempOneView : UIView<TempOneViewdelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *OneScrollV;
@property (weak, nonatomic) IBOutlet UILabel *SearchKindLabel;
@property (weak, nonatomic) IBOutlet UIView *PhotoBgView;
@property (weak, nonatomic) IBOutlet UIView *NavigateView;
@property (weak, nonatomic) IBOutlet UIView *ShareView;
@property (weak, nonatomic) IBOutlet UIImageView *CarTypeImgV;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *PhoneImgV;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *FavoritesBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PhoneHeight;
@property (weak, nonatomic) IBOutlet UILabel *OpenTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OpenTimeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TimeHeight;
@property (weak, nonatomic) IBOutlet UIView *OneTopView;
@property (weak, nonatomic) IBOutlet UIImageView *OpenTimeImgV;
@property (weak, nonatomic) IBOutlet UIView *TimeView;
@property (weak, nonatomic) IBOutlet ChooseImgView *PhotosView;
@property (weak, nonatomic) IBOutlet UIView *LinkView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LinkHeight;
@property (weak, nonatomic) IBOutlet UILabel *LinkLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PhotoHeight;
@property(nonatomic,strong)SearchResultModel*model;
@property (weak, nonatomic) IBOutlet UIView *PhoneView;
- (IBAction)ClickCloseBtn:(id)sender;
- (IBAction)ClickFavirateBtn:(id)sender;
- (IBAction)ClickSendToCar:(id)sender;
- (IBAction)ClickRemoteAirport:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *RatingLabel;
@property(nonatomic,assign)id<TempOneViewdelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *RemoteStartBtn;

@end

NS_ASSUME_NONNULL_END
