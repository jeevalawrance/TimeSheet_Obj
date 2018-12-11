//
//  ContainerViewController.m
//  horverScrollingPOC
//
//  Created by Anthony on 12/11/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "ContainerViewController.h"
#import "UIView+findViewController.h"
#import "OuterScrollView.h"
#import "SingletonClass.h"
#import "URLConstants.h"
#import "UIView+ParentVControlller.h"

static NSString *mainViewRestorationId = @"mianView";

typedef NS_ENUM(NSInteger, ScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
};

#define kSubViewTag 2000
#define kTagScrollHorizontal    9000
@interface ContainerViewController ()<UIScrollViewDelegate>
{
    
    OuterScrollView *scrollHorizontal;
  NSMutableArray *containersCellArray;
    UIScrollView *scrollVertical;
    BOOL additionalAdded;
    BOOL isFirstTime;
    BOOL scrollToBottomCalled;

}
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation ContainerViewController


- (id)initWithLeftVC:(UIViewController*)left rightVC:(UIViewController*)right topVC:(UIViewController*)top bottomVC:(UIViewController*)bottom middleVC:(UIViewController*)miidle
{
    self = [super init];
    if (self)
    {
        
        containersCellArray = [[NSMutableArray alloc] init];
        scrollVertical = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        scrollVertical.delegate = (id)self;
        scrollVertical.backgroundColor = [UIColor clearColor];
        scrollVertical.pagingEnabled = TRUE;
        scrollVertical.bounces = FALSE;
        scrollVertical.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:scrollVertical];
        
        if (@available(iOS 11.0, *)) {
            scrollVertical.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = FALSE;
        }
        
//        if (!IS_ARABIC)
//        {
//            _leftViewController = left;
//            _rightViewController = right;
//        }
//        else
        {
            _leftViewController = left;
            _rightViewController = right;
        }
        _topViewController = top;
        _bottomViewController = bottom;
        _middleViewController = miidle;

        
        [self setupScrollContainer];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   // [self moveVerticalScrollViewTo:kVerticalScrolIndexMiddle withAnimation:NO];

}

- (void)viewWillLayoutSubviews
{
    float topOffset = 0.0;
    if (@available(iOS 11.0, *)) {
        topOffset = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
  //  NSLog(@"top====== %f",topOffset);
    
    
    
}

- (void)viewDidLayoutSubviews
{
   // if (!additionalAdded) {
        if (_topViewController) {
            if (@available(iOS 11.0, *)) {
                NSLog(@"topview additional == %f and keywindow == %f",_topViewController.additionalSafeAreaInsets.top,[UIApplication sharedApplication].keyWindow.safeAreaInsets.top);
                if (_topViewController.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top)
                    _topViewController.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
            } else {
                // Fallback on earlier versions
            }
        }
        if (_bottomViewController) {
            if (@available(iOS 11.0, *)) {
                if (_bottomViewController.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top)
                    _bottomViewController.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
            } else {
                // Fallback on earlier versions
            }
        }
        if (_leftViewController) {
            if (@available(iOS 11.0, *)) {
                if (_leftViewController.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top) {
                    _leftViewController.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
                    
                }
            } else {
                // Fallback on earlier versions
            }
        }
        if (_rightViewController) {
            if (@available(iOS 11.0, *)) {
                if (_rightViewController.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top)
                    _rightViewController.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
            } else {
                // Fallback on earlier versions
            }
        }
        additionalAdded = true;
   // }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupScrollContainer
{
    // for top menu
    float yOffset = 0.0;
    float topOffset = 0.0;
    if (@available(iOS 11.0, *)) {
        topOffset = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    } else {
        // Fallback on earlier versions
    }
   // NSLog(@"top====== %f",topOffset);
    
    if(_topViewController)
    {
         [self addChildViewController:_topViewController];
        
        _topViewController.view.frame = CGRectMake(0, yOffset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _topViewController.view.parentVC =_topViewController;
        
        _topViewController.view.tag = kSubViewTag;
        [scrollVertical addSubview:_topViewController.view];
        [_topViewController didMoveToParentViewController:self];
        yOffset = yOffset+[UIScreen mainScreen].bounds.size.height;
        _topViewController.view.restorationIdentifier = mainViewRestorationId;
        
        [containersCellArray addObject:_topViewController.view];
        
        
    }
    else
    {
        [containersCellArray addObject:@""];

    }
  
    //scrollVertical.contentOffset = CGPointMake(0, yOffset);

    // for middle container

    
    scrollHorizontal = [[OuterScrollView alloc] initWithFrame:CGRectMake(0, yOffset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    scrollHorizontal.pagingEnabled = TRUE;
    scrollHorizontal.bounces = NO;
    scrollHorizontal.delegate = (id)self;
    scrollHorizontal.showsHorizontalScrollIndicator = FALSE;
    [containersCellArray addObject:scrollHorizontal];

    yOffset = yOffset+[UIScreen mainScreen].bounds.size.height;

    int tagCounter = 1;

    float xOffset = 0.;
    
    // for left Menu

    if (_leftViewController)
    {
        
        [self addChildViewController:_leftViewController];
        _leftViewController.view.frame = CGRectMake(xOffset, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height); // 2
        _leftViewController.view.parentVC =_leftViewController;

       // [scrollHorizontal addSubview:_leftViewController.view withAcceleration:A3DefaultAcceleration];
        [scrollHorizontal addSubview:_leftViewController.view];
        [_leftViewController didMoveToParentViewController:self];
        xOffset  =  xOffset + [UIScreen mainScreen].bounds.size.width;
        _leftViewController.view.tag = kTagScrollHorizontal + tagCounter;
        _leftViewController.view.restorationIdentifier = mainViewRestorationId;
        _leftViewController.view.layer.zPosition = 0.0;

    }
    tagCounter++;


  //  scrollHorizontal.contentOffset = CGPointMake(xOffset, 0);
    
    // for center View

    [self addChildViewController:_middleViewController];
    _middleViewController.view.frame = CGRectMake(xOffset, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height); // 2
    
   //[scrollHorizontal addSubview:_middleViewController.view withAcceleration:CGPointMake(0.0, 0)];
    [scrollHorizontal addSubview:_middleViewController.view];
    [_middleViewController didMoveToParentViewController:self];
    _middleViewController.view.parentVC =_middleViewController;

    _middleViewController.view.layer.zPosition = 1.0;
    _middleViewController.view.tag = kTagScrollHorizontal + tagCounter;
    _middleViewController.view.restorationIdentifier = mainViewRestorationId;

    xOffset  =  xOffset + [UIScreen mainScreen].bounds.size.width;
    tagCounter++;

    
    // for right Menu

    if (_rightViewController)
    {
        [self addChildViewController:_rightViewController];
        _rightViewController.view.frame = CGRectMake(xOffset, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height); // 2
        //[scrollHorizontal addSubview:_rightViewController.view withAcceleration:A3DefaultAcceleration];
        _rightViewController.view.parentVC =_rightViewController;

        [scrollHorizontal addSubview:_rightViewController.view];
        [_rightViewController didMoveToParentViewController:self];
        xOffset  =  xOffset + _rightViewController.view.frame.size.width;
        _rightViewController.view.tag = kTagScrollHorizontal + tagCounter;
        _rightViewController.view.layer.zPosition = 0.0;

        _rightViewController.view.restorationIdentifier = mainViewRestorationId;

    }
    tagCounter++;

    scrollHorizontal.contentSize = CGSizeMake(xOffset, [UIScreen mainScreen].bounds.size.height);
    
  
    [scrollVertical addSubview:scrollHorizontal];
    scrollHorizontal.backgroundColor = [UIColor clearColor];
    
   
    scrollHorizontal.tag = kSubViewTag;
 
    
    
    
    
    
    // for bottom menu
    
    if (_bottomViewController)
    {
        [self addChildViewController:_bottomViewController];
        _bottomViewController.view.frame = [UIScreen mainScreen].bounds;
        
        [_bottomViewController didMoveToParentViewController:self];
        
        _bottomViewController.view.parentVC =_bottomViewController;

        [scrollVertical addSubview:_bottomViewController.view];
        [_bottomViewController didMoveToParentViewController:self];
        _bottomViewController.view.frame = CGRectMake(0, yOffset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    
        _bottomViewController.view.restorationIdentifier = mainViewRestorationId;

        _bottomViewController.view.tag = kSubViewTag;

        yOffset = yOffset+[UIScreen mainScreen].bounds.size.height;

        [containersCellArray addObject:_bottomViewController.view];

        
    }
    else{
        [containersCellArray addObject:@""];

        
    }
    
    scrollVertical.contentSize = CGSizeMake(scrollVertical.contentSize.width, yOffset);
    
    
    [scrollHorizontal getPanGestures1];
    
    [SingletonClass getInstance].currentHorizontalIndex = kHorizontalScrolIndexMiddle;
    [SingletonClass getInstance].currentVerticalIndex = kVerticalScrolIndexMiddle;
    [self moveHorizontalScrollViewTo:kHorizontalScrolIndexMiddle withAnimation:NO];
    [self moveVerticalScrollViewTo:kVerticalScrolIndexMiddle withAnimation:NO];
    
//    if (_topViewController) {
//        if (@available(iOS 11.0, *)) {
//            if (_topViewController.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top)
//                _topViewController.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//    if (_bottomViewController) {
//        if (@available(iOS 11.0, *)) {
//            if (_bottomViewController.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top)
//                _bottomViewController.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//    if (_leftViewController) {
//        if (@available(iOS 11.0, *)) {
//            if (_leftViewController.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top) {
//                _leftViewController.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
//
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//    if (_rightViewController) {
//        if (@available(iOS 11.0, *)) {
//            if (_rightViewController.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top)
//                _rightViewController.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    if (IS_ARABIC) {
         scrollHorizontal.transform = CGAffineTransformMakeScale(-1,1);
        for (UIView *view in scrollHorizontal.subviews) {
            view.transform = CGAffineTransformMakeScale(-1,1);

        }
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

#pragma mark - Helper Classes

-(void)moveHorizontalScrollViewTo:(kHorizontalScrolIndex)horizontalScrollIndex withAnimation:(BOOL)shouldAnimate
{
    

    float xOffset = 0.;
    
    switch (horizontalScrollIndex)
    {
        case kHorizontalScrolIndexLeft:
            if (_leftViewController)
            {
                xOffset = _leftViewController.view.frame.origin.x;
            }
            break;
        case kHorizontalScrolIndexRight:
            if (_rightViewController)
            {
                xOffset = _middleViewController.view.frame.origin.x+_middleViewController.view.frame.size.width;
            }
            break;
        case kHorizontalScrolIndexMiddle:
            if (_middleViewController)
            {
                xOffset = _middleViewController.view.frame.origin.x;
            }
            break;
        default:
            break;
    }
    CGRect middleCellRect = scrollHorizontal.frame;

    if (_disableHorizontalScroll == FALSE && (fabs((middleCellRect.origin.y-scrollVertical.contentOffset.y))<=5.))
    {
        scrollHorizontal.scrollEnabled = TRUE;
    }
    
    [scrollHorizontal setContentOffset:CGPointMake(xOffset, 0) animated:shouldAnimate];
    
}

-(void)moveVerticalScrollViewTo:(kVerticalScrolIndex)verticalScrollIndex withAnimation:(BOOL)shouldAnimate
{
    float yOffset = 0.;
    
    switch (verticalScrollIndex)
    {
        case kVerticalScrolIndexTop:
            if (_topViewController)
            {
                yOffset = _topViewController.view.frame.origin.y;
            }
            break;
        case kVerticalScrolIndexMiddle:
            if (_middleViewController)
            {
                yOffset = scrollHorizontal.frame.origin.y;
            }
            break;
        case kVerticalScrolIndexBottom:
            if (_middleViewController)
            {
                yOffset = scrollHorizontal.frame.origin.y+scrollHorizontal.frame.size.height;
            }
            break;
        default:
            break;
    }
    
//    CGRect cellRect = [scrollVertical rectForRowAtIndexPath:[NSIndexPath indexPathForRow:verticalScrollIndex inSection:0]];

    //[scrollVertical scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:verticalScrollIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [scrollVertical setContentOffset:CGPointMake(0, yOffset) animated:shouldAnimate];
    
}

-(void)setDisableHorizontalScroll:(BOOL)theBoolean
{
    if(_disableHorizontalScroll != theBoolean){
        _disableHorizontalScroll = theBoolean;
        
        if (theBoolean==TRUE)
        {
            CGFloat width = scrollHorizontal.frame.size.width;
            NSInteger page = (scrollHorizontal.contentOffset.x + (0.5f * width)) / width;
            [scrollHorizontal setContentOffset:CGPointMake(page*width, 0)];
            
        }
        
    }
    scrollHorizontal.scrollEnabled = !theBoolean;
    
}

-(void)setDisableVerticalScroll:(BOOL)theBoolean
{
    if(_disableVerticalScroll != theBoolean){
        _disableVerticalScroll = theBoolean;
        
        if (theBoolean==TRUE)
        {
            CGFloat height =scrollVertical.frame.size.height;
            int page = round(scrollVertical.contentOffset.y / scrollVertical.frame.size.height);
            //NSInteger page = (_centreVerticalContainerViewController.scrollViewVertical.contentOffset.x + (0.5f * width)) / width;
            [scrollVertical setContentOffset:CGPointMake(0, page*height)];
        }
        
    }
    scrollVertical.scrollEnabled = !theBoolean;
    NSLog(@"setDisableVerticalScroll %d",scrollVertical.scrollEnabled);

    
}
-(void)setDisableScrollToTopViewController:(BOOL)theBoolean
{
   
    _disableScrollToTopViewController = theBoolean;
 //   NSLog(@"DisableScrollToTopViewController %d",_disableScrollToTopViewController);

}
-(void)setDisableScrollToBottomViewController:(BOOL)theBoolean
{
    
    _disableScrollToBottomViewController = theBoolean;
   // NSLog(@"DisableScrollToBottomViewController %d",_disableScrollToBottomViewController);
//
    
}
-(void)enableAllVerticalScrollingDirection
{

   // _disableScrollToBottomViewController = FALSE;
    //_disableScrollToTopViewController = FALSE;
    [self setDisableScrollToBottomViewController:FALSE];
    [self setDisableScrollToTopViewController:FALSE];
    NSLog(@"enableAllVerticalScrollingDirection %d",scrollVertical.scrollEnabled);

    _disableVerticalScroll = FALSE;

}
-(void)addingParrallaxeffectToHorizontalViews
{
    CGRect container = CGRectMake(scrollHorizontal.contentOffset.x, scrollHorizontal.contentOffset.y, scrollHorizontal.frame.size.width, scrollHorizontal.frame.size.height);
    for(UIView *view in scrollHorizontal.subviews)
    {
        if([view.restorationIdentifier isEqualToString:mainViewRestorationId])
        {
            CGRect thePosition =  view.frame;
            if(CGRectIntersectsRect(thePosition, container))
            {
                // This view has been scrolled on screen
                
                CGFloat xOffset = ((scrollHorizontal.contentOffset.x - view.frame.origin.x) / view.frame.size.width) * IMAGE_OFFSET_SPEED;
                
                //CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
                
                CGRect frame = view.bounds;
                CGRect offsetFrame = CGRectOffset(frame, xOffset, 0);
                view.frame = offsetFrame;
                
                NSLog(@"view.frame %@ tag %d",NSStringFromCGRect(view.frame),view.tag);
                
                
            }
        }
        
        
    }

}
#pragma mark - UIScrollView Delegates

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView ==scrollHorizontal)
    {
        if (_leftViewController == nil) {
            [SingletonClass getInstance].currentHorizontalIndex = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 2;
        }
        else
        {
         [SingletonClass getInstance].currentHorizontalIndex = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1;
        }
    }
    if (scrollView == scrollVertical) {
            [SingletonClass getInstance].currentVerticalIndex = scrollView.contentOffset.y/[UIScreen mainScreen].bounds.size.height;
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    if (scrollView ==scrollHorizontal)
    {
        int toIndex = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        if (_leftViewController == nil) {
            toIndex = toIndex + 1;
        }
        
        UIView *toView = [scrollView viewWithTag:kTagScrollHorizontal + toIndex+1];
        UIViewController *toVC = [toView viewController];
        
        UIView *fromView = [scrollView viewWithTag:kTagScrollHorizontal + [SingletonClass getInstance].currentHorizontalIndex];
        UIViewController *fromVC = [fromView viewController];
        
        if ([fromVC respondsToSelector:@selector(viewwillDisappearwhileScrolling)]){
            [fromVC performSelector:@selector(viewwillDisappearwhileScrolling)];
        }
        [SingletonClass getInstance].currentHorizontalIndex = toIndex+1;

        if ([toVC respondsToSelector:@selector(viewwillAppearwhileScrolling)]){
            [toVC performSelector:@selector(viewwillAppearwhileScrolling)];
        }
        
        
        if (!(fabs((scrollView.contentOffset.x-_middleViewController.view.frame.origin.x))<=5.))
        {
            
            //Horizonatal scroll view is not centrview
            //May be in  Menu,news details etc.....
            // no need of vertical scorlling here
            //   scrollVertical.scrollEnabled = FALSE;
            
        }
        else
        {
            if (_disableHorizontalScroll == FALSE)
            {
                // scrollVertical.scrollEnabled = TRUE;
            }
        }
    }
   else  if (scrollView == scrollVertical) {
      
        int toIndex = scrollView.contentOffset.y/[UIScreen mainScreen].bounds.size.height;
        
        if (containersCellArray.count > [SingletonClass getInstance].currentVerticalIndex) {
            //UITableViewCell *fromcell = containersCellArray[[SingletonClass getInstance].currentVerticalIndex];
            UIView *fromView = containersCellArray[[SingletonClass getInstance].currentVerticalIndex];
            
            UIViewController *fromVC = [fromView viewController];
            if ([fromVC isKindOfClass:[ContainerViewController class]]) {
                UIView *fromViewChild = [scrollHorizontal viewWithTag:kTagScrollHorizontal +[SingletonClass getInstance].currentHorizontalIndex];
                UIViewController *fromViewChildVC = [fromViewChild viewController];
                if ([fromViewChildVC respondsToSelector:@selector(viewwillDisappearwhileScrolling)]){
                    [fromViewChildVC performSelector:@selector(viewwillDisappearwhileScrolling)];
                }
            }
            else
            {
                if ([fromVC respondsToSelector:@selector(viewwillDisappearwhileScrolling)]){
                    [fromVC performSelector:@selector(viewwillDisappearwhileScrolling)];
                }
            }
        }
       [SingletonClass getInstance].currentVerticalIndex = toIndex;

        if (containersCellArray.count > toIndex) {
            //UITableViewCell *tocell = containersCellArray[toIndex];
           // UIView *toView = [tocell viewWithTag:kSubViewTag];
            UIView *toView = containersCellArray[toIndex];

            UIViewController *toVC = [toView viewController];
            if ([toVC isKindOfClass:[ContainerViewController class]]) {
                UIView *toViewChild = [scrollHorizontal viewWithTag:kTagScrollHorizontal +[SingletonClass getInstance].currentHorizontalIndex];
                UIViewController *towChildVC = [toViewChild viewController];
                if ([towChildVC respondsToSelector:@selector(viewwillAppearwhileScrolling)]){
                    [towChildVC performSelector:@selector(viewwillAppearwhileScrolling)];
                }
            }
            else
            {
                if ([toVC respondsToSelector:@selector(viewwillAppearwhileScrolling)]){
                    [toVC performSelector:@selector(viewwillAppearwhileScrolling)];
                }
            }
        }
       scrollToBottomCalled = FALSE;

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //Run your code on the current page
    if (scrollView ==scrollHorizontal)
    {
        int toIndex = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        if (_leftViewController == nil) {
            toIndex = toIndex + 1;
        }
        UIView *toView = [scrollView viewWithTag:kTagScrollHorizontal + toIndex+1];
        //NSLog(@"toIndex %d toView.tag%d",toIndex,toView.tag);

        UIViewController *toVC = [toView viewController];
      
        UIView *fromView = [scrollView viewWithTag:kTagScrollHorizontal + [SingletonClass getInstance].currentHorizontalIndex];
        UIViewController *fromVC = [fromView viewController];
        
        if ([fromVC respondsToSelector:@selector(viewwillDisappearwhileScrolling)]){
            [fromVC performSelector:@selector(viewwillDisappearwhileScrolling)];
        }
        [SingletonClass getInstance].currentHorizontalIndex = toIndex+1;

//        for (UIView *view in  scrollView.subviews) {
//            if ([view isKindOfClass:[UIView class]]) {
//                if ([[view viewController] isKindOfClass:[RecentOrCategoryNewsViewController class]]) {
//                    RecentOrCategoryNewsViewController *recent =  [view viewController];
//                    NSLog(@"view %ld  vc %@ recent %d",(long)view.tag,[view viewController],recent.kNewsPageType);
//
//                }
//            }
//        }
//        RecentOrCategoryNewsViewController *recent =  toVC;
//        if ([recent isKindOfClass:[RecentOrCategoryNewsViewController class]]) {
//             NSLog(@"to view %ld  vc %@ recent %d",(long)recent.view.tag,recent,recent.kNewsPageType);
//
//        }

        if ([toVC respondsToSelector:@selector(viewwillAppearwhileScrolling)]){
            [toVC performSelector:@selector(viewwillAppearwhileScrolling)];
        }
        
        
        if (!(fabs((scrollView.contentOffset.x-_middleViewController.view.frame.origin.x))<=5.))
        {
            
            //Horizonatal scroll view is not centrview
            //May be in  Menu,news details etc.....
            // no need of vertical scorlling here
            //   scrollVertical.scrollEnabled = FALSE;
            
        }
        else
        {
            if (_disableHorizontalScroll == FALSE)
            {
                // scrollVertical.scrollEnabled = TRUE;
            }
        }
    }
   else if (scrollView == scrollVertical) {
        int toIndex = scrollView.contentOffset.y/[UIScreen mainScreen].bounds.size.height;
        
        if (containersCellArray.count > [SingletonClass getInstance].currentVerticalIndex) {
           // UITableViewCell *fromcell = containersCellArray[[SingletonClass getInstance].currentVerticalIndex];
            UIView *fromView = containersCellArray[[SingletonClass getInstance].currentVerticalIndex];//[fromcell viewWithTag:kSubViewTag];
            
            UIViewController *fromVC = [fromView viewController];
            if ([fromVC isKindOfClass:[ContainerViewController class]]) {
                UIView *fromViewChild = [scrollHorizontal viewWithTag:kTagScrollHorizontal +[SingletonClass getInstance].currentHorizontalIndex];
                UIViewController *fromViewChildVC = [fromViewChild viewController];
                if ([fromViewChildVC respondsToSelector:@selector(viewwillDisappearwhileScrolling)]){
                    [fromViewChildVC performSelector:@selector(viewwillDisappearwhileScrolling)];
                }
            }
            else
            {
                if ([fromVC respondsToSelector:@selector(viewwillDisappearwhileScrolling)]){
                    [fromVC performSelector:@selector(viewwillDisappearwhileScrolling)];
                }
            }
        }
        
        if (containersCellArray.count > toIndex) {
           // UITableViewCell *tocell = containersCellArray[toIndex];
            UIView *toView = containersCellArray[toIndex]; //[tocell viewWithTag:kSubViewTag];
            UIViewController *toVC = [toView viewController];
            [SingletonClass getInstance].currentVerticalIndex = toIndex;

            if ([toVC isKindOfClass:[ContainerViewController class]]) {
                UIView *toViewChild = [scrollHorizontal viewWithTag:kTagScrollHorizontal +[SingletonClass getInstance].currentHorizontalIndex];
                UIViewController *towChildVC = [toViewChild viewController];
                if ([towChildVC respondsToSelector:@selector(viewwillAppearwhileScrolling)]){
                    [towChildVC performSelector:@selector(viewwillAppearwhileScrolling)];
                }
            }
            else
            {
                if ([toVC respondsToSelector:@selector(viewwillAppearwhileScrolling)]){
                    [toVC performSelector:@selector(viewwillAppearwhileScrolling)];
                }
            }
        }
        
       scrollToBottomCalled = FALSE;
 
    }
  //  NSLog(@"current vert index == %i and current horizonta index == %i",[SingletonClass getInstance].currentVerticalIndex,[SingletonClass getInstance].currentHorizontalIndex);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==scrollVertical)
    {
     
        
        if (_bottomViewController) {

            
            if ((scrollView.contentOffset.y+scrollView.frame.size.height)>_bottomViewController.view.frame.origin.y&&scrollToBottomCalled==FALSE&&self.lastContentOffset < scrollView.contentOffset.y) {
                scrollToBottomCalled = TRUE;
                if ([_bottomViewController respondsToSelector:@selector(scrollStatedToBottom)]) {
                    [_bottomViewController performSelector:@selector(scrollStatedToBottom)];
                }
            }
        }
        
        if (_disableScrollToBottomViewController)
        {
            CGRect middleCellRect = scrollHorizontal.frame;
            if (scrollView.contentOffset.y>middleCellRect.origin.y) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, middleCellRect.origin.y);
            }

        }
        else if (_disableScrollToTopViewController)
        {
            CGRect middleCellRect = scrollHorizontal.frame;
            if (scrollView.contentOffset.y<middleCellRect.origin.y) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, middleCellRect.origin.y);
            }
            
        }
        self.lastContentOffset = scrollView.contentOffset.y;

    }
    else if (scrollView==scrollHorizontal)

   {
     //  [self addingParrallaxeffectToHorizontalViews];
       
   }
   
    
   
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView==scrollVertical)
    {
        if (_disableScrollToBottomViewController)
        {
            NSLog(@"target == %@",NSStringFromCGPoint(*targetContentOffset));
            CGRect middleCellRect = scrollHorizontal.frame;
            if (targetContentOffset->y>middleCellRect.origin.y) {
                targetContentOffset->y = middleCellRect.origin.y;

            }
        }
        if (_disableScrollToTopViewController)
        {
            
            CGRect middleCellRect = scrollHorizontal.frame;
            if (targetContentOffset->y<middleCellRect.origin.y) {
                targetContentOffset->y = middleCellRect.origin.y;
                
            }
        }
        
    }
    else
    {
        
    }
    
}
@end
