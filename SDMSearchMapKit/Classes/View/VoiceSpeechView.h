//
//  VoiceSpeechView.h
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VoiceSpeechView;
@protocol VoiceSpeechViewDelegate <NSObject>

-(void)VoiceTextChange:(NSString*)changetext;
-(void)VoiceTextEnd;

@end
@interface VoiceSpeechView : UIView<VoiceSpeechViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *VoiceStart;
@property(nonatomic,assign)id<VoiceSpeechViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
