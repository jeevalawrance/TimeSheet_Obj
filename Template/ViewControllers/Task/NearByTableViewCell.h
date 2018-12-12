//
//  NearByTableViewCell.h
//  TestTopView
//
//  Created by cpd on 8/30/17.
//  Copyright © 2017 cpd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UIImageView *thumpImageView;

@end
