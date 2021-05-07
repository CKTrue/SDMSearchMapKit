//
//  SDMMapSearchResultViewController.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import "MapBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;

@interface SDMMapSearchResultViewController : MapBaseViewController
@property(nonatomic,copy)NSString*SearchStr;
@property(nonatomic,strong)SearchResultModel*ResultModel;
@property(nonatomic,assign)BOOL CellResult;

@end

NS_ASSUME_NONNULL_END
