//
//  Coredatahelper.h
//  HHPOChat
//
//  Created by Anthony on 10/10/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataController.h"

@interface Coredatahelper : NSObject

@property (assign, nonatomic) dispatch_queue_t queueBg;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContextPrivate;
- (NSManagedObjectContext *)managedObjectContextForBGThread;
-(void)enablingCoredata;
+(Coredatahelper *) getInstance;
- (NSManagedObjectContext *)getPrivateMOC;

- (dispatch_queue_t)getNewThread;

@end
