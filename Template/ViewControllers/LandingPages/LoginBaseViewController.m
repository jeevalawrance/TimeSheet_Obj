//
//  LoginBaseViewController.m
//  Login
//
//  Created by Anthony on 3/20/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "LoginBaseViewController.h"
#import "URLConstants.h"

@interface LoginBaseViewController ()

@end

@implementation LoginBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if(IS_ARABIC)
    {
        [self changingAlignMents:FALSE view:self.view];

    }
    else
    {
      //  self.view.transform = CGAffineTransformMakeScale(-1,1);

        [self changingAlignMents:TRUE view:self.view];
    }
    // Do any additional setup after loading the view.
}

-(void)changingAlignMents:(BOOL)toLeft view:(UIView*)view
{

    if ([view isKindOfClass:[UITextField class]]) {
        if (((UITextField*)view).textAlignment!=NSTextAlignmentCenter)
        {
            if (toLeft) {
                ((UITextField*)view).textAlignment = NSTextAlignmentLeft;
            }
            else
            {
                ((UITextField*)view).textAlignment = NSTextAlignmentRight;

            }
        }
    }
    else if ([view isKindOfClass:[UILabel class]]) {
        if (((UILabel*)view).textAlignment!=NSTextAlignmentCenter)
        {
            if (toLeft) {
                ((UILabel*)view).textAlignment = NSTextAlignmentLeft;
            }
            else
            {
                ((UILabel*)view).textAlignment = NSTextAlignmentRight;
                
            }
        }
    }
    else if ([view isKindOfClass:[UIButton class]]) {

        if (((UIButton*)view).titleLabel.textAlignment!=NSTextAlignmentCenter)
        {
            if (toLeft) {
                ((UIButton*)view).titleLabel.textAlignment = NSTextAlignmentLeft;
            }
            else
            {
                ((UIButton*)view).titleLabel.textAlignment = NSTextAlignmentRight;
                
            }
        }
          if (((UIButton*)view).contentHorizontalAlignment!=UIControlContentHorizontalAlignmentCenter)
        {
            if (toLeft) {
                ((UIButton*)view).contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }
            else
            {
                ((UIButton*)view).contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                
            }
        }
        
 
    }
    for (UIView *v in view.subviews) {
        [self changingAlignMents:toLeft view:v];
    }
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

@end
