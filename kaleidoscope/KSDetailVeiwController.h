//
//  KSCardbackVeiwController.h
//  kaleidoscope
//
//  Created by Mike Chen on 3/22/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSDetailVeiwController; // FIXME dig into this....

@protocol KSCardbackDelegate
- (void)cardbackDidFinish:(KSDetailVeiwController *)controller;
- (KSCard *)getCard;
@end

@interface KSDetailVeiwController : UIViewController

@property (weak, nonatomic) id <KSCardbackDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *uiMap;
@property (weak, nonatomic) IBOutlet UITextView *uiMeaning;
@property (weak, nonatomic) IBOutlet UITextView *uiDefinition;
@property (weak, nonatomic) IBOutlet UITextView *uiThesaurus;

@property (weak, nonatomic) IBOutlet UIButton *btnFlip;
- (IBAction)flipCard:(id)sender;

@end
