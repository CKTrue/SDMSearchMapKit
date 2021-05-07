//
//  APIModel.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIModel : NSObject
@property(nonatomic,copy)NSString*path;
@property(nonatomic,strong)NSDictionary*header;
@property(nonatomic,strong)id body;
@property(nonatomic,assign)NSInteger httpMethod;

@end

NS_ASSUME_NONNULL_END
