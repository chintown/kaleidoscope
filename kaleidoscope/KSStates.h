//
//  KSStates.h
//  kaleidoscope
//
//  Created by Mike Chen on 3/20/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCard.h"

@interface KSStates : NSObject

+ (void) setHeadlineSource: (NSDictionary *) headlines;
+ (NSArray *) getHeadlineSource;
+ (NSDictionary *) getHeadlineSourceAtIndex: (int) idx;

+ (NSDictionary *) initBucketSourceWithSize: (int) size;
+ (NSDictionary *) getBucketSource;
+ (NSDictionary *) getBucketSourceAtIndex: (int) idx;
+ (void) setBucketSource: (NSDictionary *) buckets;
+ (void) setBucketSource: (NSDictionary *) bucket
                 atIndex: (int) idx;

+ (int) getBid;
+ (void) setBid: (int) bid;

+ (void) resetCardSource;
+ (NSDictionary *) initCardSource;
+ (NSDictionary *) getCardSource;
+ (KSCard *) getCardSourceAtIndex: (int) idx;
+ (BOOL) isExsitingCardSourceAtIndex: (int) idx;
+ (void) setCardsSource: (NSDictionary *) cards;
+ (void) setCardSource: (KSCard *) card
               atIndex: (int) idx;

+ (int) getCid;
+ (void) setCid: (int) cid;
+ (int) getCidAmongLastRefWithOffset: (int) offset;
+ (int) updateCidAmongLastRefWithOffset: (int) offset;

+ (BOOL) isLowBoundInBucket;
+ (BOOL) isUpBoundInBucket;

+ (int) getLastRootTab;
+ (void) setLastRootTab: (int) tab;
@end
