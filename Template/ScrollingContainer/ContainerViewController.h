//
//  ContainerViewController.h
//  horverScrollingPOC
//
//  Created by Anthony on 12/11/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalScrollContainer.h"
#import "Enums.h"
//enum{
//    kHorizontalScrolIndexLeft = 1,
//    kHorizontalScrolIndexMiddle,
//    kHorizontalScrolIndexRight
//}typedef  kHorizontalScrolIndex;
//enum{
//    kVerticalScrolIndexTop,
//    kVerticalScrolIndexMiddle,
//    kVerticalScrolIndexBottom
//}typedef  kVerticalScrolIndex;


@interface ContainerViewController : UIViewController

- (id)initWithLeftVC:(UIViewController*)left rightVC:(UIViewController*)right topVC:(UIViewController*)top bottomVC:(UIViewController*)bottom middleVC:(UIViewController*)miidle;

@property(nonatomic,weak) UIViewController *middleViewController;
@property(nonatomic,weak) UIViewController *topViewController;
@property(nonatomic,weak) UIViewController *leftViewController;
@property(nonatomic,weak) UIViewController *rightViewController;
@property(nonatomic,weak) UIViewController *bottomViewController;

@property(nonatomic,assign) BOOL disableHorizontalScroll;
@property(nonatomic,assign) BOOL disableVerticalScroll;

@property(nonatomic,assign) BOOL disableScrollToTopViewController;
@property(nonatomic,assign) BOOL disableScrollToBottomViewController;

-(void)enableAllVerticalScrollingDirection;

-(void)moveHorizontalScrollViewTo:(kHorizontalScrolIndex)horizontalScrollIndex withAnimation:(BOOL)shouldAnimate;
-(void)moveVerticalScrollViewTo:(kVerticalScrolIndex)verticalScrollIndex withAnimation:(BOOL)shouldAnimate;

@end
