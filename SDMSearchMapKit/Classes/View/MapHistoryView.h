//
//  MapHistoryView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "FavoritesView.h"
@class SearchResultCell;
@class MapHistoryView;
@class FavoritesView;
@class HistoryModel;
NS_ASSUME_NONNULL_BEGIN
@protocol MapHistoryViewDelegate <NSObject>

-(void)MapHistoryViewClickMoreFavoriteBtn;
-(void)MapHistoryViewClickMoreSearchBtn;
-(void)MapHistoryViewClickFavorite:(UIView*)favoriteView;
-(void)MapHistoryViewClickSearch:(HistoryModel*)historymodel;


@end
@interface MapHistoryView : UIView<UITableViewDelegate,UITableViewDataSource,MapHistoryViewDelegate,FavoritesViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *NameCarLabel;
@property (weak, nonatomic) IBOutlet UILabel *MyCarAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *MyCarDistanceLabel;
@property (weak, nonatomic) IBOutlet FavoritesView *FavoritesView;
- (IBAction)LookFavoritesAllBtn:(id)sender;
@property (weak, nonatomic) IBOutlet BaseTableView *MapHistoryTabV;
- (IBAction)LookAllHistoryBtn:(id)sender;
@property(nonatomic,assign)id<MapHistoryViewDelegate>delegate;
@property(nonatomic,strong)NSMutableArray*HistoryArray;

@end

NS_ASSUME_NONNULL_END
