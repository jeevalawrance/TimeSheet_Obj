//
//  ShowNotification.h
//  HHPOChat
//
//  Created by Anthony on 8/23/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowNotification : NSObject
+(ShowNotification *) getInstance;
-(void)showNotiifcationParams:(NSDictionary*)params withCompletion:(void (^)(id info))completion;

//-(void)showNotiifcationWithMessageObject:(HHPOCHAT_Messages*)message withCompletion:(void (^)(id info))completion;
@end
