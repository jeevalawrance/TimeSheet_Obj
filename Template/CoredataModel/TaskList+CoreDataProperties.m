//
//  TaskList+CoreDataProperties.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/10/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "TaskList+CoreDataProperties.h"

@implementation TaskList (CoreDataProperties)

+ (NSFetchRequest<TaskList *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TaskList"];
}

@dynamic projectId;
@dynamic taskName;
@dynamic userEmail;
@dynamic userType;

@end
