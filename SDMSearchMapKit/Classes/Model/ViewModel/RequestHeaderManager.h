//
//  HeaderManager.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestHeaderManager : NSObject
+ (RequestHeaderManager *_Nullable)defaultManager;

-(NSDictionary*)defaultheader;
-(void)SetRequestUrl:(NSString *)requestUrl AccessToken:(NSString*)token;
@end

NS_ASSUME_NONNULL_END
