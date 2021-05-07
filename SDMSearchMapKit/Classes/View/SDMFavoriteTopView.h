//
//  SDMFavoriteTopView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/22.
//

#import <UIKit/UIKit.h>
#import "FavoritesView.h"
NS_ASSUME_NONNULL_BEGIN
@class SDMFavoriteTopView;
@protocol SDMFavoriteTopViewDelegate <NSObject>
-(void)ClickBackByTopView:(SDMFavoriteTopView*)topView;
-(void)ClickClickEditByTopView:(SDMFavoriteTopView*)topView;

@end
@interface SDMFavoriteTopView : UIView<SDMFavoriteTopViewDelegate>
- (IBAction)ClickBack:(id)sender;
- (IBAction)ClickEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *EditBtn;
@property (weak, nonatomic) IBOutlet FavoritesView *favoriteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *EditBtnWidth;
@property(nonatomic,assign)id<SDMFavoriteTopViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
