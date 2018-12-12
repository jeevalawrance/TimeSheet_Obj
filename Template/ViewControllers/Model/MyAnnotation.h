//
//  MyAnnotation.h
//  HHPOChat
//
//  Created by cpd on 10/28/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
NS_ASSUME_NONNULL_BEGIN

@interface MyAnnotation : MKPointAnnotation{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;

}
@property(nonatomic, strong) NSString *imageName;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@end

NS_ASSUME_NONNULL_END
