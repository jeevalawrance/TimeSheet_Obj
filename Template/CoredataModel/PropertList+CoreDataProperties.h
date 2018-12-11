//
//  PropertList+CoreDataProperties.h
//  ScrollingPOC
//
//  Created by Jeeva on 12/10/18.
//  Copyright © 2018 CPD. All rights reserved.
//
//

#import "PropertList+CoreDataClass.h"


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

@end

NS_ASSUME_NONNULL_END
