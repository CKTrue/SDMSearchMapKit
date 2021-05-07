//
//  MapSearchOtherCell.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;
@class HistoryModel;
@class SearchResultCell;

@protocol SearchResultCellDelegate <NSObject>
-(void)ClickSeeAllBtnBySearchResultCell:(SearchResultCell*)cell;
@end
@interface SearchResultCell : UITableViewCell<SearchResultCellDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DateWidth;
@property (weak, nonatomic) IBOutlet UILabel *LineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OtherTopViewHeight;
@property (weak, nonatomic) IBOutlet UIView *KindTypeView;
@property (weak, nonatomic) IBOutlet UILabel *KindTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *HeadImgV;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property(nonatomic,strong)SearchResultModel*Model;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
- (IBAction)ClickSeeAllBtn:(id)sender;
@property(nonatomic,assign)id<SearchResultCellDelegate>delegate;
@property(nonatomic,strong)HistoryModel*historymodel;

@end

NS_ASSUME_NONNULL_END
