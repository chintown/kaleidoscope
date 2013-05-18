//
//  KSWebApiClient.h
//  kaleidoscope
//
//  Created by Mike Chen on 5/18/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSWebApiClient : NSObject

+ (void)getFlickr:(void (^)(NSMutableDictionary *result))callback
        withQuery:(NSString *)query;

@end
