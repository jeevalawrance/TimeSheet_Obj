//
//  LanguageSelectionViewController.m
//  AlAhli
//
//  Created by Anthony on 3/9/16.
//  Copyright © 2016 CPD. All rights reserved.
//

#import "LanguageSelectionViewController.h"
#import "CommonFunction.h"
#import "URLConstants.h"
#import "NetworkLayer.h"


@interface LanguageSelectionViewController ()

@end

@implementation LanguageSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selecteLanguageAction:(UIButton*)sender {
    [[NSUserDefaults standardUserDefaults] setValue:sender.restorationIdentifier forKey:SelecteLangauge];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [CommonFunction updatingTokentoServer];
    


    [CommonFunction setLoginRootViewControllerWithAnimation];
    
 }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setRootViewControllerWithAnimation
{
    UIStoryboard *storyboard = self.storyboard;
    
    
//
//    UINavigationController *newVC=[storyboard instantiateViewControllerWithIdentifier:@"signInRoot"];
//    AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
//    UIViewController *vc=[[newVC viewControllers] firstObject];
//    UIView *snapShot = [appdel.window snapshotViewAfterScreenUpdates:YES];
//    [vc.view addSubview:snapShot];
//    [UIView animateWithDuration:0.5 animations:^{
//        snapShot.layer.transform = CATransform3DMakeTranslation(0,-[UIScreen mainScreen].bounds.size.height,0);
//        appdel.window.rootViewController = newVC;
//    } completion:^(BOOL finished) {
//        [snapShot removeFromSuperview];
//    }];
}
-(void)setRootViewControllerWithAnimation1
{
//    AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
//
//    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"signInRoot"];
//
//    UIView *snapShot = [appdel.window snapshotViewAfterScreenUpdates:YES];
//    [viewController.view addSubview:snapShot];
//    appdel.window.rootViewController = viewController;
//    [UIView animateWithDuration:0.3 animations:^{
//        snapShot.layer.opacity = 0;
//        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
//    } completion:^(BOOL finished) {
//        [snapShot removeFromSuperview];
//    }];

}
-(void)setRootViewControllerWithAnimation11
{
//    AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
//    
//    UIViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"signInRoot"];
//    
//    UIView *snapShotView;
//    snapShotView = [appdel.window snapshotViewAfterScreenUpdates: YES];
//    [rootViewController.view addSubview: snapShotView];
//    
//    
//    [appdel.window setRootViewController: rootViewController];
//     {
//        [UIView animateWithDuration: 0.3 animations:^{
//            
//            snapShotView.layer.opacity = 0;
//            snapShotView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
//            
//        } completion:^(BOOL finished) {
//            
//            [snapShotView removeFromSuperview];
//            
//        }];
//    }
//    
}
@end
