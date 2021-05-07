//
//  SearchResultModel.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/23.
//

#import "SearchResultModel.h"
#import "PhotosModel.h"
@implementation SearchResultModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"photos" : [PhotosModel class],@"search_response_list":[SearchResultModel class]};
}



- (void)encodeWithCoder:(NSCoder *)aCoder{
    
  
    [aCoder encodeObject:self.active_flg forKey:@"active_flg"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.place_id forKey:@"place_id"];
    [aCoder encodeObject:self.local_provider_enum forKey:@"local_provider_enum"];
    [aCoder encodeObject:self.calendars forKey:@"calendars"];
    [aCoder encodeObject:self.custom_id forKey:@"custom_id"];
    [aCoder encodeObject:self.local forKey:@"local"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.dealer_code forKey:@"dealer_code"];
    [aCoder encodeObject:self.deep_link forKey:@"deep_link"];
    [aCoder encodeObject:self.distributor_code forKey:@"distributor_code"];
    [aCoder encodeObject:self.country_code forKey:@"country_code"];
    [aCoder encodeObject:self.distributor_name forKey:@"distributor_name"];
    [aCoder encodeObject:self.end_display_time forKey:@"end_display_time"];
    [aCoder encodeObject:self.holiday forKey:@"holiday"];
    [aCoder encodeObject:self.link forKey:@"link"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.open_time forKey:@"open_time"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.property_type_name forKey:@"property_type_name"];
    [aCoder encodeObject:self.property_value forKey:@"property_value"];
    [aCoder encodeObject:self.search_content forKey:@"search_content"];
    [aCoder encodeObject:self.search_keyword forKey:@"search_keyword"];
    [aCoder encodeObject:self.start_display_time forKey:@"start_display_time"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.vehicle_model forKey:@"vehicle_model"];
    [aCoder encodeObject:self.vehicle_year forKey:@"vehicle_year"];
    [aCoder encodeObject:self.website forKey:@"website"];
    [aCoder encodeObject:self.zip forKey:@"zip"];
    [aCoder encodeObject:self.sub_title forKey:@"sub_title"];
    [aCoder encodeObject:self.rating forKey:@"rating"];
    [aCoder encodeObject:self.photos forKey:@"photos"];
    [aCoder encodeObject:self.weekday_text forKey:@"weekday_text"];
    [aCoder encodeObject:self.is_favorite forKey:@"is_favorite"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.vehiclestatus forKey:@"vehiclestatus"];


  
  
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
      _active_flg=[aDecoder decodeObjectForKey:@"active_flg"];
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        _latitude = [aDecoder decodeObjectForKey:@"latitude"];
        _longitude = [aDecoder decodeObjectForKey:@"longitude"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _place_id = [aDecoder decodeObjectForKey:@"place_id"];
        _photos = [aDecoder decodeObjectForKey:@"photos"];
        _weekday_text = [aDecoder decodeObjectForKey:@"weekday_text"];
        _custom_id = [aDecoder decodeObjectForKey:@"custom_id"];
        _is_favorite = [aDecoder decodeObjectForKey:@"is_favorite"];
        
        _rating=[aDecoder decodeObjectForKey:@"rating"];
          _sub_title = [aDecoder decodeObjectForKey:@"sub_title"];
          _zip = [aDecoder decodeObjectForKey:@"zip"];
          _website = [aDecoder decodeObjectForKey:@"website"];
          _vehicle_year = [aDecoder decodeObjectForKey:@"vehicle_year"];
          _vehicle_model = [aDecoder decodeObjectForKey:@"vehicle_model"];
          _title = [aDecoder decodeObjectForKey:@"title"];
          _country_code = [aDecoder decodeObjectForKey:@"country_code"];
          _distributor_name = [aDecoder decodeObjectForKey:@"distributor_name"];
          _end_display_time = [aDecoder decodeObjectForKey:@"end_display_time"];
          
        _holiday=[aDecoder decodeObjectForKey:@"holiday"];
          _link = [aDecoder decodeObjectForKey:@"link"];
          _name = [aDecoder decodeObjectForKey:@"name"];
          _open_time = [aDecoder decodeObjectForKey:@"open_time"];
          _phone = [aDecoder decodeObjectForKey:@"phone"];
          _state = [aDecoder decodeObjectForKey:@"state"];
          _property_type_name = [aDecoder decodeObjectForKey:@"property_type_name"];
          _property_value = [aDecoder decodeObjectForKey:@"property_value"];
          _search_content = [aDecoder decodeObjectForKey:@"search_content"];
          _search_keyword = [aDecoder decodeObjectForKey:@"search_keyword"];
          
        _start_display_time=[aDecoder decodeObjectForKey:@"start_display_time"];
          _address = [aDecoder decodeObjectForKey:@"address"];
          _local_provider_enum = [aDecoder decodeObjectForKey:@"local_provider_enum"];
          _calendars = [aDecoder decodeObjectForKey:@"calendars"];
          _local = [aDecoder decodeObjectForKey:@"local"];
          _city = [aDecoder decodeObjectForKey:@"city"];
          _dealer_code = [aDecoder decodeObjectForKey:@"dealer_code"];
          _deep_link = [aDecoder decodeObjectForKey:@"deep_link"];
          _distributor_code = [aDecoder decodeObjectForKey:@"distributor_code"];
        _distance = [aDecoder decodeObjectForKey:@"distance"];

        _vehiclestatus=[aDecoder decodeObjectForKey:@"vehiclestatus"];
   
    }
    return self;
}
@end
