//
//  TS_DashboardViewController.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/11/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "TS_DashboardViewController.h"
#import "TS_DashboardCellCollectionViewCell.h"

typedef NS_ENUM(NSInteger, DashboardMenuOrder) {
    kSiteWise,
    kTaskWise,
    kTaskInput,
    kActivity,
    kDashBoardCount,
};
static NSString *rowIndex     =   @"index";
static NSString *title     =   @"title";
static NSString *subTitle     =   @"subTitle";
static NSString *image     =   @"image";

@interface TS_DashboardViewController ()
@property (nonatomic,strong) NSArray *dashArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TS_DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.dashArray = [[NSMutableArray alloc] init];
    
    self.dashArray = @[@{rowIndex : @0,
                         title : @"Site-Wise",
                         subTitle : @"List Report",
                         image:@"sitewise"
                         },
                       @{rowIndex : @2,
                         title : @"Task-Wise",
                         subTitle : @"List Report",
                         image:@"chart"
                         },
                       @{rowIndex : @3,
                         title : @"Task Input",
                         subTitle : @"Work Input",
                         image:@"task"
                         },
                       @{rowIndex : @4,
                         title : @"Activity",
                         subTitle : @"Workers activity",
                         image:@"Activity"
                         }
                       ];


}
- (IBAction)signoutAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"CONFIRM" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

#pragma mark - UICOLLECTIONVIEW DATASOURCE & DELEGATE

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float screenWidth = [UIScreen mainScreen].bounds.size.width / 2.0 - 10;
    CGSize cellSize = CGSizeMake(screenWidth, screenWidth);
    
    return cellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dashArray.count;

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"dashboard_cell_id";
    
    TS_DashboardCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *dict = [self.dashArray objectAtIndex:indexPath.row];
    
    cell.lblTile.text = dict[title];
    cell.image.image = [UIImage imageNamed:dict[image]];
    cell.lblSubTile.text = dict[subTitle];
    

    //    self.viewShadow.layer.cornerRadius = 10
    //    self.viewShadow.layer.shadowOffset = CGSize(width: 2, height: 6) //CGSizeMake(2, 6)
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    
//    imageView.image = [UIImage imageNamed:[onlyImages objectAtIndex:indexPath.row]];
//    
//    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//    
//    [cell.contentView addSubview:imageView];
    
    return cell;
    
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
