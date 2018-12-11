//
//  NearLocation.h
//  TestTopView
//
//  Created by cpd on 8/29/17.
//  Copyright © 2017 cpd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearLocation : NSObject

@property (nonatomic,strong) NSString *imageName;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *address;
@property (assign)        double latitude;
@property (assign)        double longtitude;
@property (nonatomic,strong)      NSString* locationId;

- (id)initWithImageName:(NSString*)imageName
                  title:(NSString*)title
   withLatitude:(double)latitude
           withLongtitude:(double)longtitude
         withLocationId:(NSString*)locationID
            withAddress:(NSString*)address;

- (NSDictionary *)dictionary;

@end
