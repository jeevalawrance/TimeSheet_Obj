//
//  TS_ProjectListViewController.m
//  ScrollingPOC
//
//  Created by Jeeva on 12/11/18.
//  Copyright © 2018 CPD. All rights reserved.
//

#import "TS_ProjectListViewController.h"
#import "URLConstants.h"
#import "CoreDataController.h"
#import "TS_ProjectCreationViewController.h"

@interface TS_ProjectListViewController ()
{
    NSManagedObjectContext *context;

}
@property (nonatomic , weak) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , weak) IBOutlet UIImageView *image;
@property (nonatomic , weak) IBOutlet UILabel *lblTile;
@property (nonatomic , weak) IBOutlet UILabel *lblSubTile;
@property (weak, nonatomic) IBOutlet UIView *viewProject;
@property (weak, nonatomic) IBOutlet UIButton *btnAddProject;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TS_ProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CoreDataController* coredataVC = [CoreDataController sharedInstance];
    context=[coredataVC managedObjectContext];

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProjectAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    /*
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    */

}
- (NSFetchedResultsController *)fetchedResultsController{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PropertList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

//     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaType ='V'"];
//    [fetchRequest setPredicate:predicate];
//
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
//                              initWithKey:@"dateAdded" ascending:NO];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    // [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate =(id) self;
//    isFetchedResultControllerCalled=TRUE;
    return _fetchedResultsController;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
//    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)addProjectAction:(id)sender
{
    TS_ProjectCreationViewController *loc = [self.storyboard instantiateViewControllerWithIdentifier:@"TS_ProjectCreationViewControllerVC"];

    [self.navigationController pushViewController:loc animated:YES];
}

#pragma mark-
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
