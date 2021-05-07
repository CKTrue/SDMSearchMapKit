//
//  CALayer+XibBorderColor.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/22.
//

#import "CALayer+XibBorderColor.h"
@implementation CALayer (XibBorderColor)
-(void)setBorderColorWithUIColor:(UIColor*)borderColorWithUIColor{

    self.borderColor = borderColorWithUIColor.CGColor;

}
-(UIColor*)borderColorWithUIColor{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
