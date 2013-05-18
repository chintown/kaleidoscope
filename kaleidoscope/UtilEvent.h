//
//  KKUtilEvent.h
//  comicReader
//
//  Created by Mike Chen on 4/27/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUtilEvent : NSObject

+ (void)executeBlock:(void (^)(void))callback afterSeconds:(CGFloat)secs;

@end
