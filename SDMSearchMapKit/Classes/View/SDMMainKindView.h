//
//  SDMMainKindView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import <UIKit/UIKit.h>
#import "SDMCKScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SDMMainKindView : UIView<UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray*DataArray;
@property(nonatomic,strong)SDMCKScrollView*BgscrollV;
@end

NS_ASSUME_NONNULL_END
