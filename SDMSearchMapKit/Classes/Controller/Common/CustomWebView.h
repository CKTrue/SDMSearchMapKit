//
//  CustomWebView.h
//  Icommunity
//
//  Created by CKTrue on 2017/11/6.
//  Copyright © 2017年 njsg. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
@interface CustomWebView : BaseViewController
@property(nonatomic,strong)WKWebView*webView;
@property(nonatomic,copy)NSString*urlString;
@property(nonatomic,copy)NSString*titleStr;

@end
