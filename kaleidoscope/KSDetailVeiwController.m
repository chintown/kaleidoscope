//
//  KSDetailVeiwController.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/22/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KSWebApiClient.h"
#import "KSCard.h"
#import "KSDetailVeiwController.h"

@interface KSDetailVeiwController ()

@end

@implementation KSDetailVeiwController

@synthesize uiMap;
@synthesize uiMeaning;
@synthesize uiDefinition;
@synthesize uiThesaurus;

# pragma mark - Setup

- (void)setupSelfStyle {
    [[self.view layer] setCornerRadius:30.0];
    [[self.view layer] setMasksToBounds:YES];

    [[self.uiMeaning layer] setCornerRadius:10.0];
    [[self.uiMeaning layer] setMasksToBounds:YES];

    [[self.uiDefinition layer] setCornerRadius:10.0];
    [[self.uiDefinition layer] setMasksToBounds:YES];

    [[self.uiTips layer] setCornerRadius:10.0];
    [[self.uiTips layer] setMasksToBounds:YES];

    [[self.uiExam layer] setCornerRadius:10.0];
    [[self.uiExam layer] setMasksToBounds:YES];

    [[self.uiThesaurus layer] setCornerRadius:10.0];
    [[self.uiThesaurus layer] setMasksToBounds:YES];
}
- (void)setupCardContent:(KSCard *)card {
    self.uiMeaning.text = card.cMean;
    self.uiTips.text = card.tip;
}
- (void)setupDefinitionByQuery:(NSString *)query {
    [KSWebApiClient getEnglishDefinition:^(NSString *html) {
        html = [NSString stringWithFormat:@"<html><head><style></style><body>%@</body></html>", html];
        [self.uiDefinition loadHTMLString:html baseURL:nil];
        [self.uiDefinition setBackgroundColor:[UIColor clearColor]];
    } withQuery:query];
}
- (void)setupExamByQuery:(NSString *)query {
    [KSWebApiClient getExam:^(NSString *text){
        self.uiExam.text = text;
    } withQuery:query];
}
- (void)setupThesaurusByQuery:(NSString *)query {
    [KSWebApiClient getThesaurus:^(NSString *html) {
        html = [NSString stringWithFormat:@"<html><head><style></style><body>%@</body></html>", html];
        [self.uiThesaurus loadHTMLString:html baseURL:nil];
        [self.uiThesaurus setBackgroundColor:[UIColor clearColor]];
    } withQuery:query];
}

# pragma mark - System Entry

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupSelfStyle];

    KSCard *card = [self.delegate getCard];
    de(card);
    [self setupCardContent:card];
    [self setupDefinitionByQuery:card.word];
    [self setupExamByQuery:card.word];
    [self setupThesaurusByQuery:card.word];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flipCard:(id)sender {
    [self.delegate cardbackDidFinish:self];
}
@end
