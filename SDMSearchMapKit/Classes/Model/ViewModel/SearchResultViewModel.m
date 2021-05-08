//
//  SearchResultViewModel.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import "SearchResultViewModel.h"
#import "SearchResultModel.h"
#import "APIModel.h"
#import "RequestHeaderManager.h"
@implementation SearchResultViewModel
+ (SearchResultViewModel *)defaultModel
{
    static dispatch_once_t once_t = 0;
    __strong static id defaultModel = nil;
    dispatch_once(&once_t, ^{
        defaultModel = [[self alloc] init];
    });
    return defaultModel;
}


//suggest
-(void)requestSearchSuggestSuccess:(NSString*)keyword MapSearchRadius:(double)radius Lat:(NSString*)lat Lng:(NSString*)lng succeed:(void (^)(id _Nonnull))succeed fail:( void (^)(NSError *))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    NSMutableDictionary*dic=[[NSMutableDictionary  alloc]initWithDictionary: @{@"keyword":keyword,@"radius":@(radius)}];
   
        [dic setValue:lat forKey:@"lat"];
        [dic setValue:lng forKey:@"lng"];
    model.body=dic;
    model.httpMethod=NetworkRequestTypeGET;
    model.header=[[RequestHeaderManager defaultManager] defaultheader];
   
    model.path=[NSString stringWithFormat:@"suggest"];
     [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError * _Nonnull error) {
            if (fail) {
                fail(nil);
            }
        }];
   
}
//searchList
-(void)requestSearchResultSuccess:(NSString*)searchStr MapSearchRadius:(double)radius Lat:(NSString*)lat Lng:(NSString*)lng PageNum:(NSInteger)page Provider:(NSString*)provider token:(NSString*)token succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError *))fail{
    kWeakSelf;
    NSMutableDictionary*dic=[[NSMutableDictionary  alloc]initWithDictionary: @{@"keyword":searchStr,@"radius":@(radius)}];
   
        [dic setValue:lat forKey:@"lat"];
        [dic setValue:lng forKey:@"lng"];
        [dic setValue:@(page) forKey:@"page"];
        [dic setValue:@(20) forKey:@"size"];
        if(token){
            [dic setValue:token forKey:@"pageToken"];

        }
    
    [dic setValue:provider forKey:@"localProviderEnum"];
    

    
    APIModel*model=[[APIModel alloc]init];
    model.body=dic;
    model.httpMethod=NetworkRequestTypeGET;

    model.header=[[RequestHeaderManager defaultManager] defaultheader];
  
    model.path=[NSString stringWithFormat:@"search"];
     [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError * _Nonnull error) {
            if (fail) {
                fail(nil);
            }
        }];
}
//searchDetail
-(void)requestSearchResultDetailSuccess:(NSString*)customId local_provider_num:(NSString*)local_provider_num succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError *))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    model.httpMethod=NetworkRequestTypeGET;
    model.header=[[RequestHeaderManager defaultManager] defaultheader];
    model.path=[NSString stringWithFormat:@"search/detail/%@/%@",customId,local_provider_num];
     [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
                if (fail) {
                    fail(error);
                }
        }];
}

-(void)requestGetFavoriteSucceed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    model.httpMethod=NetworkRequestTypeGET;
    model.header=[[RequestHeaderManager defaultManager] defaultheader];

    model.path=[NSString stringWithFormat:@"favorites"];

     [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            
            if (fail) {
                fail(nil);
            }
        }];
}
-(void)requestDeleteFavorite:(NSString*)ID succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    model.httpMethod=NetworkRequestTypeDELETE;
    model.header=[[RequestHeaderManager defaultManager] defaultheader];
    model.path=[NSString stringWithFormat:@"favorites/%@",ID];

     [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            if (fail) {
                fail(nil);
            }
        }];
}
-(void)requestDeleteMoreFavorite:(id)params succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    model.body=params;
    model.httpMethod=NetworkRequestTypeDELETE;
    model.header=[[RequestHeaderManager defaultManager] defaultheader];
    model.path=[NSString stringWithFormat:@"favorites"];

     [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            if (fail) {
                fail(nil);
            }
        }];
}

-(void)requestAddFavorite:(NSString*)customId Lat:(NSString*)lat Lng:(NSString*)lng local_provider_num:(NSString*)local_provider_num name:(NSString*)name succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    
    NSMutableDictionary*dic=[[NSMutableDictionary  alloc]initWithDictionary: @{@"custom_id":customId}];
    if(lat){
        [dic setValue:lat forKey:@"latitude"];
        
    }
    if(lng){
        [dic setValue:lng forKey:@"longitude"];
        
    }
    [dic setValue:local_provider_num forKey:@"provider"];
    [dic setValue:name forKey:@"name"];
    

    
    model.body=dic;
    model.httpMethod=NetworkRequestTypePOST;

    model.header=[[RequestHeaderManager defaultManager] defaultheader];
    model.path=[NSString stringWithFormat:@"favorites"];

    [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            
            if (fail) {
                fail(nil);
            }
        }];
}
-(void)requestEditFavorite:(NSString*)titlename favoiteId:(NSString*)ID succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    model.body=@{@"name":titlename};
    model.httpMethod=NetworkRequestTypePUT;

    model.header=[[RequestHeaderManager defaultManager] defaultheader];
    
    model.path=[NSString stringWithFormat:@"favorites/%@",ID];

    [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            
            if (fail) {
                fail(nil);
            }
        }];
}
-(void)requestMoveFavorite:(NSString*)params succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    model.body=params;
    model.httpMethod=NetworkRequestTypePUT;
    model.header=[[RequestHeaderManager defaultManager] defaultheader];

    model.path=[NSString stringWithFormat:@"favorites/orders"];

     [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            if (fail) {
                fail(nil);
            }
        }];
}

-(void)requestGetHistory:(NSInteger)pagenum Pagesize:(NSInteger)pagesize  succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:@{@"page":@(pagenum),@"size":@(pagesize)}];;
        
    model.body=dic;

    model.httpMethod=NetworkRequestTypeGET;

    model.header=[[RequestHeaderManager defaultManager] defaultheader];

    model.path=[NSString stringWithFormat:@"histories"];

    [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            
            if (fail) {
                fail(nil);
            }
        }];
}
-(void)requestDeleteHistoryParams:(NSString*)ID succeed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    model.httpMethod=NetworkRequestTypeDELETE;
    model.header=[[RequestHeaderManager defaultManager] defaultheader];

    model.path=[NSString stringWithFormat:@"histories/%@",ID];

    [weakSelf requestData:model succeed:^(id  _Nonnull data) {
           if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            if (fail) {
                fail(nil);
            }
        }];
}
-(void)requestDeleteAllHistorySucceed:(void (^)(id _Nonnull))succeed fail:(void (^)(NSError * ))fail{
    kWeakSelf;
    APIModel*model=[[APIModel alloc]init];
    model.httpMethod=NetworkRequestTypeDELETE;
    model.header=[[RequestHeaderManager defaultManager] defaultheader];

    model.path=[NSString stringWithFormat:@"histories"];

    [weakSelf requestData:model succeed:^(id  _Nonnull data) {
            if (succeed) {
                succeed(data);
            }
        } fail:^(NSError *  error) {
            if (fail) {
                fail(nil);
            }
        }];
}


@end
