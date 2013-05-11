//
//  KSCard.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/21/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "KSCard.h"

@implementation KSCard

@synthesize word;
@synthesize cMean;
@synthesize eMean;
@synthesize level;
@synthesize forgot;
@synthesize tip;
@synthesize hint;
@synthesize thesaurus;
@synthesize images;
@synthesize sentences;

- (void)encodeWithCoder:(NSCoder *)coder; {
    [coder encodeObject:self.word forKey:@"word"];
    [coder encodeObject:self.cMean forKey:@"cMean"];
    [coder encodeObject:self.eMean forKey:@"eMean"];
    [coder encodeObject:self.level forKey:@"level"];
    [coder encodeObject:self.forgot forKey:@"forgot"];
    [coder encodeObject:self.tip forKey:@"tip"];
    [coder encodeObject:self.hint forKey:@"hint"];
    [coder encodeObject:self.thesaurus forKey:@"thesaurus"];
    [coder encodeObject:self.images forKey:@"images"];
    [coder encodeObject:self.sentences forKey:@"sentences"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[KSCard alloc] init];
    if (self != nil)
    {
        self.word = (NSString *)[coder decodeObjectForKey:@"word"];
        self.cMean = (NSString *)[coder decodeObjectForKey:@"cMean"];
        self.eMean = (NSString *)[coder decodeObjectForKey:@"eMean"];
        self.level = (NSNumber *)[coder decodeObjectForKey:@"level"];
        self.forgot = (NSNumber *)[coder decodeObjectForKey:@"forgot"];
        self.tip = (NSString *)[coder decodeObjectForKey:@"tip"];
        self.hint = (NSString *)[coder decodeObjectForKey:@"hint"];
        self.thesaurus = (NSString *)[coder decodeObjectForKey:@"thesaurus"];
        self.images = (NSArray *)[coder decodeObjectForKey:@"images"];
        self.sentences = (NSString *)[coder decodeObjectForKey:@"sentences"];
    }
    return self;
}

@end
