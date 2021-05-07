//
//  BrunckpickKindView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrunckpickKindView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *ImgView;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *StarImgV;

@end

NS_ASSUME_NONNULL_END
