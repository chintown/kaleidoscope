//
//  KSHeadlineViewController.m
//  kaleidoscope
//
//  Created by Mike Chen on 8/9/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "UtilColor.h"
#import "KSStates.h"
#import "KSHeadlineCell.h"
#import "KSCardProxy.h"
#import "KSHeadlineViewController.h"

@interface KSHeadlineViewController ()

@end

@implementation KSHeadlineViewController

@synthesize dataHeadline;
@synthesize toggleLookup;

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
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // long press handler
    UILongPressGestureRecognizer *lpgr =
        [[UILongPressGestureRecognizer alloc]
            initWithTarget:self
            action:@selector(didLongPress:)
         ];
    lpgr.minimumPressDuration = 0.4; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];

    // pull-to-refresh mechanism
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self
                action:@selector(triggerRefreshControl:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"//========== view did appear @ HEADLINE");
    [super viewDidAppear:animated];
    [KSStates setLastRootTab:KS_TAB_INDEX_LOOKAHEAD];

    [KSCardProxy delegate: self];
    [KSCardProxy queryHeadline];
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
- (void) updateHeadlineSourceWithResult: (NSDictionary *) result {
    [KSStates setHeadlineSource:result];

    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}
- (BOOL)isCellToggled:(int)index {
    NSString *key = [NSString stringWithFormat:@"%d", index];
    NSNumber *isToggled = [toggleLookup valueForKey:key];
    return isToggled != nil && [isToggled boolValue] == YES;
}
- (void)toggleCell:(int)index {
    NSString *key = [NSString stringWithFormat:@"%d", index];
    NSNumber *isToggled = [toggleLookup valueForKey:key];
    isToggled = [NSNumber numberWithBool: ![isToggled boolValue]];
    [toggleLookup setValue:isToggled forKey:key];
//    de(toggleLookup);
//    de([self isCellToggled:0] ? @"YES" : @"NO");
}

#pragma mark - Table view data source

- (NSString *)fetchHeadlineForIndex:(int)index withLang:(NSString *)lang {
    NSDictionary *headline = [KSStates getHeadlineSourceAtIndex: index];
    NSString *selected = [headline valueForKey:lang];
    return selected;
}
- (NSString *)fetchHighlightForIndex:(int)index withLang:(NSString *)lang {
    NSDictionary *headline = [KSStates getHeadlineSourceAtIndex: index];
    NSString *selected = [headline valueForKey:[NSString stringWithFormat:@"%@_highlight", lang]];
    return selected;
}

- (NSString *)fetchSubTextForIndex:(int)index {
    NSDictionary *headline = [KSStates getHeadlineSourceAtIndex: index];
    return [NSString stringWithFormat:@"%@ - %@",
            [headline valueForKey:@"timestamp"],
            [headline valueForKey:@"provider"]
            ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[KSStates getHeadlineSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. fetch cell instance -----
    NSString *identifier = [NSString stringWithFormat: @"headline cell"];
    KSHeadlineCell *cell = (KSHeadlineCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
//        cell = [[UITableViewCell alloc]
//                initWithStyle:      UITableViewCellStyleDefault
//                reuseIdentifier:    identifier];
        //[cell.textLabel setFont: [UIFont fontWithName: @"Arial" size: 17]];

        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"KSHeadlineCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[KSHeadlineCell class]]) {
                cell = (KSHeadlineCell *)currentObject;
                break;
            }
        }
    }

    BOOL isToggled = [self isCellToggled:indexPath.row];
    NSString *lang = isToggled ? @"ch" : @"en";

    cell.subText.text = [self fetchSubTextForIndex:indexPath.row];
    NSString *headline = [self fetchHeadlineForIndex:indexPath.row withLang:lang];
    NSString *highlight = [self fetchHighlightForIndex:indexPath.row withLang:lang];
    NSMutableAttributedString *coloredHeadline =
        [UtilColor highlightString:highlight
                            InText:headline
                         WithColor:[UtilColor colorFromHexString:@"000000"]
                withBackgroundColor:[UtilColor colorFromHexString:@"FFD"]
                      withFontName:@"Verdana"
                      withFontSize:16
         ];
    [cell.headline setAttributedText:coloredHeadline];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isToggled = [self isCellToggled:indexPath.row];
    NSString *lang = isToggled ? @"ch" : @"en";
    NSString *headline = [self fetchHeadlineForIndex:indexPath.row withLang:lang];
    CGSize size = [headline sizeWithFont:[UIFont fontWithName:@"Verdana" size:14]];
    return tableView.rowHeight + size.height + 50;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [self toggleCell:indexPath.row];
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

#pragma mark - Long press delegate
-(void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tableView];

    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
        return;
    }

    NSString *query = [self fetchHighlightForIndex:indexPath.row
                                          withLang:@"en"];
    NSString *headline = [self fetchHeadlineForIndex:indexPath.row withLang:@"en"];
    [KSStates setHeadLineQuery:query];
    [KSStates setHeadLine:headline];
    self.tabBarController.selectedIndex = KS_TAB_INDEX_LOOKUP;
}

#pragma mark - NewsProxy delegate
- (void) proxyDidLoadHeadlineWithResult: (NSDictionary *) result {
    toggleLookup = [[NSMutableDictionary alloc] init];
    [self updateHeadlineSourceWithResult: result];
}

#pragma mark - RefreshControl delegate
-(void) triggerRefreshControl:(UIRefreshControl *)refresh {
    [self updateRefreshControl:refresh withHint:@"Refreshing data..."];

    [KSCardProxy queryHeadline];

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
