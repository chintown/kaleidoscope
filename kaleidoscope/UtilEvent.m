//
//  UtilEvent.m
//  comicReader
//
//  Created by Mike Chen on 4/27/13.
//

#import "UtilEvent.h"

@implementation UtilEvent

+ (void)executeBlock:(void (^)(void))callback afterSeconds:(CGFloat)secs {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_current_queue(), callback);
}

@end
