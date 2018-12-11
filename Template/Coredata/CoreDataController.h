//
//  CoreDataController.h
//  Xpress
//
//  Created by Antony Joe Mathew on 11/27/13.
//  Copyright (c) 2013 Antony Joe Mathew, Media Systems Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataController : NSObject{
@private
    NSManagedObjectContext       * managedObjectContext;
    NSManagedObjectModel         * managedObjectModel;
    NSPersistentStoreCoordinator * persistentStoreCoordinator;
}

+ (id)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@property (nonatomic, retain, readonly) NSManagedObjectContext       * managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel         * managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;

@end
