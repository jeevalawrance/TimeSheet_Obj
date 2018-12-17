//
//  TaskList+CoreDataProperties.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/15/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "TaskList+CoreDataProperties.h"

@implementation TaskList (CoreDataProperties)

+ (NSFetchRequest<TaskList *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TaskList"];
}

@dynamic endTime;
@dynamic projectId;
@dynamic startTime;
@dynamic taskName;
@dynamic userEmail;
@dynamic userType;
@dynamic project;

@end
