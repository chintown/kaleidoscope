//
//  KSCardStackViewController.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/29/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KSCard.h"
#import "KSSlotViewController.h"
#import "KSCardViewController.h"
#import "KSStates.h"

#define WIDTH_PAGE 320
#define HEIGHT_PAGE 400

@interface KSSlotViewController ()

- (UIView *) newPageView;
- (void) setPageViewDisplay: (UIView *) page
                  withIndex: (int) idx;

@end

@implementation KSSlotViewController

@synthesize scrollView;

- (id)init {
    self = [super init];
    NSLog(@"===== XX init @ StackViewController =====");
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"[init with coder @ Stack]");
    self = [super initWithCoder:aDecoder];
    if (self) {
        ////[self initInternals];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"===== XX init with nib name @ StackViewController =====");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //NSLog(@"===== view did load @ StackViewController =====");
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if (self.scrollView.dataSource == nil) {
        [self initInternals];
        [self.scrollView selfInit];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initInternals {
    NSAssert(self.scrollView != nil, @"scroll view must be bind before!");
    //NSLog(@">>>>> scroll view must be bind before!");
    self.scrollView.dataSource = self;
}

#pragma mark - Page View Setup

- (UIView *) newPageView {
    CGSize pageSize = [self pageCGSize];
    CGRect frame = CGRectMake(0.0, 0.0, pageSize.width, pageSize.height);
    UIView *page = [[UIView alloc] initWithFrame:frame];
    [[page layer] setCornerRadius:30.0];
    [[page layer] setMasksToBounds:YES];


    UILabel *lbTitle = [[UILabel alloc] initWithFrame:frame];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setBackgroundColor:[UIColor clearColor]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    [lbTitle setTag: 999999];

    [page addSubview:lbTitle];
    return page;
}

- (KSCardViewController *) newPageViewController {
    KSCardViewController *controller = [[KSCardViewController alloc] initWithNibName:@"KSCardViewController" bundle:Nil];
    [controller.view setBounds: CGRectMake(0, 0, [self pageCGSize].width, [self pageCGSize].height)];
    [[controller.view layer] setCornerRadius:30.0];
    [[controller.view layer] setMasksToBounds:YES];
    return controller;
}

- (void) setPageViewDisplay: (UIView *) page
                  withIndex: (int) idx {
    int numColorPeriod = [self numReusablePages];
    NSInteger mods = idx % numColorPeriod;
    if (mods < 0) {
        mods += numColorPeriod;
    }
    CGFloat red = mods * (1 / (CGFloat)numColorPeriod);
    UIColor *pageColor = [UIColor colorWithRed:red green:0.0 blue:0.0 alpha:1.0];

    page.backgroundColor = pageColor;
    UILabel *lbTitle = (UILabel *)[page viewWithTag: 999999];
    lbTitle.text = [NSString stringWithFormat:@"%d", idx];
}

#pragma mark - Scroll View's Data Source

- (NSUInteger) numReusablePages {
    return 3;
}
- (CGSize) pageCGSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenH = screenRect.size.height;
    return CGSizeMake(WIDTH_PAGE, screenH - 160); // HEIGHT OF CARD
}
- (CGFloat) wrapperWidth {
    int bid = [KSStates getBid];
    NSDictionary *bucket = [KSStates getBucketSourceAtIndex:bid - 1]; // id is idx + 1
    int num = [[bucket valueForKey:@"num"] intValue];
    return WIDTH_PAGE * num;
}
- (UIView *)pageView:(CTPagedScrollView*)scrollView forIndex:(NSInteger) pageIndex {
    // BOUND PROTETION //
    NSDictionary *bucket = [KSStates getBucketSourceAtIndex:[KSStates getBid] - 1]; // id is idx + 1
    int loadingCid = [KSStates getCidAmongLastRefWithOffset:pageIndex];
    if (loadingCid < 0 || [[bucket valueForKey:@"num"] intValue] <= loadingCid) {
        NSLog(@"[O] (NO) page for index %d. out of bound", loadingCid);
        return nil;
    }
    // BOUND PROTETION //

    UIView *page = [self.scrollView dequeueReusablePage];

    if (page == nil) {
        NSLog(@"[O] (NEW) page for index %d", pageIndex);
        ////page = [self newPageView];
        KSCardViewController *pageController = [self newPageViewController];
        pageController.delegate = self;

        [self addChildViewController: pageController];
        page = pageController.view;
    } else {
        NSLog(@"[O] (REUSE) page for index %d", pageIndex);
    }

    [self setPageViewDisplay: page withIndex:pageIndex];

    return page;
}

- (BOOL) hasDataWithLowerIndex {
    return (![KSStates isLowBoundInBucket]);
}
- (BOOL) hasDataWithHigherIndex {
    return (![KSStates isUpBoundInBucket]);
}
- (void) scollDidLandOnPageWithIndex: (int) pageIndex {
    int landCid = [KSStates updateCidAmongLastRefWithOffset:pageIndex];
    NSLog(@"[O] land on cid %d. update KStates. %d", landCid, pageIndex);
}
- (int) currentIndex {
    return [KSStates getCid];
}

#pragma mark - Card View Delegate
- (void)didCardRemoved:(int)index {
    de([NSString stringWithFormat:@"%d card removed", index]);
//    [self.scrollView updateVisibleBoundToPositionOfCurrentIndex];
//    [self.scrollView layoutSubviews];
    [self.scrollView initInternals];
    self.scrollView.dataSource = nil;
    [self viewDidLoad];
}

# pragma mark IB delegate
- (IBAction)playPronounce:(id)sender {
    KSCard *card = [KSStates getCardSourceAtIndex:[KSStates getCid]];
    NSString *word = card.word;

    [KSCardProxy playGooglePronunciationByWord:word withView:self.view];
}
@end
