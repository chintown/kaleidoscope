//
//  KSLookupViewController.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/15/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "KSStates.h"
#import "KSLookupViewController.h"

@interface KSLookupViewController ()

@end

@implementation KSLookupViewController {
    NSDictionary *configs;
}

@synthesize searchBar;
@synthesize sitesbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initSitesBar: (UIToolbar *) toolbar {
    configs = @{
      @"1.Wordnik": @"http://www.wordnik.com/words/",
      @"4.Nciku": @"http://m.nciku.com/en/en/detail/?query=",
      @"2.Termly": @"http://term.ly/",
      @"3.Yahoo": @"http://tw.dictionary.search.yahoo.com/search?p="
    };
    __block NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[configs allValues]];
    [configs enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSString *queryFmt, BOOL *STOP) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStyleBordered target:self action:@selector(switchSearch:)];
        int order = [[[name componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
        //[items addObject: item];
        [items replaceObjectAtIndex:order-1 withObject:item];
    }];
    [toolbar setItems:items animated:NO];
}

- (void)viewDidLoad
{
    NSLog(@"====== Lookup view did load ======");
    [super viewDidLoad];

    [self initSitesBar: sitesbar];
    self.webView.delegate = self;
    self.searchBar.delegate = self;

    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(bringQueryToLookupView:)
        name:@"bringQueryToLookupView"
        object:nil];
}

- (void) dealloc {
    // avoid Notification Center keeps sending notification objects to the deallocated object.
    [[NSNotificationCenter defaultCenter]
        removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
    NSString *hintQuery = [NSString stringWithFormat: @" %@ (clipboard)",
                           [self parseQueryFromClipboard]];
    self.searchBar.placeholder = hintQuery;

    NSString *query = [KSStates getHeadlineQuery];
    NSString *headline = [KSStates getHeadline];
    if (query != nil) {
        searchBar.text = query;
        //[searchBar becomeFirstResponder];
        [self query:query withSentence:headline];
        [searchBar resignFirstResponder];
        [KSStates setHeadLineQuery:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark Task Util
- (NSString *) normQuery: (NSString*) query {
    return[query lowercaseString];
}
- (NSString *) parseQueryFromClipboard {
    NSString *query = [UIPasteboard generalPasteboard].string;
    NSString *normQuery = [self normQuery:query];
    return normQuery;
}

# pragma mark UIWebViewDelegate
-(void) webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

# pragma mark UISearchBarDelegate > UISearchBar
-(void) searchBarSearchButtonClicked:(UISearchBar *)sender {
    [sender resignFirstResponder];
    
    [self query: sender.text];
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)sender {
    if (![sender.text isEqualToString: @""]) {
        [sender resignFirstResponder];
    } else {
        self.tabBarController.selectedIndex = [KSStates getLastRootTab];
    }
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)sender {
    NSString *normQuery = [self parseQueryFromClipboard];
    sender.text = normQuery;
    [sender becomeFirstResponder];
}

# pragma mark Self > UIWebView
-(void) query: (NSString *) term {
    NSString *root = @"http://www.chintown.org/lookup/?query=";
    root = [root stringByAppendingString:term];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:root]];
    
    [self.webView loadRequest:request];
}

-(void) query: (NSString *) term withSentence:(NSString *) sentence{
    sentence = [sentence stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *root = [NSString stringWithFormat:@"http://www.chintown.org/lookup/?query=%@&sentence=%@",
                      term,
                      sentence
                      ];
    ;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:root]];

    [self.webView loadRequest:request];
}

# pragma mark URL open delegate
- (void) bringQueryToLookupView:(NSNotification *) notification {
    // no need to check; this method is a dedicated one
    //if ([[notification name] { isEqualToString:@"TestNotification"]) }
    NSString *query = [notification.userInfo objectForKey:@"query"];
    [self query:query];
}

#pragma mark Switch Query Site
- (void) switchSearch: (id)sender {
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    NSString *root = [configs valueForKey:[item title]];
    NSString *query = [root stringByAppendingString:searchBar.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:query]];

    [self.webView loadRequest:request];
}

@end
