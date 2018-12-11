//
//  OuterScrollView.h
//  Hamdan2017
//
//  Created by Dipin on 1/16/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OuterScrollView : UIScrollView
@property (nonatomic, strong) NSMutableDictionary *accelerationsOfSubViews;

- (void)getPanGestures1;


/**
 @brief Adds a Subview to the Scrollview with a specific acceleration.
 @param view The View wich will be added as subview.
 @param acceleration Acceleration of a View. ScrollViews default behaviour is CGPoint{1.0f, 1.0f} (via [addSubview]).
 */
- (void)addSubview:(UIView *)view withAcceleration:(CGPoint) acceleration;


/**
 @brief Sets the acceleration of an Subview.
 @param acceleration Acceleration of a View. ScrollViews default behaviour is CGPoint{1.0f, 1.0f} (via [addSubview]).
 @param view The View wich acceleration will be set.
 */
- (void)setAcceleration:(CGPoint) acceleration forView:(UIView *)view;


/**
 @brief Gets the acceleration for a subview.
 @return acceleration Acceleration of the specified View.
 @param view The View wich acceleration should be returned.
 */
- (CGPoint)accelerationForView:(UIView *)view;
@end
