//
//  SearchResultViewModel.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import "BaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewModel : BaseViewModel
+ (SearchResultViewModel *)defaultModel;
//suggest列表
-(void)requestSearchSuggestSuccess:(NSString*)keyword MapSearchRadius:(double)radius Lat:(NSString*)lat Lng:(NSString*)lng succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;
//searchresult列表
-(void)requestSearchResultSuccess:(NSString*)searchStr MapSearchRadius:(double)radius Lat:(NSString*)lat Lng:(NSString*)lng PageNum:(NSInteger)page Provider:(NSString*)provider token:(NSString*)token succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;
//详情
-(void)requestSearchResultDetailSuccess:(NSString*)customId local_provider_num:(NSString*)local_provider_num succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

//获取收藏
-(void)requestGetFavoriteSucceed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

//取消收藏
-(void)requestDeleteFavorite:(NSString*)ID succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;
//批量取消收藏
-(void)requestDeleteMoreFavorite:(id)params succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

//新增收藏
-(void)requestAddFavorite:(NSString*)customId Lat:(NSString*)lat Lng:(NSString*)lng local_provider_num:(NSString*)local_provider_num name:(NSString*)name succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail;

//编辑收藏
-(void)requestEditFavorite:(NSString*)titlename favoiteId:(NSString*)ID succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

//移动收藏
-(void)requestMoveFavorite:(NSString*)params  succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail;

//获取查询历史记录
-(void)requestGetHistory:(NSInteger)pagenum Pagesize:(NSInteger)pagesize succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

//删除某条历史记录
-(void)requestDeleteHistoryParams:(NSString*)ID succeed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

//删除全部历史记录
-(void)requestDeleteAllHistorySucceed:(void(^)(id data))succeed fail:(void(^)(NSError *error))fail;

@end

NS_ASSUME_NONNULL_END
