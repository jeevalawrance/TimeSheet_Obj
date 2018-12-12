//
//  WebServiceCall.h
//  ASI
//
//  Created by Antony Joe Mathew on 11/16/13.
//  Copyright (c) 2013 MSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHeaders.h"
#import <CoreLocation/CoreLocation.h>
//@class TeamScoreViewController;
@interface NetworkLayer : NSObject{

}

+(NetworkLayer *) getInstance;


- (void)RegisteringPNToken;
- (void)registerWithparams:(NSDictionary*)params Completion:(void (^)(BOOL success,id responseObject, NSError *error))completion;
- (void)loginWithParams:(NSDictionary*)params Completion:(void (^)(BOOL success,id responseObject, NSError *error))completion;
- (void)downloaSqliteToPath:(NSString *)filePath withServerURL:(NSString *)serverURL withCompletion:(void (^)(BOOL completed, NSURL *source_url, NSError *error))completion;
- (void)getNearestLocationWebservice:(CLLocation*)currentLocation andUrl:(NSString*)url Completion:(void (^)(BOOL success, NSArray* places, NSError *error))completion;

@end
