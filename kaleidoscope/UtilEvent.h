//
//  UtilEvent.h
//  comicReader
//
//  Created by Mike Chen on 4/27/13.
//

#import <Foundation/Foundation.h>

@interface UtilEvent : NSObject

+ (void)executeBlock:(void (^)(void))callback afterSeconds:(CGFloat)secs;

@end
