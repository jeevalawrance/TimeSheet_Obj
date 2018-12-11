//
//  TS_DashboardCellCollectionViewCell.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/11/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "TS_DashboardCellCollectionViewCell.h"

@implementation TS_DashboardCellCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.viewTop.backgroundColor = [UIColor whiteColor];
    self.viewShadow.layer.cornerRadius = 10;
    self.viewShadow.layer.shadowOffset = CGSizeMake(2, 6);
    
    self.viewContainer.layer.cornerRadius = 10;

    
}

@end
