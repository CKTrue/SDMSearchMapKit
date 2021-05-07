//
//  SearchResultModel.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultModel : NSObject
@property(nonatomic,copy)NSString* active_flg;
@property(nonatomic,copy)NSString*address;
@property(nonatomic,copy)NSString*calendars;
@property(nonatomic,copy)NSString*city;
@property(nonatomic,copy)NSString*dealer_code;
@property(nonatomic,copy)NSString*deep_link;
@property(nonatomic,copy)NSString*distributor_code;
@property(nonatomic,copy)NSString*country_code;
@property(nonatomic,copy)NSString*distributor_name;
@property(nonatomic,copy)NSString*end_display_time;
@property(nonatomic,copy)NSString*holiday;
@property(nonatomic,copy)NSString*ID;
@property(nonatomic,copy)NSString*link;
@property(nonatomic,copy)NSString*latitude;
@property(nonatomic,copy)NSString*local;
@property(nonatomic,copy)NSString*local_provider_enum;//1:Junction 2:Dealer 3:OwnerManual 4:Native 5:Video 6:Gis 7:Event
@property(nonatomic,copy)NSString*longitude;
@property(nonatomic,copy)NSString*name;
@property(nonatomic,copy)NSString*open_time;
@property(nonatomic,copy)NSString*phone;
@property(nonatomic,copy)NSString*property_type_name;
@property(nonatomic,copy)NSString*property_value;
@property(nonatomic,copy)NSString*search_content;
@property(nonatomic,copy)NSString*search_keyword;
@property(nonatomic,copy)NSString*start_display_time;
@property(nonatomic,copy)NSString*state;
@property(nonatomic,copy)NSString*title;
@property(nonatomic,copy)NSString*vehicle_model;
@property(nonatomic,copy)NSString*vehicle_year;
@property(nonatomic,copy)NSString*website;
@property(nonatomic,copy)NSString*zip;
@property(nonatomic,copy)NSString*place_id;
@property(nonatomic,copy)NSString*sub_title;
@property(nonatomic,copy)NSString*rating;

@property(nonatomic,strong)NSMutableArray*photos;
@property(nonatomic,strong)NSMutableArray*weekday_text;
@property(nonatomic,copy)NSString*custom_id;
@property(nonatomic,copy)NSString*is_favorite;//1已收藏
@property(nonatomic,copy)NSString*distance;
@property(nonatomic,strong)NSMutableArray*search_response_list;
@property(nonatomic,strong)NSDictionary*vehiclestatus;
@property(nonatomic,copy)NSString*icon;
@property(nonatomic,copy)NSString*user_ratings_total;

@end

NS_ASSUME_NONNULL_END
