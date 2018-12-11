//
//  VerticalScrollContainer.h
//  horverScrollingPOC
//
//  Created by Anthony on 12/11/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalScrollContainer : UIViewController

@property(nonatomic,strong) UIScrollView *scrollViewVertical;

- (id)initWithtopVC:(UIViewController*)top bottomVC:(UIViewController*)bottom middleVC:(UIViewController*)miidle;

@end
