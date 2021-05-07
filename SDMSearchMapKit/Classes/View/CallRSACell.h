//
//  CallRSACell.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;
@class CallRSACell;
@protocol CallRSACellDelegate <NSObject>

-(void)CallRSACellClickCallPhone:(CallRSACell*)cell;

@end
@interface CallRSACell : UITableViewCell<CallRSACellDelegate>
- (IBAction)LookOwnDetailBtn:(id)sender;
- (IBAction)ClickServiceBtn:(id)sender;

- (IBAction)ClickCallPhone:(id)sender;
@property(nonatomic,strong)SearchResultModel*model;
@property(nonatomic,assign)id<CallRSACellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
