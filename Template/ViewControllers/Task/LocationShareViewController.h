//
//  LocationShareViewController.h
//  HHPOChat
//
//  Created by Dipin on 8/29/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NearLocation;

@protocol LocationShareViewControllerDelegate <NSObject>

-(void)locationSelectionPressed:(NearLocation*)location;

@end

@interface LocationShareViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblRecentSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblLocationNearby;
@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;
@property (nonatomic, strong) NSString *replyMessageContent;

@property (nonatomic, assign) id<LocationShareViewControllerDelegate> delegate;

@end
