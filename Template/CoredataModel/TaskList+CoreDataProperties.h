//
//  TaskList+CoreDataProperties.h
//  ScrollingPOC
//
//  Created by Jeeva on 12/10/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "TaskList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TaskList (CoreDataProperties)

+ (NSFetchRequest<TaskList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *projectId;
@property (nullable, nonatomic, copy) NSString *taskName;
@property (nullable, nonatomic, copy) NSString *userEmail;
@property (nonatomic) int16_t userType;

@end

NS_ASSUME_NONNULL_END
