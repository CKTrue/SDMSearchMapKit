//
//  SearchResultVC.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/25.
//

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class SearchResultModel;
typedef void (^IndexBlock)(SearchResultModel* _Nonnull model);
typedef void (^MarkerBlock)(NSMutableArray* _Nonnull Array);

@interface SearchResultVC : BaseViewController
@property (strong, nonatomic)  BaseTableView *SearchTabV;
@property(nonatomic,strong)SearchResultModel*resultModel;
@property(nonatomic,strong)NSMutableArray*sourceArray;
@property(nonatomic,copy)IndexBlock block;
@property(nonatomic,copy)MarkerBlock markerBlock;

@property (nonatomic, assign) NSInteger PageNum;
@property (nonatomic, assign)   CGFloat                 offsetY; // shadowView在第一个视图中的位置  就3个位置：Y1 Y2 Y3;     offsetY初始值为0 无所谓 不影响结果

@property(nonatomic,assign)BOOL CellResult;

-(void)setResultModel:(SearchResultModel *)resultModel WithSearchStr:(NSString*)str AndMapScale:(int)mapscale;
@end

NS_ASSUME_NONNULL_END
