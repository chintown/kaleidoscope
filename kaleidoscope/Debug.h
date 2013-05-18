//
//  Debug.h
//  comicReader
//
//  Created by Mike Chen on 4/12/13.
//

#import <Foundation/Foundation.h>

#define DEBUGGING NO
#define FORCE_REFRESH NO
#define IGNORE_LOGIN NO
#define RAVEN_ON_DUTY YES

// shorthands for NSLog
#define deErr(...) NSLog(@"[[[ERROR]]] %@", __VA_ARGS__)

#define de(...) NSLog(@"%@", [__VA_ARGS__ description])
#define deObj(...) NSLog(@"%@", __VA_ARGS__)
#define deInt(...) NSLog(@"%d", __VA_ARGS__)
#define deBool(...) NSLog(__VA_ARGS__ ? @"YES" : @"NO");
#define deFloat(...) NSLog(@"%f", __VA_ARGS__)
#define deSize(...) NSLog(@"%@", NSStringFromCGSize(__VA_ARGS__))
#define deRect(...) NSLog(@"%@", NSStringFromCGRect(__VA_ARGS__))
#define dePair(MSG, VAR) NSLog(@"%@ - %@", MSG, VAR)
#define deLog(FMT, ...) NSLog(FMT, ##__VA_ARGS__)

#define deOrientation(...) \
NSString *orient; \
switch(__VA_ARGS__) { \
    case UIInterfaceOrientationLandscapeRight: \
        orient = @"UIInterfaceOrientationLandscapeRight"; \
        break; \
    case UIInterfaceOrientationLandscapeLeft: \
        orient = @"UIInterfaceOrientationLandscapeLeft"; \
        break; \
    case UIInterfaceOrientationPortrait: \
        orient = @"UIInterfaceOrientationPortrait"; \
        break; \
    case UIInterfaceOrientationPortraitUpsideDown: \
        orient = @"UIInterfaceOrientationPortraitUpsideDown"; \
        break; \
    default: \
        orient = @"Invalid orientation"; \
} \
NSLog(@"orientation: %@", orient);

#define deFlow(...) //NSLog(@"%@", [__VA_ARGS__ description])
#define deLoginFlow(...) //NSLog(@"%@", [__VA_ARGS__ description])
#define deResize(...) //NSLog(@"%@", [__VA_ARGS__ description])
#define deHistory(MSG, VAR) //NSLog(@"%@ - %@", MSG, VAR)
#define deBookmark(MSG, VAR) //NSLog(@"%@ - %@", MSG, VAR)

@interface Debug : NSObject

+ (void)logMethod;

@end
