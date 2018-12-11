//
//  NearLocation.m
//  TestTopView
//
//  Created by cpd on 8/29/17.
//  Copyright © 2017 cpd. All rights reserved.
//

#import "NearLocation.h"
#import "CommonFunction.h"

@implementation NearLocation

-(id) init
{
    self=[super init];
    if (self)
    {
       
    }
    return self;
}
- (id)initWithImageName:(NSString*)imageName
                  title:(NSString*)title
           withLatitude:(double)latitude
         withLongtitude:(double)longtitude
         withLocationId:(NSString*)locationID
            withAddress:(NSString*)address
{
    self.imageName=imageName;
    self.title=title;
    self.latitude=latitude;
    self.longtitude=longtitude;
    self.locationId=locationID;
    self.address=address;
    return self;
}

-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:[CommonFunction stringwithNullCheck:self.imageName],@"imageName",[CommonFunction stringwithNullCheck:self.title],    @"title",[CommonFunction stringwithNullCheck:[NSString stringWithFormat:@"%f",self.latitude]], @"latitude",[CommonFunction stringwithNullCheck:[NSString stringWithFormat:@"%f",self.longtitude]], @"longtitude",[CommonFunction stringwithNullCheck:self.locationId], @"locationId",[CommonFunction stringwithNullCheck:self.address], @"address", nil];
}

@end
