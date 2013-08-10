//
//  KSHeadlineViewController.h
//  kaleidoscope
//
//  Created by Mike Chen on 8/9/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSHeadlineViewController : UITableViewController<KSCardProxyDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) NSDictionary *dataHeadline;

@end
