//
//  UIView+ParentVControlller.m
//  Hamdan2017
//
//  Created by Anthony on 2/8/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "UIView+ParentVControlller.h"

@implementation UIView (ParentVControlller)
 @dynamic parentVC;
static void *parentVCKey = @"parentVCKey";

-(void)setParentVC:(UIViewController *)parentValue
{
 
    
    objc_setAssociatedObject(self, parentVCKey, parentValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

 
}
-(UIViewController*)parentVC
{
    return objc_getAssociatedObject(self, parentVCKey);

    
 }
@end
