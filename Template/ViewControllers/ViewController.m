//
//  ViewController.m
//  Template
//
//  Created by Anthony on 11/1/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "ViewController.h"
#import "NetworkLayer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NetworkLayer getInstance] downloaSqliteToPath:@"chat.sqlite" withServerURL:@"https://mirsalassets.devinprocess.com/UserMedia/Assets/d2e18e6a-71bd-4fe0-9507-5051af070742/Folder/GetHHPOChat-64205.sqlite"  withCompletion:^(BOOL completed, NSURL *source_url, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
