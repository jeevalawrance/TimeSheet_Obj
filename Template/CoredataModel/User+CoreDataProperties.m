//
//  User+CoreDataProperties.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/10/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic userEmail;
@dynamic userIsVerified;
@dynamic userName;
@dynamic userSurname;
@dynamic userType;
@dynamic userID;

@end
