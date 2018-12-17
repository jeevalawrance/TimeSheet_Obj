//
//  User+CoreDataProperties.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/15/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic userEmail;
@dynamic userID;
@dynamic userIsVerified;
@dynamic userName;
@dynamic userSurname;
@dynamic userType;
@dynamic project;

@end
