//
//  JumpVC.m
//  Icommunity
//
//  Created by CKTrue on 2017/11/8.
//  Copyright © 2017年 njsg. All rights reserved.
//

#import "JumpVC.h"
#import "SearchResultModel.h"
@implementation JumpVC
+(void)JumpViewControllerWithGetModel:(SearchResultModel *)valuemodel TitleName:(NSString*)name WithViewController:(UINavigationController*)ViewController{
    NSData *jsonData = [valuemodel.deep_link dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    switch ([dic[@"IOS"] integerValue]) {
        
            case 1:
        {
           // MyServiceVC*vc=[[MyServiceVC alloc]init];
            SDMFindMyCar*vc=[[SDMFindMyCar alloc]init];
            [ViewController pushViewController:vc animated:NO];
        }
            
            break;
            
  
  
        default:
        {
           // WindowShow1(@"此功能本版本未开放,请先更新版本");
            
        }
            break;
    }


}

@end
