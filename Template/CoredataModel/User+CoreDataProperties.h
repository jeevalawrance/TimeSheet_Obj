//
//  User+CoreDataProperties.h
//  ScrollingPOC
//
//  Created by Jeeva on 12/15/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userEmail;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nonatomic) BOOL userIsVerified;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userSurname;
@property (nonatomic) int16_t userType;
@property (nullable, nonatomic, retain) PropertList *project;

@end

NS_ASSUME_NONNULL_END
