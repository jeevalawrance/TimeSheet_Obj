//
//  TutorialViewController.m
//  ScrollingPOC
//
//  Created by cpd on 12/5/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "TutorialViewController.h"
#import "NDIntroView.h"
#import "AppDelegate.h"

@interface TutorialViewController ()<NDIntroViewDelegate>

@property (strong, nonatomic) NDIntroView *introView;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self startIntro];

}
#pragma mark - NDIntroView methods

-(void)startIntro {
    NSArray *pageContentArray = @[@{kNDIntroPageTitle : @"NDParallaxIntroView",
                                    kNDIntroPageDescription : @"Now you can easily add your beautiful intro into your app with no hassle.",
                                    kNDIntroPageImageName : @"parallax"
                                    },
                                  @{kNDIntroPageTitle : @"Work-It-Out",
                                    kNDIntroPageDescription : @"A great App to create your own personal workout and get instructed by your phone.",
                                    kNDIntroPageImageName : @"workitout"
                                    },
                                  @{kNDIntroPageTitle : @"ColorSkill",
                                    kNDIntroPageDescription : @"A small game while waiting for the bus. Easy, quick and addictive.",
                                    kNDIntroPageImageName : @"colorskill"
                                    },
                                  @{kNDIntroPageTitle : @"Appreciate",
                                    kNDIntroPageDescription : @"A little helper to make your life happier. Soon available on the AppStore",
                                    kNDIntroPageImageName : @"appreciate"
                                    },
                                  @{kNDIntroPageTitle : @"Last Page",
                                    kNDIntroPageImageName : @"firstImage",
                                    kNDIntroLastPage : @1,
                                    kNDIntroPageTitleLabelHeightConstraintValue : @0,
                                    kNDIntroPageImageHorizontalConstraintValue : @-40
                                    }
                                  ];
    self.introView = [[NDIntroView alloc] initWithFrame:self.view.frame parallaxImage:[UIImage imageNamed:@"parallaxBgImage"] andData:pageContentArray];
    self.introView.delegate = self;
    [self.view addSubview:self.introView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)launchAppButtonPressed {
    
    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appdel mainViewController];
    
}



@end
