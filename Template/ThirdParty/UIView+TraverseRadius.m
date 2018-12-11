//
//  UIView+TraverseRadius.m
//  Template
//
//  Created by CPD on 3/20/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "UIView+TraverseRadius.h"

@implementation UIView (TraverseRadius)
- (void)traverseRadius:(CGFloat)radius {
    [self.layer setValue:@(radius) forKey:@"cornerRadius"];
    
    for (UIView *subview in self.subviews) {
        [subview traverseRadius:radius];
    }
}
@end
