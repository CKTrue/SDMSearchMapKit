//
//  FavoritesView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FavoritesView;
@protocol FavoritesViewDelegate <NSObject>

-(void)ClickFavoritesViewWithContentView:(UIView*)contentView;

@end
@interface FavoritesView : UIView<FavoritesViewDelegate>
@property(nonatomic,strong)NSMutableArray*DataArray;
@property(nonatomic,strong)UIScrollView*BgscrollV;
@property(nonatomic,assign)id<FavoritesViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
