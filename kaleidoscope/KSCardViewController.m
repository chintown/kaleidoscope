//
//  KSCardViewController.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/20/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "KSStates.h"
#import "KSCard.h"
#import "KSCardProxy.h"
#import "KSCardViewController.h"

@interface KSCardViewController ()

@end

@implementation KSCardViewController {
    int loadingCid;
}

@synthesize card;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initGestures {
    UISwipeGestureRecognizer* forwardGesture =
        [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(forwardSwip)];
	[forwardGesture setDirection:UISwipeGestureRecognizerDirectionLeft];

    UISwipeGestureRecognizer* backwardGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(backwardSwip)];
	[backwardGesture setDirection:UISwipeGestureRecognizerDirectionRight];

    UISwipeGestureRecognizer* confidentGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(confidentSwip)];
	[confidentGesture setDirection:UISwipeGestureRecognizerDirectionDown];

    UISwipeGestureRecognizer* unconfidentGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(unconfidentSwip)];
	[unconfidentGesture setDirection:UISwipeGestureRecognizerDirectionUp];


    //[self.view addGestureRecognizer:forwardGesture];
    //[self.view addGestureRecognizer:backwardGesture];
    [self.view addGestureRecognizer:confidentGesture];
    [self.view addGestureRecognizer:unconfidentGesture];
}

- (void) initCardProxy {
    // query card
    [KSCardProxy delegate: self];
}

- (void) initViewDisplay {
    int bid = [KSStates getBid];
    NSDictionary *bucket = [KSStates getBucketSourceAtIndex:bid];
    self.title = [bucket valueForKey:@"title"];

}

- (void)viewDidLoad
{
    NSLog(@"[view did load @ Card]");
    [super viewDidLoad];

    ////[self initViewDisplay];
    [self initGestures];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    // appear might be slightly appear but not focus
    [super viewDidAppear:animated];
    NSLog(@"===== did appear @ Card %d =====", self.view.tag);

    [self initCardProxy];
    int bid = [KSStates getBid];
    NSDictionary *bucket = [KSStates getBucketSourceAtIndex:bid - 1]; // id is idx + 1
    loadingCid = [KSStates getCidAmongLastRefWithOffset:self.view.tag];
    [self resetViewContentWithCardIndex: loadingCid];

    // BOUND PROTETION //
    if (loadingCid < 0 || [[bucket valueForKey:@"num"] intValue] <= loadingCid) {
        NSLog(@"        [C] (SKIP) downloading cid %d. out of bound", loadingCid);
        // we should inform data source stop giving view
        return;
    }
    // BOUND PROTETION //

    // load next card
    if ([KSStates isExsitingCardSourceAtIndex:loadingCid]) {
        [self setViewContentWithCardIndex:loadingCid];
    } else {
        NSLog(@"        [C] downloading bid=%d cid=%d (%d + %d) ...", bid, loadingCid, loadingCid-self.view.tag, self.view.tag);
        [KSCardProxy queryCardOfBucketId:bid
                               OfCardIdx:loadingCid];
    }
}

#pragma mark Task Util
- (NSString *) vocabulary {
    return self.lbTitle.text;
}
- (void) setViewContentWithCardIndex:(int)cid {
    KSCard *cardCache = [KSStates getCardSourceAtIndex:cid];
    self.lbTitle.text = cardCache.word;
    self.lbNumForgot.text = [cardCache.forgot stringValue];
    self.viewSentences.text = cardCache.sentences;
    
    NSString *num = [[KSStates getBucketSourceAtIndex:[KSStates getBid]-1] valueForKey:@"num"];
    self.lbPager.text = [NSString stringWithFormat:@"%d/%@", cid+1, num];
}
- (void) resetViewContentWithCardIndex:(int)cid {
    self.lbTitle.text = [NSString stringWithFormat:@"%d", cid];
    self.lbNumForgot.text = @"";
    self.viewSentences.text = @"";
    self.lbPager.text = @"";
}

#pragma mark - IB delegate
- (IBAction)playSound:(id)sender {
    [KSCardProxy playGooglePronunciationByWord: [self vocabulary]
                                      withView: self.view];
}

- (IBAction)flipCard:(id)sender {
    //[self performSegueWithIdentifier:@"showCardback" sender:sender];
    //KSCardbackVeiwController *backController = [[KSCardbackVeiwController alloc] initWithNibName:@"KSCardbackVeiwController" bundle:nil];
    //KSCardbackVeiwController *backController = [[KSCardbackVeiwController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    //KSCardbackVeiwController *backController = [storyBoard instantiateInitialViewController];
    if (self.backController == nil) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle:NULL];
        self.backController = [storyBoard instantiateViewControllerWithIdentifier:@"KSCardbackVeiwController"];
        self.backController.delegate = self;
        self.backController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    }
    [self presentViewController:self.backController animated:YES completion:nil];
}
- (void)tapFlickr:(UIGestureRecognizer *)gestureRecognizer {
//    if (!gestureRecognizer.view.tag) {
//        [UIView animateWithDuration:0.5f animations:^{
//            gestureRecognizer.view.frame = CGRectMake(0,0,300,300);
//        }];
//        gestureRecognizer.view.tag = 1;
//    }
//    NSLog(@"%@", gestureRecognizer.view);
}

#pragma mark - NewsProxy delegate
- (void)proxyDidLoadCardWithResult:(NSDictionary *)result {
    [result setValue:[[result valueForKey:@"word"] lowercaseString]
              forKey:@"word"];
    KSCard *cardCache = [[KSCard alloc] init];
    cardCache.word = [[result valueForKey:@"word"] lowercaseString];
    cardCache.level = [NSNumber numberWithInt:[[result valueForKey:@"level"] intValue]];
    cardCache.forgot = [NSNumber numberWithInt:[[result valueForKey:@"forgot"] intValue]];
    cardCache.tip = [result valueForKey:@"tip"];
    cardCache.cMean = [result valueForKey:@"meaning"];
    cardCache.sentences = [result valueForKey:@"sentence"];

    self.card = cardCache;
    [KSStates setCardSource:card atIndex:loadingCid];
    [self setViewContentWithCardIndex:loadingCid];

    // --
    //[KSCardProxy queryFlickr:cardCache.word];
    [KSCardProxy queryMap:cardCache.word];

}
- (void)proxyDidLoadFlickrWithResult:(NSDictionary *)result {
    //NSLog(@"%@", result);
    [self.uiFlickr setBackgroundColor:[UIColor grayColor]];
    NSArray *_result = (NSArray *)result;

    CGFloat itemWidth = self.uiFlickr.frame.size.width;
    CGFloat itemHeight = self.uiFlickr.frame.size.height;
    NSLog(@"%@",self.uiFlickr);
    __block CGFloat x = 0;
    [[self.uiFlickr subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *STOP) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }];
    [_result enumerateObjectsUsingBlock:^(NSDictionary *profile, NSUInteger idx, BOOL *STOP) {
        CGFloat desHeight = self.uiFlickr.frame.size.height;
        float ratioImage = [(NSNumber *)[profile valueForKey:@"width"] floatValue]
                            / [(NSNumber *)[profile valueForKey:@"height"] floatValue];
        CGFloat desWidth = ratioImage * desHeight;

        CGRect frame;
        frame.origin.x = x; //itemWidth * idx;
        frame.origin.y = 0;
        //frame.size = self.uiFlickr.frame.size;
        frame.size.width = desWidth;
        frame.size.height = desHeight;
        x += frame.size.width;

        UIImageView *item = [[UIImageView alloc] initWithFrame:frame];
        item.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFlickr:)];
        [item addGestureRecognizer:tap];
        [item setImageWithURL:[NSURL URLWithString:[profile valueForKey:@"src"]]];

        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        [btn setBackgroundImage:[UIImage imageNamed:@"app.icon@2x.png"] forState:UIControlStateNormal];

        [self.uiFlickr addSubview:item];
    }];
    self.uiFlickr.contentSize =
    CGSizeMake(itemWidth * [result count], itemHeight);
}
- (void)proxyDidLoadMapWithResult:(NSString *)result {
    //NSLog(@"%@",result);
    NSString *html = [NSString stringWithFormat:@"<html><head><style></style><body>%@</body></html>", result];
    [self.uiAssist loadHTMLString:html baseURL:nil];
    [self.uiAssist setBackgroundColor:[UIColor clearColor]];
}
#pragma mark - Cardback delegate

- (void)cardbackDidFinish:(KSDetailVeiwController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (KSCard *)getCard {
    return self.card;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCardback"]) {
        KSDetailVeiwController *destController = [segue destinationViewController];
        [destController setDelegate:self];
    }
}

#pragma mark - Gesture delegate
- (void) forwardSwip {
    NSLog(@"forward");
}
- (void) backwardSwip {
    NSLog(@"backward");
}
- (void) confidentSwip {
    NSLog(@"confident");
    [KSCardProxy upgradeCardWord:self.lbTitle.text fromBucket:[KSStates getBid]];
}
- (void) unconfidentSwip {
    NSLog(@"unconfident");
    [KSCardProxy downgradeCardWord:self.lbTitle.text fromBucket:[KSStates getBid]];
}

@end
