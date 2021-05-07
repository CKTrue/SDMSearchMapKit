//
//  ChooseImgView.m
//  Icommunity
//
//  Created by CKTrue on 2017/11/28.
//  Copyright © 2017年 njsg. All rights reserved.
//

#import "ChooseImgView.h"
#import <Photos/Photos.h>
#import "PhotosModel.h"
#import "UIImageView+WebCache.h"
@interface ChooseImgView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) UIImageView *touchImageView;

@end
@implementation ChooseImgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    _dataArray=[[NSMutableArray alloc]init];

}
-(void)CreateUI{
    if(self.photoCollection){
        [self.photoCollection removeFromSuperview];
        self.photoCollection=nil;
    }
    
    [self creatPhotoColletcion];
}
-(void)setDataArray:(NSMutableArray*)dataArray{
    
    [self CreateUI];
   // self.isScrollStoped=1;
    _dataArray=dataArray;
}
#pragma mark ======collection的协议代理
static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

- (void)creatPhotoColletcion{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(SCREEN_WIDTH,310);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing=0;
    self.photoCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,320) collectionViewLayout:layout];
    self.photoCollection.showsHorizontalScrollIndicator = NO;
    self.photoCollection.delegate = self;
    self.photoCollection.dataSource = self;
    self.photoCollection.backgroundColor = [UIColor whiteColor];
        self.photoCollection.scrollEnabled = YES;
        self.photoCollection.pagingEnabled = YES;
    [self.photoCollection registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kPhotoCellIdentifier];
    [self addSubview:self.photoCollection];
    
    
}
#pragma mark -- UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark --- item 的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    PhotosModel*model=self.dataArray[indexPath.row];
    NSString*string=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@",model.photo_reference,GoogleKey];
    [cell.photoIMG sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
  //cell.photoIMG =[self addimageViewIndex:indexPath.row withUrl:[NSURL URLWithString:string]];

    return cell;
}

#pragma mark --- 点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell*cell=(PhotoCollectionViewCell*)[self.photoCollection cellForItemAtIndexPath:indexPath];
    [self touchImageAction:cell.photoIMG];
    
}

-(UIImageView*)addimageViewIndex:(NSInteger)index withUrl:(NSURL*)imgUrl{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5;
    imageView.layer.borderWidth = 0.5;
    CGColorRef color=BaseViewColor.CGColor;
    imageView.layer.borderColor = color;
    
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *touchImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageAction:)];
    touchImage.numberOfTapsRequired = 1;
    touchImage.numberOfTouchesRequired = 1;
    touchImage.delegate=self;
    [imageView addGestureRecognizer:touchImage];
    
    //赋值
    [imageView sd_setImageWithURL:imgUrl placeholderImage:[ToolManager shareManager].placeholderImage];
    // (color);
    return imageView;
}
- (void)touchImageAction:(UIImageView*)gesture
{
    // if ([self.delegate respondsToSelector:@selector(QuanDetailImgViewTouchSomeImage:)])
    // {
    //     [self.delegate QuanDetailImgViewTouchSomeImage:(UIImageView *)gesture.view];
    //  }
    
    SDPhotoBrowser *browser = [SDPhotoBrowser new];
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.dataArray.count;
    self.touchImageView =gesture;
    browser.currentImageIndex = self.touchImageView.tag;
    browser.delegate = self;
    [browser show];
}

#pragma mark  --- SDPhotoBrowser代理方法
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.touchImageView.image;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    PhotosModel*model=self.dataArray[index];
    NSString*string=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@",model.photo_reference,GoogleKey];
    return [NSURL URLWithString:string];
}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    _isScrollStoped=0;
//
//}
//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    _isScrollStoped=0;
//
//}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//   if (scrollView==self.photoCollection) {
//       // 停止类型1、停止类型2
//       BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
//       if (scrollToScrollStop) {
//           _isScrollStoped=1;
//       }
//   }
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//   if (scrollView==self.photoCollection) {
//
//       if (!decelerate) {
//           // 停止类型3
//           BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
//           if (dragToDragStop) {
//               self.isScrollStoped=1;
//           }
//       }
//
//   }
//}

@end
