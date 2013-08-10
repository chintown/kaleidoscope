//
//  KSCardProxy.h
//  kaleidoscope
//
//  Created by Mike Chen on 3/19/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@protocol KSCardProxyDelegate <NSObject>
@optional
- (void) proxyDidLoadHeadlineWithResult: (NSDictionary *) result;
- (void) proxyDidLoadBucketsWithResult: (NSDictionary *) result;
- (void) proxyDidLoadCardWithResult: (NSDictionary *) result;
- (void) proxyDidLoadFlickrWithResult: (NSDictionary *) result;
- (void) proxyDidLoadMapWithResult: (NSString *) result;
@end

@interface KSCardProxy : NSObject<NSURLConnectionDataDelegate>

# pragma mark Property
+ (void) delegate: (id<KSCardProxyDelegate>)delegatee ;

# pragma mark Task Util
+ (void) cleanConnection;
+ (void) setupConnectionByRequest: (NSMutableURLRequest *) request;
+ (void) endTask: (UIBackgroundTaskIdentifier) tid;

# pragma mark Flow Util
+ (NSMutableURLRequest *) getRequestByUriString: (NSString *) uri;
+ (void) issueRequest: (NSURLRequest *) request;

+ (NSString *) getGooglePronunciationPathByWord: (NSString *) word;
+ (NSString *) getGooglePronunciationUriByWord: (NSString *) word;
+ (AVPlayer *) setupPlayerWithUriString: (NSString *) uri;
+ (void) setupLayerWithPlayer:(AVPlayer *) player
                     withView: (UIView *) view;

# pragma mark BI
+ (void) queryFlickr:(NSString *)word;
+ (void) queryMap:(NSString *)word;
+ (void) queryHeadline;
+ (void) queryBuckets;
+ (void) queryCardOfBucketId: (int) bid OfCardIdx: (int) cid;
+ (void) upgradeCardWord: (NSString *)word
              fromBucket: (int) bid;
+ (void) downgradeCardWord: (NSString *)word
               fromBucket: (int) bid;
+ (void) playGooglePronunciationByWord: (NSString *) word withView:(UIView *) view;
@end
