//
//  TabBarController.m
//  ArticlePost
//
//  Created by XXXX on 1/25/15.
//  Copyright (c) 2015 MyCompany. All rights reserved.
//

#import "TabBarController.h"
#import "CommonHeaders.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tabBarImages];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)tabBarImages
{
     // repeat for every tab, but increment the index each time



    
    NSArray *imageAndTitle=@[@{@"title":@"",@"image":@"simtab",@"color":kColorGoldenTopBar},
                            @{@"title":@"",@"image":@"channeltab",@"color":kColorBlueTopBar},
                            @{@"title":@"",@"image":@"landlinetab",@"color":kColorGreenTopBar}];
    
;
    
    
    

    UITabBar *tabBar = self.tabBar;
   
    NSArray *tabItems=tabBar.items;

    UIColor *colrNormal,*colrSelected;
    colrNormal=NavigationBarColor;
    colrSelected=[UIColor blackColor];

    float offset=6;
    
    for (int t=0; t<tabItems.count;t++)
    {
        UITabBarItem *firstTab = [tabItems objectAtIndex:t];
        [firstTab setImage:[[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [firstTab setSelectedImage:[[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     //   firstTab.image =[firstTab setImage:[[UIImage imageNamed:@"more.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]]; [UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]];//[self image:[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]] fromColor:colrNormal] ;
      
    //    firstTab.selectedImage =[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]];// [self image:[UIImage imageNamed:[imageAndTitle[t] valueForKey:@"image"]] fromColor:colrSelected];
      
        //[[UIImage imageNamed:[NSString stringWithFormat:@"%@-selected",[imageAndTitle[t] valueForKey:@"image"]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] ;


        
        firstTab.imageInsets = UIEdgeInsetsMake(offset, 0, -1*offset, 0);
        firstTab.title = nil;
        

        
        
        
    }
//
   // [@"color"]
    NSArray *vcss =self.viewControllers;

    for (UINavigationController *nv in vcss)
    {
        int indx=(int)[vcss indexOfObject:nv];

        [nv.navigationBar setBarTintColor:imageAndTitle[indx][@"color"]];
        [nv.navigationBar setTranslucent:NO];
    }
 
  //  [[UITabBar appearance] setTintColor:colrSelected];
    

    
     // self.tabBar.barTintColor = kTabBarColor;

    
//    for (UITabBarItem *item in tabItems)
//    {
//     
//
//     
//        
//        {
//            [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:AppfontLight size:10],
//                                           NSForegroundColorAttributeName : colrSelected
//                                           } forState:UIControlStateSelected];
//            
//            
//            // doing this results in an easier to read unselected state then the default iOS 7 one
//            [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:AppfontLight size:10],
//                                           NSForegroundColorAttributeName : colrNormal
//                                           } forState:UIControlStateNormal];
// 
//        }
//        
//
//        
//    }
  /*
    float itemWidth = tabBarController.tabBar.frame.size.width / (tabItems.count);
    UIView *bgView =[[UIView alloc] initWithFrame:CGRectMake(itemWidth * itemIndex, 0, itemWidth, tabBarController.tabBar.frame.size.height)];
    bgView.backgroundColor = NavigationBarColor;
    [tabBarController.tabBar insertSubview:bgView atIndex:0];
  */
    
   // tabBar.layer.borderWidth = 0.50;
  //  tabBar.layer.borderColor =[UIColor clearColor].CGColor;
    
    

    //  [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbGColor"]];

    
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbGColor.png"]]];
    
     [[UITabBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbGColor"]]];
 
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor],
                                                                                                  NSForegroundColorAttributeName,
                                                                                                  //  [UIColor darkGrayColor],
                                                                                                  //  UITextAttributeTextShadowColor,
                                                                                                  //  [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                                                                  //  UITextAttributeTextShadowOffset,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    }
    

    
    
    // [[UITabBar appearance] setTintColor:[UIColor clearColor]];
  //  self.selectedIndex =2;
    
    
}
-(UIImage*)image:(UIImage*)image fromColor:(UIColor*)color
{

    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return coloredImg;
    
}
@end
