//
//  KSWebApiClient.h
//  kaleidoscope
//
//  Created by Mike Chen on 5/18/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSWebApiClient : NSObject

+ (void)getFlickr:(void (^)(NSMutableArray *result))callback
        withQuery:(NSString *)query;
+ (void)getWordMap:(void (^)(NSString *result))callback
         withQuery:(NSString *)query;
+ (void)getEnglishDefinition:(void (^)(NSString *result))callback
                   withQuery:(NSString *)query;
+ (void)getExam:(void (^)(NSString *result))callback
      withQuery:(NSString *)query;
+ (void)getThesaurus:(void (^)(NSString *result))callback
           withQuery:(NSString *)query;
+ (void)getHeadline:(void (^)(NSMutableArray *result))callback;


+ (void)getBucket:(void (^)(NSDictionary *result))callback;
+ (void)getCard:(void (^)(NSDictionary *result))callback OfBucketId:(int)bid OfCardIdx:(int)cid;
+ (void) jumpToCard:(int) cid
         fromBucket: (int) bid;
+ (void) upgradeCardWord: (NSString *)word
              fromBucket: (int) bid;
+ (void) downgradeCardWord: (NSString *)word
                fromBucket: (int) bid;
@end
