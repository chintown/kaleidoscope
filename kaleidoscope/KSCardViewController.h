//
//  KSCardViewController.h
//  kaleidoscope
//
//  Created by Mike Chen on 3/20/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCardProxy.h"
#import "KSDetailVeiwController.h"

@protocol KSCardViewControllerDelegate <NSObject>
- (void)didCardRemoved:(int)index;
@end


@interface KSCardViewController : UIViewController
                                <KSCardProxyDelegate, KSCardbackDelegate>

@property (nonatomic, strong) id<KSCardViewControllerDelegate> delegate;

@property (nonatomic) KSCard *card;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSound;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbNumForgot;
@property (weak, nonatomic) IBOutlet UITextView *viewSentences;
@property (weak, nonatomic) IBOutlet UIScrollView *uiFlickr;
@property (weak, nonatomic) IBOutlet UIWebView *uiAssist;
@property (weak, nonatomic) IBOutlet UILabel *lbPager;
@property (weak, nonatomic) IBOutlet UIButton *btnFlip;
@property (weak, nonatomic) IBOutlet UIButton *btnToggleHint;
@property (nonatomic) KSDetailVeiwController *backController;

- (IBAction)playSound:(id)sender;
- (IBAction)flipCard:(id)sender;
- (IBAction)toggleHint:(id)sender;

@end
