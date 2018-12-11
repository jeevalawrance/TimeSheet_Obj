//
//  CenterViewController.m
//  ScrollingPOC
//
//  Created by Anthony on 11/7/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *cvVrticalScroll;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        _cvVrticalScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = FALSE;
    }
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"verticalCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *lblCentr = [cell viewWithTag:1];
    lblCentr.text = [NSString stringWithFormat:@"MIDDLE VIEW %d",((int)(indexPath.row)+1)];
    
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255. green:(arc4random()%255)/255. blue:(arc4random()%255)/255. alpha:1.];
    return cell;

}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
