//
//  TS_DashboardCellCollectionViewCell.h
//  ScrollingPOC
//
//  Created by Jeeva on 12/11/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TS_DashboardCellCollectionViewCell : UICollectionViewCell
@property (nonatomic , weak) IBOutlet UIView *viewShadow;
@property (nonatomic , weak) IBOutlet UIView *viewContainer;
@property (nonatomic , weak) IBOutlet UIView *viewTop;
@property (nonatomic , weak) IBOutlet UIImageView *image;
@property (nonatomic , weak) IBOutlet UILabel *lblTile;
@property (nonatomic , weak) IBOutlet UILabel *lblSubTile;
@end

NS_ASSUME_NONNULL_END
