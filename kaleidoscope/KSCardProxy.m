//
//  KSCardProxy.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/19/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "KSCardProxy.h"

static id<KSCardProxyDelegate> delegate;

static NSString *qHeadline = @"http://www.chintown.org:9000/headline/";
static NSString *qBucketFmt = @"http://www.chintown.org/lookup/api.php?target=buckets";
static NSString *qCardFmt = @"http://www.chintown.org/lookup/api.php?target=card&level=%d&sidx=%d";
static NSString *qUpgradeFmt = @"http://www.chintown.org/lookup/api.php?target=_move&level=%d&word=%@";
static NSString *qDowngradeFmt = @"http://www.chintown.org/lookup/api.php?target=_reset&level=%d&word=%@";
static NSString *gPronunciationFmt = @"http://www.gstatic.com/dictionary/static/sounds/lf/0/%@/%@#_us_1.mp3";
static NSString *qFlickrFmt = @"http://www.chintown.org:9000/flickr/?query=%@";
static NSString *qMapFmt = @"http://www.chintown.org:9000/map/?query=%@";

static NSURLConnection *connection;
static UIBackgroundTaskIdentifier backgroundTaskId;
static NSMutableData *resultData;

@implementation KSCardProxy 

# pragma mark Property
+ (void) delegate: (id<KSCardProxyDelegate>)delegatee {
    delegate = delegatee;
}

# pragma mark Task Util
+ (void) cleanConnection {
    connection = nil;
    resultData = nil;
    
}
+ (void) setupConnectionByRequest: (NSMutableURLRequest *) request {
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:[KSCardProxy class]
                  ];
    resultData = [NSMutableData alloc];
}
+ (void) endTask: (UIBackgroundTaskIdentifier) tid {
    UIApplication *app = [UIApplication sharedApplication];
    [app endBackgroundTask: tid];
}

# pragma mark Flow Util
+ (NSMutableURLRequest *) getRequestByUriString: (NSString *) uri {
    NSString *uriEncoded = [uri stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:uriEncoded];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Mobile Safari 1.1.3 (iPhone; U; CPU like Mac OS X; en)"
   forHTTPHeaderField:@"User-Agent"];
    [request setTimeoutInterval:20];
    return request;
}
+ (void) issueRequest: (NSMutableURLRequest *) request {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [KSCardProxy cleanConnection];
    [KSCardProxy setupConnectionByRequest: request];

    /*UIApplication *app = [UIApplication sharedApplication];
    backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:
                            ^ {
                                NSLog(@"connection canceled");
                                [connection cancel];
                            }
                        ];*/
}

+ (NSString *) getGooglePronunciationPathByWord: (NSString *) word {
    return [NSString stringWithFormat:@"%@/%@/%@",
            [word substringWithRange: NSMakeRange(0, 1)],
            [word substringWithRange: NSMakeRange(0, 2)],
            [word substringWithRange: NSMakeRange(0, 3)]
            ];
}
+ (NSString *) getGooglePronunciationUriByWord: (NSString *) word {
    NSString *path = [KSCardProxy getGooglePronunciationPathByWord: word];
    NSString *uri = [NSString stringWithFormat: gPronunciationFmt,
                                                path, word];
    return uri;
}
+ (AVPlayer *) setupPlayerWithUriString: (NSString *) uri {
    NSString *uriEncoded = [uri stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString: uriEncoded];
    NSLog(@"play mp3 from %@ ...", url);
    
    /** //not work for streaming
    NSError * error = nil;
    AVAudioPlayer *player =
    [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                           error: &error];
    //*/
    
    /**/
    AVPlayer *player = [AVPlayer playerWithURL: url];
    //*/
    return player;
}
+ (void) setupLayerWithPlayer:(AVPlayer *) player
                     withView: (UIView *) view {
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer: player];
    [layer setFrame: view.frame];
    [view.layer addSublayer:layer];
}

# pragma mark BI
+ (void) queryFlickr:(NSString *)word {
    NSString *uri = [NSString stringWithFormat: qFlickrFmt, word];
    NSMutableURLRequest *request = [KSCardProxy getRequestByUriString: uri];
    [KSCardProxy issueRequest: request];
    NSLog(@"flickr %@", uri);
}
+ (void) queryMap:(NSString *)word {
    NSString *uri = [NSString stringWithFormat: qMapFmt, word];
    NSMutableURLRequest *request = [KSCardProxy getRequestByUriString: uri];
    [KSCardProxy issueRequest: request];
    NSLog(@" word map %@", uri);
}

+ (void) queryHeadline {
    NSString *uri = qHeadline;
    NSMutableURLRequest *request = [KSCardProxy getRequestByUriString: uri];
    [KSCardProxy issueRequest: request];
    NSLog(@"headline %@", uri);
}
+ (void) queryBuckets {
    NSString *uri = qBucketFmt;
    NSMutableURLRequest *request = [KSCardProxy getRequestByUriString: uri];
    [KSCardProxy issueRequest: request];
    NSLog(@"buckets %@", uri);
}
+ (void) queryCardOfBucketId:(int)bid OfCardIdx:(int)cid {
    NSString *uri = [NSString stringWithFormat: qCardFmt, bid, cid];
    NSMutableURLRequest *request = [KSCardProxy getRequestByUriString: uri];
    [KSCardProxy issueRequest: request];
    NSLog(@"card %@", uri);
}
+ (void) upgradeCardWord: (NSString *)word
              fromBucket: (int) bid {
    NSString *uri = [NSString stringWithFormat: qUpgradeFmt, bid, word];
    NSMutableURLRequest *request = [KSCardProxy getRequestByUriString: uri];
    [KSCardProxy issueRequest: request];
    NSLog(@"upgrade %@", uri);
}
+ (void) downgradeCardWord: (NSString *)word
              fromBucket: (int) bid {
    NSString *uri = [NSString stringWithFormat: qDowngradeFmt, bid, word];
    NSMutableURLRequest *request = [KSCardProxy getRequestByUriString: uri];
    [KSCardProxy issueRequest: request];
    NSLog(@"downgrade %@", uri);
}
+ (void) playGooglePronunciationByWord: (NSString *) word
                              withView:(UIView *) view {
    NSString *uri = [KSCardProxy getGooglePronunciationUriByWord: word];
    AVPlayer *player = [KSCardProxy setupPlayerWithUriString: uri];
    [KSCardProxy setupLayerWithPlayer: player withView: view];
    
    [player play];
    //NSLog(@"error: %@", player.error);
}

# pragma mark NSURLConnection > Self
+ (void) connection: (NSURLConnection *) connection
  didFailWithError: (NSError *) error{
    [KSCardProxy endTask: backgroundTaskId];
    NSLog(@"connection failed -> end task %d", backgroundTaskId);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

+ (void) connection: (NSURLConnection *) connection
didReceiveResponse: (NSHTTPURLResponse *) response {
    NSInteger statusCode = (NSInteger) [response statusCode];
    NSLog(@"status code: %d", statusCode);
}

+ (void) connection: (NSURLConnection *) connection
     didReceiveData: (NSData *) data {
    [resultData appendData: data];
    //NSLog(@"receiving data...");
}

+ (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"\\\\========== receive done");
    //[KSCardProxy endTask: backgroundTaskId];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:resultData
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
    if (json == nil) {
        NSLog(@"nil json result");
        return;
    }
    NSString *target = [json valueForKey: @"target"];
    NSDictionary *result = [json valueForKey: @"result"];
    //NSAssert([result count] != 0, @"card index out of BOUND");
    // NSLog(@"%@", json);
    if ([target isEqual: @"buckets"]) {
        [delegate proxyDidLoadBucketsWithResult: result];
    } else if ([target isEqual: @"card"]) {
        [delegate proxyDidLoadCardWithResult: result];
    } else if ([target isEqual: @"flickr"]) {
        [delegate proxyDidLoadFlickrWithResult: result];
    } else if ([target isEqual: @"sakunkoo"]) {
        [delegate proxyDidLoadMapWithResult: (NSString *)result];
    } else if ([target isEqual: @"liveabc"]) {
        [delegate proxyDidLoadHeadlineWithResult: result];
    } else {
        NSLog(@"unknow targer: %@", target);
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
