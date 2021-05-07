//
//  MapBaseViewController.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/20.
//

#import "BaseViewController.h"
#import "SearchView.h"
#import "SDMLandingView.h"
@class SearchResultCell;
@class SearchResultVC;
@class TempOneView;
NS_ASSUME_NONNULL_BEGIN

@interface MapBaseViewController : BaseViewController
@property (nonatomic,strong) GMSMarker *marker;//大头针
@property(nonatomic,strong)GMSMapView*mapView;
@property(nonatomic,strong)SearchView*searchView;
@property (strong, nonatomic) UIView *LandgingScreenView;
@property(strong,nonatomic)SDMLandingView*landView;
@property(nonatomic,assign)NSInteger UpOrDown;
@property(nonatomic,strong)SearchResultVC*resultVC;
@property (strong, nonatomic) UIView *shadowView;
@property(nonatomic,strong)TempOneView*oneView;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic)UIButton*MyLocationBtn;
-(void)GetAllMarkerInScreen;
-(void)doNavigationWithEndLocation:(NSArray *)endLocation;
@end

NS_ASSUME_NONNULL_END
