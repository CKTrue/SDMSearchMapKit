//
//  SDMMapSearchDetailViewController.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import "MapBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;
@interface SDMMapSearchDetailViewController : MapBaseViewController
@property(nonatomic,strong)SearchResultModel*DetailModel;
@property(nonatomic,copy)NSString*SearchStr;
@property(nonatomic,assign)BOOL SearchTFHidden;

@end

NS_ASSUME_NONNULL_END
