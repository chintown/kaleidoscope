//
//  KSLookupViewController.h
//  kaleidoscope
//
//  Created by Mike Chen on 3/15/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSLookupViewController : UIViewController<UISearchBarDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *sitesbar;

-(void) query: (NSString *) term;
@end
