//
//  KSCardStackViewController.h
//  kaleidoscope
//
//  Created by Mike Chen on 3/29/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCardViewController.h"
#import "CTPagedScrollView.h"

@interface KSSlotViewController : UIViewController<CTPagedScrollViewDataSource, KSCardViewControllerDelegate>
@property (weak, nonatomic) IBOutlet CTPagedScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pronounce;
- (IBAction)playPronounce:(id)sender;

@end
