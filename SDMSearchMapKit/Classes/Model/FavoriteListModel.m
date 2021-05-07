//
//  FavoriteListModel.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/1.
//

#import "FavoriteListModel.h"

@implementation FavoriteListModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.place_id forKey:@"place_id"];
    [aCoder encodeObject:self.provider forKey:@"provider"];
    [aCoder encodeObject:self.register_time forKey:@"register_time"];
    [aCoder encodeObject:self.custom_id forKey:@"custom_id"];
    [aCoder encodeBool:self.delfavorite forKey:@"delfavorite"];

    
   
  
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
      _content=[aDecoder decodeObjectForKey:@"content"];
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        
        _latitude = [aDecoder decodeObjectForKey:@"latitude"];
        _longitude = [aDecoder decodeObjectForKey:@"longitude"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _place_id = [aDecoder decodeObjectForKey:@"place_id"];
        _provider = [aDecoder decodeObjectForKey:@"provider"];
        _register_time = [aDecoder decodeObjectForKey:@"register_time"];
        _custom_id = [aDecoder decodeObjectForKey:@"custom_id"];
        _delfavorite = [aDecoder decodeObjectForKey:@"delfavorite"];

   
    }
    return self;
}
@end
