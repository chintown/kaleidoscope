//
//  KSStates.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/20/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "KSStates.h"
#import "KSCard.h"

// static vars
static NSUserDefaults *shared;
// keys for accessing data in NSUserDefaults
static NSString *kHeadlines = @"headlines"; // headline
static NSString *kBuckets = @"buckets"; // bucket data
static NSString *kBid = @"bid"; // bucket id
static NSString *kCid = @"cid"; // card idx
static NSString *kCards = @"cards"; // cards data

@implementation KSStates

+ (void) initialize {
    NSLog(@"[initialize @ KSStates] (should be once)");
    shared = [NSUserDefaults standardUserDefaults];
}

+ (void) setHeadlineSource: (NSArray *) headlines {
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject: headlines];
    [shared setObject: (NSObject *) encoded
               forKey: kHeadlines];
    [shared synchronize];
}
+ (NSArray *) getHeadlineSource {
    NSData *encoded = [shared objectForKey:kHeadlines];
    NSArray *headlines = [NSKeyedUnarchiver unarchiveObjectWithData: encoded];

    if (headlines == nil) {
        headlines = [[NSMutableArray alloc] init];
    }
    return headlines;
}
+ (NSDictionary *) getHeadlineSourceAtIndex: (int) idx {
    return [[self getHeadlineSource] objectAtIndex: idx];
}

+ (NSDictionary *) initBucketSourceWithSize:(int)size {
    NSDictionary *buckets = [[NSMutableDictionary alloc] initWithCapacity: size];
    for (int i=0; i<size; i++) {
        NSString *key = [NSString stringWithFormat: @"%d", i];
        NSMutableDictionary *bucket = [[NSMutableDictionary alloc] init];
        [buckets setValue:bucket forKey:key];
    }
    return buckets;
}
+ (NSDictionary *) getBucketSource {
    NSData *encoded = [shared objectForKey:kBuckets];
    NSDictionary *buckets = [NSKeyedUnarchiver unarchiveObjectWithData: encoded];

    if (buckets == nil) {
        buckets = [KSStates initBucketSourceWithSize: 5];
    }
    return buckets;
}
+ (NSDictionary *) getBucketSourceAtIndex: (int) idx {
    NSString *key = [NSString stringWithFormat:@"%d", idx];
    return [[self getBucketSource] valueForKey:key];
}
+ (void) setBucketSource: (NSDictionary *) buckets {
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject: buckets];
    [shared setObject: (NSObject *) encoded
               forKey: kBuckets];
    [shared synchronize];
}
+ (void) setBucketSource: (NSDictionary *) bucket
                 atIndex: (int) idx {
    NSDictionary *buckets = [KSStates getBucketSource];

    NSString *key = [NSString stringWithFormat:@"%d", idx];
    [buckets setValue:bucket forKey:key];

    [KSStates setBucketSource:buckets];
}

+ (int) getBid {
    return [shared integerForKey: kBid];
}
+ (void) setBid: (int) bid {
    [shared setInteger: bid forKey: kBid];
    [shared synchronize];
}

+ (void) resetCardSource {
    [shared setObject: (NSObject *) nil
               forKey: kCards];
    [shared synchronize];
}
+ (NSDictionary *) initCardSource {
    NSDictionary *cards = [[NSMutableDictionary alloc] init];
    return cards;
}
+ (NSDictionary *) getCardSource {
    NSData *encoded = [shared objectForKey:kCards];
    NSDictionary *cards = [NSKeyedUnarchiver unarchiveObjectWithData: encoded];

    if (cards == nil) {
        cards = [KSStates initCardSource];
    }
    return cards;
}
+ (KSCard *) getCardSourceAtIndex: (int) idx {
    NSString *key = [NSString stringWithFormat:@"%d", idx];
    return [[self getCardSource] valueForKey:key];
}
+ (BOOL) isExsitingCardSourceAtIndex: (int) idx {
    NSString *key = [NSString stringWithFormat:@"%d", idx];
    return ([[self getCardSource] valueForKey:key] != nil);
}
+ (void) setCardsSource: (NSDictionary *) cards {
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject: cards];
    [shared setObject: (NSObject *) encoded
               forKey: kCards];
    [shared synchronize];
}
+ (void) setCardSource: (KSCard *) card
               atIndex: (int) idx {
    NSDictionary *cards = [KSStates getCardSource];

    NSString *key = [NSString stringWithFormat:@"%d", idx];
    [cards setValue:card forKey:key];

    [KSStates setCardsSource:cards];
}

+ (int) getCid {
    return [shared integerForKey: kCid];
}
+ (void) setCid: (int) cid {
    [shared setInteger: cid forKey: kCid];
    [shared synchronize];
}
+ (int) getCidAmongLastRefWithOffset: (int) offset {
    int bid = [KSStates getBid];
    NSDictionary *bucket = [KSStates getBucketSourceAtIndex:bid - 1]; // id is idx + 1
    int refCid = [[bucket valueForKey:@"lastCid"] intValue];
    return refCid + offset;
}
+ (int) updateCidAmongLastRefWithOffset: (int) offset {
    int resultCid = [KSStates getCidAmongLastRefWithOffset:offset];
    [KSStates setCid: resultCid];
    return resultCid;
}

+ (BOOL) isLowBoundInBucket {
    BOOL isLow = (0 == [KSStates getCid]);
    return isLow;
}
+ (BOOL) isUpBoundInBucket {
    int bid = [KSStates getBid];
    NSDictionary *bucket = [KSStates getBucketSourceAtIndex:bid - 1]; // id is idx + 1
    int num = [[bucket valueForKey:@"num"] intValue];
    int maxIdx = num - 1;
    BOOL isUp = ([KSStates getCid] == maxIdx);
    return isUp;
}

@end
