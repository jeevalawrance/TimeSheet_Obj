//
//  RegisterationSuccessViewController.m
//  Login
//
//  Created by Anthony on 3/20/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "RegisterationSuccessViewController.h"
#import "CommonFunction.h"

@interface RegisterationSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblSuccesTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation RegisterationSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_btnLogin setTitle:[CommonFunction getLocalisedString:@"Login"] forState:UIControlStateNormal];
    _lblSuccesTitle.text = [CommonFunction getLocalisedString:@"RegisterationSuccessTitle"];
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
- (IBAction)registerPageAction:(id)sender {
    [CommonFunction setLoginRootViewControllerWithAnimation];
}

@end
