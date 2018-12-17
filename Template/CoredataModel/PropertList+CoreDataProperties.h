//
//  PropertList+CoreDataProperties.h
//  ScrollingPOC
//
//  Created by Jeeva on 12/15/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import ".PropertList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PropertList (CoreDataProperties)

+ (NSFetchRequest<PropertList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longtitude;
@property (nullable, nonatomic, copy) NSString *placeName;
@property (nullable, nonatomic, copy) NSString *projectName;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nonatomic) int16_t userType;
@property (nullable, nonatomic, retain) NSSet<User *> *user;
@property (nullable, nonatomic, retain) TaskList *task;

@end

@interface PropertList (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet<User *> *)values;
- (void)removeUser:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
