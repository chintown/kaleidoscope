//
//  CommonUtils.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/22/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+ (NSDictionary *) parseQueryToParams: (NSString *) query {
    // see rfc 1808
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray *paramPairs = [query componentsSeparatedByString:@"&"];
    for (NSString *paramPair in paramPairs) {
        NSArray *parts = [paramPair componentsSeparatedByString:@"="];
        if([parts count] < 2) {
            continue;
        }
        [params setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
    }
    return params;
}

@end
