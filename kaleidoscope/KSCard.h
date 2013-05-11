//
//  KSCard.h
//  kaleidoscope
//
//  Created by Mike Chen on 3/21/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCard : NSObject

@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *cMean;
@property (nonatomic, strong) NSString *eMean;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *forgot;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *hint;
@property (nonatomic, strong) NSString *thesaurus;
@property (nonatomic, strong) NSArray  *images;
@property (nonatomic, strong) NSString  *sentences;

@end
