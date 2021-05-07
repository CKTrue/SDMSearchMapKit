//
//  SDMFavoriteViewController.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import "BaseViewController.h"
@class FavoritesView;
NS_ASSUME_NONNULL_BEGIN
typedef void (^FavoriteIndexBlock)(SearchResultModel* _Nonnull model);
@interface SDMFavoriteViewController : BaseViewController
@property(nonatomic,copy)FavoriteIndexBlock block;
@property (weak, nonatomic) IBOutlet BaseTableView *MyFavoriteTableV;
@property (weak, nonatomic) IBOutlet UIView *favoriteTopView;
@property (weak, nonatomic) IBOutlet FavoritesView *favoriteView;


@end

NS_ASSUME_NONNULL_END
