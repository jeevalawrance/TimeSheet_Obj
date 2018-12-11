//
//  TS_ProjectCreationViewController.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/11/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "TS_ProjectCreationViewController.h"
#import "LocationShareViewController.h"
#import "NearLocation.h"

@interface TS_ProjectCreationViewController ()<LocationShareViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtProjectName;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectName;

@end

@implementation TS_ProjectCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)locationSelectionPressed:(NearLocation*)location
{
    self.lblProjectName.text = location.title;
}
- (IBAction)locationAction:(id)sender
{
    LocationShareViewController *loc = [self.storyboard instantiateViewControllerWithIdentifier:@"locationShareVC"];
    loc.delegate = self;
    [self presentViewController:loc animated:YES completion:nil];
//
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
