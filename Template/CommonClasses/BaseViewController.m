//
//  BaseViewController.m
//  NAS2015
//
//  Created by Anthony on 5/25/15.
//  Copyright (c) 2015 CPD. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "CommonHeaders.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:(236.0f/255.0f) green:(236.0f/255.0f) blue:(236.0f/255.0f) alpha:1.0];
    
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    
    if(IS_ARABIC)
    {
        [self setupRightMenuButton];
        
    }
    else
    {
        [self setupLeftMenuButton];
        
    }
    
    
    
    
    // Do any additional setup after loading the view.
}


-(void)setupLeftMenuButton{
    UIImage *temp = [[UIImage imageNamed:@"MenuB"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:temp style:UIBarButtonItemStyleBordered target:self action:@selector(leftDrawerButtonPress:)];
    
    
    
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}

-(void)setupRightMenuButton{
    
    UIImage *temp = [[UIImage imageNamed:@"MenuB"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:temp style:UIBarButtonItemStyleBordered target:self action:@selector(rightDrawerButtonPress:)];
    
    
    
    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
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
