//
//  SearchResultListVC.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;

@interface SDMSearchResultListVC : BaseViewController
-(void)setResultModel:(SearchResultModel *)resultModel WithSearchStr:(NSString*)str AndMapScale:(int)mapscale;

@end

NS_ASSUME_NONNULL_END
