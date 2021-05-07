//
//  HistoryModel.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryModel : NSObject
@property(nonatomic,copy)NSString*custom_id;
@property(nonatomic,copy)NSString*ID;
@property(nonatomic,copy)NSString*keyword;
@property(nonatomic,copy)NSString*provider;
@property(nonatomic,copy)NSString*sub_title;
@property(nonatomic,copy)NSString*title;
@end

NS_ASSUME_NONNULL_END
