//
//  SearchView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchView : UIView
@property (weak, nonatomic) IBOutlet UITextField *SearchTF;
@property (weak, nonatomic) IBOutlet UIButton *MyLocationBtn;
@property(strong,nonatomic)UIButton*checkPasswordBtn;
@property(strong,nonatomic)UIButton*backBtn;
@property (weak, nonatomic) IBOutlet UIButton *ShowMapViewControllerBtn;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator ;

@end

NS_ASSUME_NONNULL_END
