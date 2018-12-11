//
//  MKMapView+ZoomLevel.h
//  TestTopView
//
//  Created by cpd on 8/29/17.
//  Copyright © 2017 cpd. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
