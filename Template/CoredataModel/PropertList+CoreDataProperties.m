//
//  PropertList+CoreDataProperties.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/15/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "PropertList+CoreDataProperties.h"

@implementation PropertList (CoreDataProperties)

+ (NSFetchRequest<PropertList *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"PropertList"];
}

@dynamic address;
@dynamic latitude;
@dynamic longtitude;
@dynamic placeName;
@dynamic projectName;
@dynamic userID;
@dynamic userType;
@dynamic user;
@dynamic task;

@end
