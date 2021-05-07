//
//  VoiceSpeechView.m
//  ToyotaSearch
//
//  Created by Kyle Li on 2021/4/8.
//

#import "VoiceSpeechView.h"
#import "HSpeechRecognizer.h"
@implementation VoiceSpeechView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    UILongPressGestureRecognizer*press=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(VoiceRecord:)];
    press.delegate=self;
    [self.VoiceStart addGestureRecognizer:press];
    [[HSpeechRecognizer share] requestSpeechAuthorization:^(BOOL isAuthorized) {
            
    }];
}
-(void)VoiceRecord:(UIGestureRecognizer*)gesture{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        [[HSpeechRecognizer share] startRecordSpeech:^(NSString *speakingText) {
      if (self.delegate&&[self.delegate respondsToSelector:@selector(VoiceTextChange:)]) {
        [self.delegate VoiceTextChange:speakingText];
                        }
                   }];
    }
    if (gesture.state==UIGestureRecognizerStateChanged) {
        NSLog(@"2");
    }
    if (gesture.state==UIGestureRecognizerStateEnded) {
        NSLog(@"3");
      [[HSpeechRecognizer share] endRecordSpeech];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(VoiceTextEnd)]) {
          [self.delegate VoiceTextEnd];
                          }
            

    }
    if (gesture.state==UIGestureRecognizerStateCancelled) {
        NSLog(@"4");
        //alertShowNOcancelBtn(@"",@"Speech Unrecognized");

    }
    if (gesture.state==UIGestureRecognizerStateFailed) {
       // alertShowNOcancelBtn(@"",@"Speech Unrecognized");
        
        NSLog(@"5");
    }
//    switch (gesture.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//
//            [[HSpeechRecognizer share] startRecordSpeech:^(NSString *speakingText) {
//                if (self.delegate&&[self.delegate respondsToSelector:@selector(VoiceTextChange:)]) {
//                    [self.delegate VoiceTextChange:speakingText];
//                }
//           }];
//        }
//            break;
//
//        case UIGestureRecognizerStateEnded:
//        {
//
//
//            [[HSpeechRecognizer share] endRecordSpeech];
//
//
//        }
//            break;
//
//        default:
//            break;
//    }
}
@end
