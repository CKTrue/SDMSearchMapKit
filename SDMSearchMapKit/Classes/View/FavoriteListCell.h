//
//  FavoriteListCell.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FavoriteListModel;
@interface FavoriteListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *MoveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImgView;
@property (weak, nonatomic) IBOutlet UIImageView *HeadTypeImgView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SubLabel;
@property (weak, nonatomic) IBOutlet UILabel *LineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SelectImgWidth;
@property(nonatomic,strong)FavoriteListModel*model;

@end

NS_ASSUME_NONNULL_END
