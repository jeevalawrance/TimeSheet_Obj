//
//  TaskList+CoreDataProperties.h
//  ScrollingPOC
//
//  Created by Jeeva on 12/15/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "TaskList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TaskList (CoreDataProperties)

+ (NSFetchRequest<TaskList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *endTime;
@property (nullable, nonatomic, copy) NSString *projectId;
@property (nullable, nonatomic, copy) NSDate *startTime;
@property (nullable, nonatomic, copy) NSString *taskName;
@property (nullable, nonatomic, copy) NSString *userEmail;
@property (nonatomic) int16_t userType;
@property (nullable, nonatomic, retain) PropertList *project;

@end

NS_ASSUME_NONNULL_END
