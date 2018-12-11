//
//  DataLayer.m
//  Xpress
//
//  Created by Antony  11/22/13.
//  Copyright (c) 2013 Antony Joe Mathew, Media Systems Inc. All rights reserved.
//

#import "DataLayer.h"
#import <CoreData/CoreData.h>
#import "URLConstants.h"
#import "Coredatahelper.h"


static DataLayer *sharedInstance = nil;

@interface DataLayer(){
     NSManagedObjectContext *context;
}
@end


@implementation DataLayer

-(id) init{
    self=[super init];
    if (self) {
         context=[COREDATAHELPER managedObjectContext];
        
    }
    return self;
}

+(DataLayer *) getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataLayer alloc] init];
        
        // Do any other initialisation stuff here
        
    });
    return sharedInstance;
}

#pragma mark -
#pragma mark save core data changes


-(void) saveChangesToCoreData{
    
     NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save changes: %@", [error localizedDescription]);
    }
    
}




#pragma mark -
#pragma mark Add contact
-(void)deleteAllNotifications
{}

-(User*)createNewUser
{
    User *obj;
//    NSEntityDescription *entity     = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    obj                 = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
//    obj.userName    = username;
//    obj.userSurname = surname;
//    obj.userType     = type;
//    obj.userEmail         = email;
//    obj.userIsVerified = 0;

    return obj;
//    [self saveChangesToCoreData];
}

-(User*)getUserDetailsFromUserName:(NSString*)username
{
    User *obj;
    NSEntityDescription *entity     = [NSEntityDescription
                                       entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];   
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"userEmail == %@",username];
    
    [fetchRequest setPredicate:predicate];
    NSError *error;

    NSArray *contactListArray=[context executeFetchRequest:fetchRequest error:&error];
    if (contactListArray.count>0)
    {
        obj= [contactListArray objectAtIndex:0];
    }
    
    return obj;
}

-(NSArray *) getAllFailedSubmissions
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Falcon" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isConfirmedSubmission == 1 AND isUploadedCompletely==0"];
    [fetchRequest setPredicate:predicate];
    //    NSSortDescriptor *sortDescriptor    = [NSSortDescriptor sortDescriptorWithKey:@"last_activity_time" ascending:FALSE];
    //
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSArray *contactListArray=[context executeFetchRequest:fetchRequest error:&error];
    
    
    return contactListArray;
    
}
-(void)clearAllRowsFromtable:(NSString*)table
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:table];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
}
/*-(FNotifications*)notificationFromDictionary:(NSDictionary*)info
{
    FNotifications *notfn;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FNotifications" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error;
    if ([info valueForKey:@"latitude"]==NULL)
    {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"falconID == %@ AND notificationID== %@ AND falconIdsForMultiple == %@",[NSString stringWithFormat:@"%@",[info valueForKey:@"falconID"]],[NSString stringWithFormat:@"%@",[info valueForKey:@"notificationId"]],[info valueForKey:@"falconIds"]];
    
    [fetchRequest setPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"notificationDetails == %@",[CommonFunction stringFromDictionary:[CommonFunction dictionaryByReplacingNullsWithStrings:info]]];
        
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSArray *contactListArray=[context executeFetchRequest:fetchRequest error:&error];
     if (contactListArray.count>0)
    {
        notfn= [contactListArray objectAtIndex:0];
    }
    else
    {
        notfn=[NSEntityDescription insertNewObjectForEntityForName:@"FNotifications" inManagedObjectContext:context];
        notfn.isRead=[NSNumber numberWithBool:FALSE];

        // sectn.sectionId=[NSNumber numberWithInt:[sectionID intValue]];
    }
    return notfn;
}
-(void)insertingNotifications:(NSDictionary*)info

{
 
 
    FNotifications *notfn=[self notificationFromDictionary:info];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    
    notfn.dateAdded=[dateFormatter dateFromString:[info valueForKey:@"createdDate"]];

    
    notfn.notificationDetails=[CommonFunction stringFromDictionary:[CommonFunction dictionaryByReplacingNullsWithStrings:info]] ;
    if ([info valueForKey:@"latitude"]==NULL)
    {
        notfn.notificationID=[NSString stringWithFormat:@"%@",[info valueForKey:@"notificationId"]];
        if ([info valueForKey:@"falconIds"]) {
            notfn.falconIdsForMultiple=[info valueForKey:@"falconIds"];
        }
        if ([info valueForKey:@"falconID"])
        {
            notfn.falconID=[NSString stringWithFormat:@"%@",[info valueForKey:@"falconID"]];
        }
        else
        {
            notfn.falconID=@"";
            
        }

    }
    else
    {
        notfn.isBringThis=[NSNumber numberWithBool:TRUE];
       notfn.notificationID=[NSString stringWithFormat:@"%@",[info valueForKey:@"Id"]];
    }
//isBringThis
    
 //   notfn.dateAdded=[dateFormatter dateFromString:@"9/1/2014 11:12:12 AM"];

  //  [dateFormatter setDateFormat:@"dd-MMM-yyyy HH:mm:ss a"];

    
    notfn.message=[NSString stringWithFormat:@"%@",[[info objectForKey:@"aps"]valueForKey:@"alert"]];
    notfn.dateUpdated=[NSDate date];
 
  
    
    
}
-(void)changingAllNotificationsToUnread
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FNotifications"
                                              inManagedObjectContext:appDelegate.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRead ==0"];
    [request setPredicate:predicate];
    
    [request setEntity:entity];
    NSError *error = nil;
    
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    for (FNotifications *fn in result) {
        fn.isRead=[NSNumber numberWithBool:TRUE];
    }
    [self saveChangesToCoreData];
}*/
-(int)settingbadge
{
    return 0;
}
/*-(Falcon *)questionObjectFromId:(NSString*)questionID
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"QuizQuestions" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"questionID == %@",questionID];
    [fetchRequest setPredicate:predicate];
    //    NSSortDescriptor *sortDescriptor    = [NSSortDescriptor sortDescriptorWithKey:@"last_activity_time" ascending:FALSE];
    //
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSArray *contactListArray=[context executeFetchRequest:fetchRequest error:&error];
    
    if (contactListArray.count>0) {
        return [contactListArray objectAtIndex:0];
    }
    return [NSEntityDescription insertNewObjectForEntityForName:@"QuizQuestions" inManagedObjectContext:context];
    
}*/
-(NSArray *)allAnsweredQuestions
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"QuizQuestions" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"updatedDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAnswered == 1 AND isSubmitted == 0"];
    
    [fetchRequest setPredicate:predicate];
    return [context executeFetchRequest:fetchRequest error:&error];
    
}

/*-(Falcon *)sectionFromId:(NSString*)sectionID

{
    Falcon *sectn;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"QuizSections" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionId == %@",sectionID];
    
    [fetchRequest setPredicate:predicate];
    //    NSSortDescriptor *sortDescriptor    = [NSSortDescriptor sortDescriptorWithKey:@"last_activity_time" ascending:FALSE];
    //
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSArray *contactListArray=[context executeFetchRequest:fetchRequest error:&error];
   
    if (contactListArray.count>0) {
        sectn= [contactListArray objectAtIndex:0];
    }
    else
    {
        sectn=[NSEntityDescription insertNewObjectForEntityForName:@"QuizSections" inManagedObjectContext:context];
       // sectn.sectionId=[NSNumber numberWithInt:[sectionID intValue]];
    }
    return sectn;
    
}

*/
 



-(int)getMessageCount:(NSString *)type{
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Message" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat: @"(content_type == %s)",type]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    return (int)[context countForFetchRequest:fetchRequest error:&error];
    
}



-(void)removeMultimedia:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    if ([NSData dataWithContentsOfFile:filePath]==NULL||[fileName isEqualToString:@""] || fileName==NULL) {
        return;
    }
    
    
    NSError *error;
    BOOL success =[fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"%@ deleted ",fileName);
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

#pragma mark -
#pragma mark Check for null before inserting into dictionary

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}


@end
