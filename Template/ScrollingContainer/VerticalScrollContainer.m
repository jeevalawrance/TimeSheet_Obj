//
//  VerticalScrollContainer.m
//  horverScrollingPOC
//
//  Created by Anthony on 12/11/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "VerticalScrollContainer.h"

@interface VerticalScrollContainer ()
{
    UIViewController *topVC,*bottomVC,*middleVC;
 
}
@end

@implementation VerticalScrollContainer


- (id)initWithtopVC:(UIViewController*)top bottomVC:(UIViewController*)bottom middleVC:(UIViewController*)miidle
{
    self = [super init];
    if (self)
    {
        
        topVC = top;
        bottomVC = bottom;
        middleVC = miidle;
        _scrollViewVertical = [[UIScrollView alloc] init];
        
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVeticalScroll];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupVeticalScroll
{
   
    _scrollViewVertical.frame = [UIScreen mainScreen].bounds;
    _scrollViewVertical.pagingEnabled = TRUE;
    _scrollViewVertical.bounces = NO;
    _scrollViewVertical.showsVerticalScrollIndicator = FALSE;
    [self.view addSubview:_scrollViewVertical];
    
    float yOffset = 0.;
    if (topVC)
    {
        
        [self addChildViewController:topVC];
        topVC.view.frame = CGRectMake(0, yOffset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height); // 2
        [_scrollViewVertical addSubview:topVC.view];
        [topVC didMoveToParentViewController:self];
        yOffset  =  yOffset + [UIScreen mainScreen].bounds.size.height;
        
    }
    _scrollViewVertical.contentOffset = CGPointMake(0, yOffset);
    
    
    [self addChildViewController:middleVC];
    middleVC.view.frame = CGRectMake(0, yOffset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height); // 2
    [_scrollViewVertical addSubview:middleVC.view];
    [middleVC didMoveToParentViewController:self];
    yOffset  =  yOffset + [UIScreen mainScreen].bounds.size.height;
    
    if (bottomVC)
    {
        [self addChildViewController:bottomVC];
        bottomVC.view.frame = CGRectMake(0, yOffset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height); // 2
        [_scrollViewVertical addSubview:bottomVC.view];
        [bottomVC didMoveToParentViewController:self];
        yOffset  =  yOffset + bottomVC.view.frame.size.height;
        
    }
    
    _scrollViewVertical.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, yOffset);
    if (@available(iOS 11.0, *)) {
        _scrollViewVertical.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
   
        self.automaticallyAdjustsScrollViewInsets = FALSE;

    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
