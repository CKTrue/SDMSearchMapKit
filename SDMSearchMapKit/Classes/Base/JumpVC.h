//
//  JumpVC.h
//  Icommunity
//
//  Created by CKTrue on 2017/11/8.
//  Copyright © 2017年 njsg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SearchResultModel;
#import "CustomWebView.h"
@interface JumpVC : NSObject
+(void)JumpViewControllerWithGetModel:(SearchResultModel*)model TitleName:(NSString*)name WithViewController:(UINavigationController*)ViewController;
+(void)JUmpViewControllerWithIndex:(NSInteger)index TittleName:(NSString*)name WithViewController:(UIViewController*)ViewController;
+(void)NewJUmpViewControllerWithIndex:(NSInteger)index TittleName:(NSString*)name WithViewController:(UIViewController*)ViewController;

@end
