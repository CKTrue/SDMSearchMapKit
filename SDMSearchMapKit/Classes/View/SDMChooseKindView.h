//
//  SDMChooseKindView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import <UIKit/UIKit.h>
#import "SDMMainKindView.h"
#import "SDMBrunckPicksView.h"
NS_ASSUME_NONNULL_BEGIN
@interface SDMChooseKindView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIView *ChooseOneView;
@property (weak, nonatomic) IBOutlet UIView *ChooseTwoView;
@property (weak, nonatomic) IBOutlet UIView *ChooseThreeView;

@property (weak, nonatomic) IBOutlet SDMMainKindView *ChooseOneKindView;
@property (weak, nonatomic) IBOutlet SDMBrunckPicksView *ChooseTwoKindView;
@property (weak, nonatomic) IBOutlet SDMBrunckPicksView *ChooseThreeKindView;

@end

NS_ASSUME_NONNULL_END
