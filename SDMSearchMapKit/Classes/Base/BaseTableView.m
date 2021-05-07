//
//  BaseTableView.m
//  Icommunity
//
//  Created by CKTrue on 2017/10/30.
//  Copyright © 2017年 njsg. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style refreshStyle:(RefreshStyle)refreshStyle {
    
    if (self = [super initWithFrame:frame style:style]) {
        if (@available(iOS 11.0, *)) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        }
        _refreshStyle = refreshStyle;
        [self addRefreshWithStyle:refreshStyle];
        
    }
    return self;
}

- (void)setRefreshStyle:(RefreshStyle)refreshStyle {
    _refreshStyle = refreshStyle;
    
    [self addRefreshWithStyle:refreshStyle];
}


#pragma mark ---- 刷新加载
- (void)addRefreshWithStyle:(RefreshStyle)style {
    
    self.mj_header = nil;
    self.mj_footer = nil;
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    if (style == RefreshStyleAll || style == RefreshStyleOnlyRefresh) {
        
        MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if ([weakSelf.refreshDelegate respondsToSelector:@selector(goRequestWithIsRefresh:)]) {
                
                [weakSelf.refreshDelegate goRequestWithIsRefresh:YES];
            }
            else {
                [weakSelf.mj_header endRefreshing];
            }
            
            
        }];
        self.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
    }
    if (style == RefreshStyleAll || style == RefreshStyleOnlyLoad) {
        //上拉加载更多
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            if ([weakSelf.refreshDelegate respondsToSelector:@selector(goRequestWithIsRefresh:)]) {
                
                [weakSelf.refreshDelegate goRequestWithIsRefresh:NO];
            }
            else {
                
                [weakSelf.mj_footer endRefreshing];
                
            }
            
        }];
        
    }
    
    
}

-(void)yujiazai{
    [self.mj_footer beginRefreshing];
}
-(UIView*)TabcontenView{
    if (!_TabcontenView) {
   
    _TabcontenView=[[UIView alloc]initWithFrame:self.bounds];
    self.SearchImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    self.SearchImgV.center=CGPointMake(self.center.x, 100);
    [_TabcontenView addSubview:self.SearchImgV];
    self.DescLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.SearchImgV.frame),self.bounds.size.width, 20)];
    [_TabcontenView addSubview:self.DescLabel];
    self.DescLabel.font=[UIFont fontWithName:@"ToyotaTypeW02-Semibold" size:14];
    self.DescLabel.textAlignment=NSTextAlignmentCenter;
    self.DescLabel.textColor=[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1];
    
    [self.SearchImgV setImage:[UIImage imageNamed:@"BigSearch"]];
    [self addSubview:_TabcontenView];
    }
    return _TabcontenView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
