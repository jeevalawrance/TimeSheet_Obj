//
//  ContactsManager.h
//  HHPOChat
//
//  Created by Anthony on 8/9/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsManager : NSObject
-(id) init;
 +(ContactsManager *) getInstance;
-(void)loadContacts:(void (^)(BOOL success,NSString *message))completion;;
@property(nonatomic,assign) BOOL insertingProgress,insertingCompleted;

@end
