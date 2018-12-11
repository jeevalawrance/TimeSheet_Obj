//
//  DataLayer.h
//  Xpress
//
//  Created by Antony  11/22/13.
//  Copyright (c) 2013 Antony Joe Mathew, Media Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DataLayer : NSObject


+(DataLayer *) getInstance;


/**
 Save the changes to core date
 */
-(void) saveChangesToCoreData;

 
 /**
 Get the groups to which a user is part of
 
 */


-(User*)createNewUser;
-(User*)getUserDetailsFromUserName:(NSString*)username;

-(PropertList*)createPropertyList;

-(void)insertQuestion:(id)questionObject;
-(void)insertSection:(id)sectionObject;
-(NSArray*)allAnsweredQuestions;
-(void)clearAllRowsFromtable:(NSString*)table;
-(NSArray *) getAllFailedSubmissions;
 -(void)removeMultimedia:(NSString *)fileName;
-(void)insertingNotifications:(NSDictionary*)info;
-(int)settingbadge;
-(void)deleteAllNotifications;
-(void)changingAllNotificationsToUnread;
@end
