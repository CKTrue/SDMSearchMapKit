//
//  SDMVehicleLocationCell.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDMVehicleLocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;

@end

NS_ASSUME_NONNULL_END
