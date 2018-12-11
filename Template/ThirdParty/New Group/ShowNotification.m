//
//  ShowNotification.m
//  HHPOChat
//
//  Created by Anthony on 8/23/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "ShowNotification.h"
#import "CWStatusBarNotification.h"
#import <AudioToolbox/AudioServices.h>


@interface ShowNotification ()
{
    BOOL isCurrentlyShowing;
 }
@property (strong, nonatomic) CWStatusBarNotification *notification;
@property (strong, nonatomic) UIView *viewNotification;


@end

static ShowNotification *sharedInstance = nil;

@implementation ShowNotification


+(ShowNotification *) getInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];

        
    });
    return sharedInstance;
}

-(id) init
{
    self=[super init];
    if (self)
    {
        self.notification = [CWStatusBarNotification new];
        
        self.notification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

        self.notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
        self.viewNotification = [[[NSBundle mainBundle] loadNibNamed:@"MessageNotification" owner:self options:nil] lastObject];
        self.notification.customView =self.viewNotification;
        
     }
    
    return self;
}

-(void)showNotiifcationParams:(NSDictionary*)params withCompletion:(void (^)(id info))completion{
 
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);

   // UIView *notiView = [[[NSBundle mainBundle] loadNibNamed:@"MessageNotification" owner:self options:nil] lastObject];
    [self setUpView:self.viewNotification params:params];

    [self.notification displayNotificationWithView:self.viewNotification forDuration:1.5];

    self.notification.notificationTappedBlock = ^(void) {
        NSLog(@"notification tapped");
        // more code here
       
        
        
    };
}

-(void)setUpView:(UIView*)view params:(NSDictionary*)params
{
    UIImageView *imgDP = [view viewWithTag:1];
    UILabel *lblFletter = [view viewWithTag:2];
    UILabel *lblName = [view viewWithTag:3];
    UILabel *lblMessage = [view viewWithTag:4];
   
    imgDP.layer.cornerRadius = imgDP.frame.size.height/2.;
    lblFletter.layer.cornerRadius = imgDP.layer.cornerRadius;
    
//    lblName.text = [message.chat getChatTitle];
//    NSString *fletter=[[CommonFunction getInstance] getFirstLetterFromName:lblName.text];
//    lblFletter.text = fletter;
//     {
//         id msg_txt = [[CommonFunction getInstance] getCellTextFromMessage:message shouldReturnPlainText:NO withReadStatus:NO];
//         if ([msg_txt isKindOfClass:[NSString class]]) {
//             lblMessage.text = msg_txt;
//         }
//         else if([msg_txt isKindOfClass:[NSMutableAttributedString class]])
//         {
//             NSMutableAttributedString *atr_str_ = (NSMutableAttributedString *)msg_txt;
//             [atr_str_ addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, atr_str_.string.length)];
//             lblMessage.attributedText = msg_txt;
//         };
//    }
//    //
//    NSManagedObjectID *msgId =message.objectID;
//    dispatch_async([COREDATAHELPER queueBg], ^{
//
//        __block UIColor *bgColr;
//        __block UIImage *image;
//        NSManagedObjectContext *backgroundMOC = [COREDATAHELPER managedObjectContextForBGThread];
//
//        [backgroundMOC performBlock:^{
//
//
//
//            HHPOCHAT_Messages *msgInThread =[backgroundMOC objectWithID:msgId];
//            if ([msgInThread isKindOfClass:[HHPOCHAT_Messages class]])
//            {
//                //  NSLog(@"group id****--%@    name---%@", group_id_, group_name_);
//
//
//                bgColr=[[CommonFunction getInstance] colorFromChatObject:message.chat andText:fletter];
//                image =[message.chat getChatFullImage];
//                if (!image) {
//                    image =[message.chat getChatImage];
//                }
//                dispatch_async( dispatch_get_main_queue(), ^{
//                    // Add code here to update the UI/send notifications based on the
//                    // results of the background processing
//                    imgDP.backgroundColor=bgColr;
//                    imgDP.image = image;
//
//                    if(image==nil)
//
//                    {
//                        lblFletter.hidden = FALSE;
//
//                    }
//                    else
//                    {
//                        lblFletter.hidden = TRUE;
//
//
//                    }
//
//                });
//
//            }
//
//        }];
//
//
//    });
//
//
//    return;
//
    
    


}
@end
