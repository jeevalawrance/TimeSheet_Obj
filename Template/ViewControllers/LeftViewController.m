//
//  LeftViewController.m
//  ScrollingPOC
//
//  Created by Anthony on 11/7/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftTableViewCell.h"

@interface LeftViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"leftCell";
    
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    cell.lblTitle.text = [NSString stringWithFormat:@"Cell %li", (long)indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - Button Actions

- (IBAction)settingAction:(id)sender
{
}
- (IBAction)profileAction:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    
    UIViewController *myProfile = [storyBoard instantiateViewControllerWithIdentifier:@"registerVC"];
    
    [self.navigationController pushViewController:myProfile animated:YES];
    
//    {
//
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:kStoryboardNameAchievements bundle:nil];
//        UIViewController *achieveMent         = [sb instantiateInitialViewController];
//
//          
//        ContainerViewController *container = [[ContainerViewController alloc] initWithLeftVC:nil rightVC:nil topVC:menuVC bottomVC:achievementsDVC middleVC:achieveMent];
//        rootView = container;
//        if (presentedFrom==kPresentedFromNotification)
//        {
//            [container moveVerticalScrollViewTo:kVerticalScrolIndexBottom withAnimation:TRUE];
//        }
//
//
//    }
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
