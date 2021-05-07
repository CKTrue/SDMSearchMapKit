//
//  ChooseImgView.h
//  Icommunity
//
//  Created by CKTrue on 2017/11/28.
//  Copyright © 2017年 njsg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCollectionViewCell.h"
#import "SDPhotoBrowser.h"
@class ChooseImgView;
@protocol ChooseImgViewDelegate<NSObject>
-(void)PhotoModeIsCameraWithView:(NSMutableArray *)Array;
@end
@interface ChooseImgView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
@property(nonatomic,strong)UICollectionView*photoCollection;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSIndexPath *myIndex;
@property(nonatomic,assign)id<ChooseImgViewDelegate>delegate;
@property(nonatomic,assign)NSInteger isScrollStoped;//0:滑动 1:停止

@end
