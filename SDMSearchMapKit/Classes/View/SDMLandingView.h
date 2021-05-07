//
//  SDMLandingView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SDMLandingView;
@protocol SDMLandingViewDelegate <NSObject>
-(void)ClickCoffeeView:(SDMLandingView*)landingView;
-(void)ClickRestaurantsView:(SDMLandingView*)landingView;
-(void)ClickGasView:(SDMLandingView*)landingView;
-(void)ClickGroceriesView:(SDMLandingView*)landingView;

@end
@interface SDMLandingView : UIView<SDMLandingViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *CoffeeView;
@property (weak, nonatomic) IBOutlet UIView *RestaurantsView;
@property (weak, nonatomic) IBOutlet UIView *GasView;
@property (weak, nonatomic) IBOutlet UIView *GroceriesView;
@property(nonatomic,assign)id<SDMLandingViewDelegate>deleagte;
@end

NS_ASSUME_NONNULL_END
