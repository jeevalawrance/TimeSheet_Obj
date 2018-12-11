//
//  Coredatahelper.m
//  HHPOChat
//
//  Created by Anthony on 10/10/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "Coredatahelper.h"
#import "CoreDataController.h"
#import "URLConstants.h"
#import "DataLayer.h"


static Coredatahelper *sharedInstance = nil;

@implementation Coredatahelper


+(Coredatahelper *) getInstance
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
        _queueBg = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        
    }
    
    return self;
}

-(void)enablingCoredata
{
    
    
    CoreDataController* coredataVC = [CoreDataController sharedInstance];
    _managedObjectContext=[coredataVC managedObjectContext];
    
    dispatch_queue_t queue = self.queueBg;
    
    dispatch_async(queue, ^{
        NSManagedObjectContext *mainMOC=self.managedObjectContext;
        
        _managedObjectContextPrivate = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [_managedObjectContextPrivate setParentContext:mainMOC];
        //  [_managedObjectContextPrivate automaticallyMergesChangesFromParent];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
            
            
            [_managedObjectContextPrivate setAutomaticallyMergesChangesFromParent:TRUE];
            
            
        }
        
        //
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // do work here
            
            if (SYSTEM_VERSION_LESS_THAN(@"10.")) {
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(managedObjectContextDidSaveForOsLessthan10:)
                                                             name:NSManagedObjectContextDidSaveNotification
                                                           object:nil];
                
                
            }
            
            
            
        });
    });
    
}
- (NSManagedObjectContext *)getPrivateMOC {
    
    
    // [_managedObjectContextPrivate refreshAllObjects];
    
    
    NSManagedObjectContext *mainMOC=self.managedObjectContext;
    
    NSManagedObjectContext *mocPrivate = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [mocPrivate setParentContext:mainMOC];
    //  [_managedObjectContextPrivate automaticallyMergesChangesFromParent];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        
        
        [mocPrivate setAutomaticallyMergesChangesFromParent:TRUE];
        
        
    }
    else if (SYSTEM_VERSION_LESS_THAN(@"10.")) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(managedObjectContextDidSaveForOsLessthan10:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
        
        
    }
    
    return mocPrivate;
}
- (dispatch_queue_t)getNewThread
{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
}

- (NSManagedObjectContext *)managedObjectContextForBGThread {
    
    
    // [_managedObjectContextPrivate refreshAllObjects];
    return _managedObjectContextPrivate;
    
}
- (void)managedObjectContextDidSaveForOsLessthan10:(NSNotification *)notification
{
    NSManagedObjectContext *sender = (NSManagedObjectContext *)[notification object];
    
    if ((sender != self.managedObjectContext) &&
        (sender.persistentStoreCoordinator == self.managedObjectContext.persistentStoreCoordinator))
    {
        //  NSLog(@"%@: %@ - Merging changes into mainThreadManagedObjectContext", THIS_FILE, THIS_METHOD);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different
            for (NSManagedObject *object in [notification userInfo][NSUpdatedObjectsKey]) {
                [[self.managedObjectContext objectWithID:[object objectID]] willAccessValueForKey:nil];
            }
            [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:notification waitUntilDone:YES];
            
            //            [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
            // [self mainThreadManagedObjectContextDidMergeChanges];
        });
    }
}
-(void)privateUsage
{
    /*
    dispatch_async( [COREDATAHELPER queueBg], ^{
        // Add code here to do background processing
        //
        //
        
        
        NSManagedObjectContext *backgroundMOC = [COREDATAHELPER managedObjectContextForBGThread];
        [backgroundMOC performBlock:^{
            
            //
            // OPERATIONS
            //
            
            [[DataLayer getInstance] saveContext:backgroundMOC];
            [[COREDATAHELPER managedObjectContext] performBlock:^{
                NSError *error;
                if (![[COREDATAHELPER managedObjectContext] save:&error])
                {
                    // NSLog(@"Final friendRequestAccepted --->%@",[NSThread currentThread]);
                }
                else
                {
                    //  NSLog(@"Final friendRequestAccepted error--->%@",error);
                    
                }
            }];////////////
            
            
        }];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            
        });
    });
    
  */
    
}
@end
