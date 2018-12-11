//
//  User+CoreDataProperties.h
//  ScrollingPOC
//
//  Created by Jeeva on 12/10/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userEmail;
@property (nonatomic) BOOL userIsVerified;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userSurname;
@property (nonatomic) int16_t userType;
@property (nullable, nonatomic, copy) NSString *userID;

@end

NS_ASSUME_NONNULL_END
