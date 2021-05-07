//
//  SearchView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/13.
//

#import "SearchView.h"

@implementation SearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
   // self.SearchTF=[[UITextField alloc]initWithFrame:CGRectMake(8, 56, SCREEN_WIDTH-16, 48)];
    self.SearchTF.placeholder=@"Search";
    self.SearchTF.layer.cornerRadius=5;
    self.SearchTF.clipsToBounds=YES;
    [self.SearchTF setTextColor:[UIColor blackColor]];
    self.SearchTF.rightViewMode = UITextFieldViewModeAlways;
    self.SearchTF.leftViewMode = UITextFieldViewModeAlways;
   
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 0, 48, 48);
    [self.backBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
      self.backBtn.contentMode = UIViewContentModeCenter;
    UIView*leftV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    [leftV addSubview:self.backBtn];
    self.SearchTF.leftView = leftV;
    
    self.SearchTF.layer.borderColor=[[UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1] CGColor];
    self.SearchTF.layer.borderWidth=0.7;
    self.SearchTF.returnKeyType=UIReturnKeySearch;
    
    
    self.checkPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkPasswordBtn.frame = CGRectMake(0, 0, 48, 48);
    [self.checkPasswordBtn setImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
      self.checkPasswordBtn.contentMode = UIViewContentModeCenter;
    UIView*rightV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    [rightV addSubview:self.checkPasswordBtn];
    self.SearchTF.rightView = rightV;
    
    //button上添加菊花
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.checkPasswordBtn.bounds];
    self.activityIndicator.backgroundColor=[UIColor whiteColor];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.checkPasswordBtn addSubview:self.activityIndicator];
    [self.activityIndicator hidesWhenStopped];
    
}


@end
