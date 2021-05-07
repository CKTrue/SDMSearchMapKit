//
//  SDMMapSearchResultCell.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;
@class SDMMapSearchResultCell;
@protocol SDMMapSearchResultCellDelegate <NSObject>
-(void)ClickSeeAllBtnByMapSearchRsultCell:(SDMMapSearchResultCell*)cell;
-(void)ClickGotoParkBtnByMapSearchRsultCell:(SDMMapSearchResultCell*)cell;
-(void)ClickLookCharageBtnByMapSearchRsultCell:(SDMMapSearchResultCell*)cell;
-(void)ClickLookFillingBtnByMapSearchRsultCell:(SDMMapSearchResultCell*)cell;
-(void)ClickSendToCarBtnByMapSearchRsultCell:(SDMMapSearchResultCell*)cell;

@end
@interface SDMMapSearchResultCell : UITableViewCell<SDMMapSearchResultCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *VRBtn;
- (IBAction)ClickSeeAllBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *HeadImgV;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescLabel;
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;
- (IBAction)GotoParkBtn:(id)sender;
- (IBAction)LookCharageBtn:(id)sender;
- (IBAction)LookFillingBtn:(id)sender;
- (IBAction)SendToCarBtn:(id)sender;
@property(nonatomic,strong)SearchResultModel*Model;
@property(nonatomic,assign)id<SDMMapSearchResultCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomDistance;

@end

NS_ASSUME_NONNULL_END
