//
//  HistoryModel.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/2.
//

#import "HistoryModel.h"

@implementation HistoryModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.keyword forKey:@"keyword"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.sub_title forKey:@"sub_title"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.provider forKey:@"provider"];
    [aCoder encodeObject:self.custom_id forKey:@"custom_id"];

    
   
  
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
      _keyword=[aDecoder decodeObjectForKey:@"keyword"];
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        
        _sub_title = [aDecoder decodeObjectForKey:@"sub_title"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _provider = [aDecoder decodeObjectForKey:@"provider"];
        _custom_id = [aDecoder decodeObjectForKey:@"custom_id"];

   
    }
    return self;
}
@end
