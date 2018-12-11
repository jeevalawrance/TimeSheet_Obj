//
//  CoreDataController.m
//  Xpress
//
//  Created by Antony Joe Mathew on 11/27/13.
//  Copyright (c) 2013 Antony Joe Mathew, Media Systems Inc. All rights reserved.
//

#import "CoreDataController.h"


#define DatbaseName              @"TimeSheet.sqlite"
#define DataModelName             @"TimeSheet"

@interface CoreDataController ()

@end

@implementation CoreDataController

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static CoreDataController *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance                  = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Core Data stack

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    
    NSError *error                        = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    if (objectContext != nil)
    {
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            abort();
        }
    }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext                = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:DataModelName ofType:@"momd"];
    if( !path ) path = [[NSBundle mainBundle] pathForResource:DataModelName ofType:@"mom"];
    
    NSURL *momURL = [NSURL fileURLWithPath:path];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
   /* NSURL *storeURL                         = [[self applicationDocumentsDirectory]
                                               URLByAppendingPathComponent:@"XpressFIFA.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newDataUpload-5" ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, could copy preloaded data");
        }
    }*/
    NSURL *storeURL                         = [[self applicationDocumentsDirectory]
                                               URLByAppendingPathComponent:DatbaseName];
    
    
    NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
    [pragmaOptions setObject:@"NORMAL" forKey:@"locking_mode"];
    [pragmaOptions setObject:@"DELETE" forKey:@"journal_mode"];
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             pragmaOptions, NSSQLitePragmasOption, nil];
    
    /* NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
     
     [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
     
     [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];*/
    
    NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Handle error
        NSLog(@"Problem with PersistentStoreCoordinator: %@",error);
    }
    return persistentStoreCoordinator;
}

@end
