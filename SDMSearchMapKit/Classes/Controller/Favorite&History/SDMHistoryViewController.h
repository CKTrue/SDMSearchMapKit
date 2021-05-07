//
//  SDMHistoryViewController.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/2.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^HistoryIndexBlock)(SearchResultModel* _Nonnull model);

@interface SDMHistoryViewController : BaseViewController
@property(nonatomic,copy)HistoryIndexBlock historyblock;
@property (weak, nonatomic) IBOutlet BaseTableView *SDMHistoryTabV;
@property(nonatomic,weak)IBOutlet UIView*historyTopView;

@end

NS_ASSUME_NONNULL_END
