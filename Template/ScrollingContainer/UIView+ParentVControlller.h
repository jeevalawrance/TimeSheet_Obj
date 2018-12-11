//
//  UIView+ParentVControlller.h
//  Hamdan2017
//
//  Created by Anthony on 2/8/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (ParentVControlller)

@property(nonatomic,weak) UIViewController *parentVC;

@end
