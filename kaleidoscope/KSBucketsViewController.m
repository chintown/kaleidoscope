//
//  KSBucketViewController.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/15/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "KSStates.h"
#import "KSCardProxy.h"
#import "KSBucketsViewController.h"

@interface KSBucketsViewController ()

@end

@implementation KSBucketsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"//========== view did load @ BUCKET ");
    [super viewDidLoad];
    //self.title = @"Buckets";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // should be updated frequently
//    [KSCardProxy delegate: self];
//    [KSCardProxy queryBuckets];

    // pull-to-refresh mechanism
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self
                action:@selector(triggerRefreshControl:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"//========== view did appear @ BUCKET");
    [super viewDidAppear:animated];
    [KSStates setLastRootTab:KS_TAB_INDEX_LOOKDOWN];

    [KSCardProxy delegate: self];
    [KSCardProxy queryBuckets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Object Utils
- (NSIndexPath *)fetchIndexPathFromCell:(UITableViewCell *) cell {
    UITableView* table = (UITableView *)[cell superview];
    NSIndexPath* path = [table indexPathForCell:cell];
    return path;
}
- (void) updateBucketSourceWithResult: (NSDictionary *) result {
    NSDictionary *buckets = [KSStates getBucketSource];

    [result enumerateKeysAndObjectsUsingBlock:^(NSString *lv, NSDictionary *item, BOOL *STOP) {
        int idx = [lv intValue] - 1;
        NSString *key = [NSString stringWithFormat:@"%d", idx];
        
        // 1. extract information from item
        NSString *lastCid = [item valueForKey: @"sidx"];
        int num = [[item valueForKey: @"num"] intValue];
        int capacity = [[item valueForKey: @"capacity"] intValue];
        NSNumber *isFull = [NSNumber numberWithBool: (capacity - num <= KS_BUCKET_FULL_THRESHOLD)];
        NSString *detail = [NSString stringWithFormat: @"%3d",
                            //100 * num / capacity,
                            num
                            ];
        NSString *title = [NSString stringWithFormat: @"Lv %@ [%d]", lv, capacity];

        // 2. get data source object for current index
        NSDictionary *bucket = (NSDictionary *)[buckets valueForKey:key];

        // 3. update data source item
        [bucket setValue:title forKey:@"title"];
        [bucket setValue:detail forKey:@"detail"];
        [bucket setValue:lastCid forKey:@"lastCid"];
        [bucket setValue:isFull forKey:@"isFull"];
        [bucket setValue:[NSNumber numberWithInt:num] forKey:@"num"];

    }];

    // 4. save data source
    [KSStates setBucketSource:buckets];

    // 5. reload
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
//    // FIXME require reload
//    [self.tableView reloadRowsAtIndexPaths:indexPaths
//                          withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ////NSLog(@"===== update cell data source =====");
    // 1. fetch cell instance -----
    
    NSString *identifier = [NSString stringWithFormat: @"bucket cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    ////NSLog(@"%@", cell);

    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:      UITableViewCellStyleDefault
                reuseIdentifier:    identifier];
        //[cell.textLabel setFont: [UIFont fontWithName: @"Arial" size: 17]];
    }
    
    // 2. setup cell display content -----
    NSDictionary *bucket = [KSStates getBucketSourceAtIndex: indexPath.row];

    NSString *title = [NSString stringWithFormat:@"Lv %d", indexPath.row];
    NSString *detail = @"...";
    BOOL isFull = NO;
    if (bucket != nil) {
        title = [bucket valueForKey:@"title"];
        detail = [bucket valueForKey:@"detail"];
        isFull = [[bucket valueForKey:@"isFull"] boolValue];
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    if (isFull) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    //NSLog(@"========== bucket - segue - stack ==========");
    
    // save information of selected bucket in state object
    UITableViewCell *cell = (UITableViewCell *) sender;
    int idxCell = [self fetchIndexPathFromCell: cell].row;
    int bid = (idxCell + 1);
    [KSStates setBid: bid];
    [KSStates updateCidAmongLastRefWithOffset: 0];
    [KSStates resetCardSource];
}

#pragma mark - NewsProxy delegate
- (void) proxyDidLoadBucketsWithResult: (NSDictionary *) result {
    [self updateBucketSourceWithResult: result];
}

#pragma mark - RefreshControl delegate
-(void) triggerRefreshControl:(UIRefreshControl *)refresh {
    [self updateRefreshControl:refresh withHint:@"Refreshing data..."];

    [KSCardProxy queryBuckets];

    [self windupRefreshControl:refresh];
    [refresh endRefreshing];

}

- (void) prepareRefreshControl: (UIRefreshControl *)refresh {
    [self updateRefreshControl:refresh withHint:@"Pull to Refresh"];
}
- (void) updateRefreshControl: (UIRefreshControl *)refresh
                     withHint:(NSString *)hint {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString: hint];
}
- (void) windupRefreshControl: (UIRefreshControl *)refresh {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdate = [NSString stringWithFormat: @"%@",
                            [formatter stringFromDate:[NSDate date]]
                            ];

    NSString *hint = [NSString stringWithFormat: @"Last updated on %@", lastUpdate];
    [self updateRefreshControl:refresh withHint:hint];
}

@end
