//
//  BaseTableView.h
//  Icommunity
//
//  Created by CKTrue on 2017/10/30.
//  Copyright © 2017年 njsg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BaseTableViewDelegate <NSObject>

- (void)goRequestWithIsRefresh:(BOOL)isRefresh;

@end

typedef enum : NSUInteger {
    RefreshStyleNone,  //不要刷新加载
    RefreshStyleAll,   //需要刷新加载
    RefreshStyleOnlyLoad,  //只需要加载
    RefreshStyleOnlyRefresh  //只需要刷新
} RefreshStyle;


@interface BaseTableView : UITableView
@property (nonatomic, strong) UIView*TabcontenView;
@property (nonatomic, strong) UIImageView*SearchImgV;
@property (nonatomic, strong) UILabel*DescLabel;

@property (nonatomic, weak) id<BaseTableViewDelegate> refreshDelegate;

/*
 *  刷新加载的风格  需要的时候赋值即可
 */

@property (nonatomic, assign) RefreshStyle refreshStyle;

/*
 *  需调用此方法才能添加刷新加载
 */

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style refreshStyle:(RefreshStyle)refreshStyle;
-(void)yujiazai;

@end
