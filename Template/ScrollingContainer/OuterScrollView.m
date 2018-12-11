//
//  OuterScrollView.m
//  Hamdan2017
//
//  Created by Dipin on 1/16/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "OuterScrollView.h"
#import "CommonFunction.h"
#import "UIView+ParentVControlller.h"
#import "ContainerViewController.h"
@implementation OuterScrollView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
//====================================================================
#pragma mark - properties

- (NSMutableDictionary *)accelerationsOfSubViews{

// lazy load dictionary
if (!_accelerationsOfSubViews) {
_accelerationsOfSubViews = [NSMutableDictionary dictionary];
}
return _accelerationsOfSubViews;
}


//====================================================================
#pragma mark - logic

- (void)addSubview:(UIView *)view{
[self addSubview:view withAcceleration:A3DefaultAcceleration];
}


- (void)addSubview:(UIView *)view withAcceleration:(CGPoint) acceleration{
// add to super
[super addSubview:view];
[self setAcceleration:acceleration forView:view];
}


- (void)setAcceleration:(CGPoint) acceleration forView:(UIView *)view{
// store acceleration
(self.accelerationsOfSubViews)[@((int)view)] = NSStringFromCGPoint(acceleration);
}

- (CGPoint)accelerationForView:(UIView *)view{
    
    // return var
    CGPoint accelecration;
    
    // get acceleration
    NSString *pointValue = (self.accelerationsOfSubViews)[@((int)view)];
    if(pointValue == nil){
        accelecration = CGPointZero;
    }
    else{
        accelecration = CGPointFromString(pointValue);
    }
    
    return accelecration;
}

- (void)willRemoveSubview:(UIView *)subview{
    [self.accelerationsOfSubViews removeObjectForKey:@((int)subview)];
}

//====================================================================
#pragma mark - layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    for (UIView *v in self.subviews) {
        // get acceleration
        CGPoint accelecration = [self accelerationForView:v];
        
        // move the view
        v.layer.affineTransform = CGAffineTransformMakeTranslation(self.contentOffset.x*(1.0f-accelecration.x), self.contentOffset.y*(1.0f-accelecration.y));
    }
}
*/
- (void)getPanGestures1
{
    for (UIView *view in self.subviews) {
        for (UIView *subVert in view.subviews) {
            if ([subVert isKindOfClass:[UIScrollView class]] || [subVert.restorationIdentifier isEqualToString:@"container_p"] || [subVert.restorationIdentifier isEqualToString:@"container_v"] || [subVert.restorationIdentifier isEqualToString:@"container_cat"]) {

                if ([subVert isKindOfClass:[UIScrollView class]])
                {
                    UIScrollView *subScroll = (UIScrollView *)subVert;
                    if ([subScroll.restorationIdentifier isEqualToString:@"vertTable"] || [subScroll.restorationIdentifier isEqualToString:@"Cell"]) {
                        [subScroll.panGestureRecognizer addTarget:self action:@selector(handlePanInner:)];
                    }
                }
                if ([subVert.restorationIdentifier isEqualToString:@"container_p"] || [subVert.restorationIdentifier isEqualToString:@"container_v"])
                {
                   for (UIView *subcont in subVert.subviews) {
                       for (UIView *subsc in subcont.subviews) {
                           if ([subsc isKindOfClass:[UIScrollView class]])
                           {
                               UIScrollView *subScroll = (UIScrollView *)subsc;
                               if ([subScroll.restorationIdentifier isEqualToString:@"vertTable"] || [subScroll.restorationIdentifier isEqualToString:@"Cell"]) {
                                   [subScroll.panGestureRecognizer addTarget:self action:@selector(handlePanInner:)];
                               }
                           }
                       }
                       
                   }
                }
                if ([subVert.restorationIdentifier isEqualToString:@"container_cat"] )
                {
                    for (UIView *subcont in subVert.subviews) {
                        if ([subcont isKindOfClass:[UIScrollView class]])
                        {
                            UIScrollView *subScroll = (UIScrollView *)subcont;
                            if ([subScroll.restorationIdentifier isEqualToString:@"vertTable"] || [subScroll.restorationIdentifier isEqualToString:@"Cell"]) {
                                [subScroll.panGestureRecognizer addTarget:self action:@selector(handlePanInner:)];
                            }
                        }
                    }
                }
                
                
                
            }
        }
    }
}


- (void)handlePanInner:(UIPanGestureRecognizer *)pan
{
    CGPoint vel = [pan velocityInView:pan.view.superview];
    UIScrollView *scrollingView = (UIScrollView *)pan.view;
    UIScrollView *parentScroll = (UIScrollView *)self.superview;
    if (![parentScroll isKindOfClass:[UIScrollView class]]) {
        return;
    }
    if ([[self parentVC] isKindOfClass:[ContainerViewController class]]) {
        ContainerViewController *container = (ContainerViewController *)[self parentVC];
        if (container.disableVerticalScroll) {
            return;
        }
    }
    CGPoint translatedPoint = [pan translationInView:pan.view.superview];
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (vel.y > 0)
        {
           // NSLog(@"Uppppp == %@",NSStringFromCGPoint(vel));
            if (scrollingView.contentOffset.y < 0) {
                [parentScroll setContentOffset:CGPointMake(0, translatedPoint.y) animated:YES];
            }
            // user dragged towards the up
        }
        else if (vel.y < 0)
        {
         //   NSLog(@"down == %@",NSStringFromCGPoint(vel));
            
            if (scrollingView.contentOffset.y > scrollingView.contentSize.height - scrollingView.frame.size.height && parentScroll.contentSize.height > 2*[UIScreen mainScreen].bounds.size.height) {
                [parentScroll setContentOffset:CGPointMake(0, parentScroll.contentSize.height - [UIScreen mainScreen].bounds.size.height - translatedPoint.y) animated:YES];
            }
            // user dragged towards the down
        }
    }
    
   else if (pan.state == UIGestureRecognizerStateEnded) {
        if (vel.y > 0)
        {
         //   NSLog(@"Uppppp == %@",NSStringFromCGPoint(vel));
            if (scrollingView.contentOffset.y < 0) {
                [parentScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            // user dragged towards the up
        }
        else if (vel.y < 0)
        {
         //   NSLog(@"down == %@",NSStringFromCGPoint(vel));
            
            if (scrollingView.contentOffset.y > scrollingView.contentSize.height - scrollingView.frame.size.height && parentScroll.contentSize.height > 2*[UIScreen mainScreen].bounds.size.height) {
                [parentScroll setContentOffset:CGPointMake(0, parentScroll.contentSize.height - [UIScreen mainScreen].bounds.size.height) animated:YES];
            }
            // user dragged towards the down
        }
    }
  //  translatedPoint = CGPointMake(pan.view.center.x+translatedPoint.x, pan.view.center.y+translatedPoint.y);
   // NSLog(@"translatedPoint == %@",NSStringFromCGPoint(translatedPoint));

    
}



@end
