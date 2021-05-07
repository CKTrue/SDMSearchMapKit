//
//  SDMMapSearchResultCell.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;
@interface SDMDrivingRangeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CanDrivingDistanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *KindTypeHeight;
@property(strong,nonatomic)SearchResultModel*Model;
@end

NS_ASSUME_NONNULL_END
