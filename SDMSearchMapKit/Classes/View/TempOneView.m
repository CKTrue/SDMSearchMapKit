//
//  TempOneView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/3/23.
//

#import "TempOneView.h"
#import "SearchResultModel.h"
@implementation TempOneView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10;
    self.RemoteStartBtn.layer.borderColor=[[UIColor colorWithRed:89/255.0 green:89/255.0 blue:91/255.0 alpha:1] CGColor];
    self.RemoteStartBtn.layer.borderWidth=2;
    self.OneScrollV.bounces=NO;
    
    UITapGestureRecognizer*Navigate=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicknavigate)];
    [self.NavigateView addGestureRecognizer:Navigate];

    UITapGestureRecognizer*Share=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickShare)];
    [self.ShareView addGestureRecognizer:Share];

    
    UITapGestureRecognizer*CallPhone=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickPhoneView)];
    [self.PhoneView addGestureRecognizer:CallPhone];
    
}

-(void)setModel:(SearchResultModel *)model{
    _model=model;
    if ([model.is_favorite isEqualToString:@"1"]) {
        [self.FavoritesBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"favorite"] forState:UIControlStateNormal];
    }else{
        [self.FavoritesBtn setImage:[[ToolManager shareManager] creatZhujianImgView:@"nofavorite"] forState:UIControlStateNormal];

    }
    
    if([model.local_provider_enum intValue]==6){
        if(model.weekday_text){
          
            NSString*str= [model.weekday_text componentsJoinedByString:@"\n"];
            self.OpenTimeHeight.constant=[[ToolManager shareManager] sizeLineFeedWithFont:14 text:str textSizeWidth:self.frame.size.width-60];
            self.OpenTimeLabel.text =str;
            if(self.OpenTimeHeight.constant<56){
                self.TimeHeight.constant=56;
            }else{
                self.TimeHeight.constant=[[ToolManager shareManager] sizeLineFeedWithFont:14 text:str textSizeWidth:self.frame.size.width-60]+32;

            }
            
            self.TimeView.hidden=NO;

        }else{
            self.TimeHeight.constant=0;
            self.OpenTimeHeight.constant=0;

            self.TimeView.hidden=YES;

        }
    
    }else{
        
        if(model.open_time){
            self.TimeView.hidden=NO;
            self.OpenTimeHeight.constant=[self LabelHeight:model.open_time];
            if(self.OpenTimeHeight.constant<56){
                self.TimeHeight.constant=56;

            }else{
                self.TimeHeight.constant=[self LabelHeight:model.open_time]+32;

            }

            self.OpenTimeLabel.text=model.open_time;

        }else{
            self.TimeHeight.constant=0;
            self.OpenTimeHeight.constant=0;
            self.TimeView.hidden=YES;

        }
        
        
    }
    
    
    self.RatingLabel.text=self.model.rating;
    if(model.phone){
        self.phoneLabel.text=model.phone;
        UITapGestureRecognizer*CallPhone=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickPhoneView)];
        [self.PhoneView addGestureRecognizer:CallPhone];

    }else{
        self.phoneLabel.text=@"N/A";
    }
    if(model.website.length>0){
        self.LinkLabel.text=[self.model.website componentsSeparatedByString:@"?"].firstObject;
 
        self.LinkHeight.constant=[self LabelHeight:model.website];
        UITapGestureRecognizer*OpenWeb=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickLinkView)];
        [self.LinkView addGestureRecognizer:OpenWeb];

    }else{
        self.LinkLabel.text=@"N/A";

    }
    

    if(model.photos.count==0){
        self.PhotoHeight.constant=30;
        self.PhotoBgView.hidden=YES;
    }else{
        self.PhotoBgView.hidden=NO;
        self.PhotoHeight.constant=360;
        self.PhotosView.dataArray=self.model.photos;


    }

if([_model.local_provider_enum intValue]==6){
    self.SearchKindLabel.text=_model.name;
    [self.CarTypeImgV setImage:[[ToolManager shareManager] creatZhujianImgView:@"place"]];
    if(_model.address){
        self.AddressLabel.text=_model.address;
        

    }else{
        self.AddressLabel.text=_model.name;

    }
}else{

    self.SearchKindLabel.text=_model.title;
    self.AddressLabel.text=_model.sub_title;

}
    NSDictionary*dic=@{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize Size =[self.AddressLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width-160, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                  NSStringDrawingUsesLineFragmentOrigin |
                  NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if(Size.height<20){
        Size.height=20;
    }
    self.OneScrollV.contentSize=CGSizeMake(0, self.LinkHeight.constant+self.OpenTimeHeight.constant+self.PhoneHeight.constant+self.PhoneHeight.constant+Size.height+30);
}
-(CGFloat)LabelHeight:(NSString*)String{
    NSDictionary*dic=@{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize Size =[String boundingRectWithSize:CGSizeMake(self.frame.size.width-60, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                  NSStringDrawingUsesLineFragmentOrigin |
                  NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if(Size.height>50){
        return Size.height;
    }
    return 50;
}

- (IBAction)ClickRemoteAirport:(id)sender {
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(TempOneViewClickAirPortBtn:)]) {
//        [self.delegate TempOneViewClickAirPortBtn:self];
//    }
}

- (IBAction)ClickSendToCar:(id)sender {
//    NSString*name;
//    if ([_model.local_provider_enum intValue]==6) {
//        name=_model.name;
//    }else{
//        name=_model.title;
//
//    }
//    if (!_model.place_id) {
//        _model.place_id=@"ChIJ7SMTt5OOtTURkpz21qWdvtk";
//    }
//    NSDictionary*dic=@{@"poiname":name,@"placeId":_model.place_id,@"latitude":_model.latitude,@"longitude":_model.longitude,@"address":_model.address};
//    [[SDMSwiftToOC sharedInstance] pullingRefreshActionWithDic:dic];
}

- (IBAction)ClickFavirateBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(TempOneViewClickFavoriteBtn:)]) {
        [self.delegate TempOneViewClickFavoriteBtn:self];
    }
}


- (IBAction)ClickCloseBtn:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(TempOneViewClickCloseBtn:)]) {
        [self.delegate TempOneViewClickCloseBtn:self];
    }
}
-(void)ClickPhoneView{
    if(self.model.phone){
NSMutableCharacterSet *charSet=[[NSMutableCharacterSet alloc] init];
[charSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
[charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
[charSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
NSArray*arrayWithNumbers=[self.model.phone componentsSeparatedByCharactersInSet:charSet];
    NSString*numberStr =[arrayWithNumbers componentsJoinedByString:@""];
    if (!numberStr) {
        numberStr=@"";
    }
  
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",numberStr]] options:@{} completionHandler:^(BOOL success) {
        }];
    }
}
-(void)ClickLinkView{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.website] options:@{} completionHandler:^(BOOL success) {
    }];
}

-(void)clicknavigate{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(TempOneViewClickNavigateView:)]) {
        [self.delegate TempOneViewClickNavigateView:_model];
    }
}
-(void)ClickShare{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(TempOneViewClickShareBtn:)]) {
        [self.delegate TempOneViewClickShareBtn:_model];
    }
}

@end
