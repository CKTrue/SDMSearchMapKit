//
//  FavoriteListModel.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteListModel : NSObject
@property(nonatomic,copy)NSString*content;
@property(nonatomic,copy)NSString*ID;
@property(nonatomic,copy)NSString*latitude;
@property(nonatomic,copy)NSString*longitude;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*place_id;
@property(nonatomic,copy)NSString*provider;
@property(nonatomic,copy)NSString*register_time;
@property(nonatomic,copy)NSString*custom_id;
@property(nonatomic,assign)BOOL delfavorite;

@end

NS_ASSUME_NONNULL_END
