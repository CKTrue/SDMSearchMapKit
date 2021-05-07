//
//  SDMLandingView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/21.
//

#import "SDMLandingView.h"

@implementation SDMLandingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer*tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickCoffeeView)];
    [self.CoffeeView addGestureRecognizer:tap1];
    self.CoffeeView.layer.borderColor=[[UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1] CGColor];
    UITapGestureRecognizer*tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickRestaurantsView)];
    [self.RestaurantsView addGestureRecognizer:tap2];
    self.RestaurantsView.layer.borderColor=[[UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1] CGColor];


    UITapGestureRecognizer*tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickGasView)];
    [self.GasView addGestureRecognizer:tap3];
    self.GasView.layer.borderColor=[[UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1] CGColor];


    UITapGestureRecognizer*tap4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickGroceriesView)];
    [self.GroceriesView addGestureRecognizer:tap4];
    self.GroceriesView.layer.borderColor=[[UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1] CGColor];


}
-(void)ClickCoffeeView{
    if (self.deleagte&&[self.deleagte respondsToSelector:@selector(ClickCoffeeView:)]) {
        [self.deleagte ClickCoffeeView:self];
    }
}
-(void)ClickRestaurantsView{
    if (self.deleagte&&[self.deleagte respondsToSelector:@selector(ClickRestaurantsView:)]) {
        [self.deleagte ClickRestaurantsView:self];
    }
}
-(void)ClickGasView{
    if (self.deleagte&&[self.deleagte respondsToSelector:@selector(ClickGasView:)]) {
        [self.deleagte ClickGasView:self];
    }
}
-(void)ClickGroceriesView{
    if (self.deleagte&&[self.deleagte respondsToSelector:@selector(ClickGroceriesView:)]) {
        [self.deleagte ClickGroceriesView:self];
    }
}
@end
