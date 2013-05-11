//
//  KSCardbackVeiwController.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/22/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KSCard.h"
#import "KSDetailVeiwController.h"

@interface KSDetailVeiwController ()

@end

@implementation KSDetailVeiwController

@synthesize uiMap;
@synthesize uiMeaning;
@synthesize uiDefinition;
@synthesize uiThesaurus;

- (void)setupSelfStyle {
    [[self.view layer] setCornerRadius:30.0];
    [[self.view layer] setMasksToBounds:YES];
}
- (void)setupCardContent:(KSCard *)card {
    self.uiMeaning.text = card.cMean;
}

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
    [self setupCardContent:[self.delegate getCard]];
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
