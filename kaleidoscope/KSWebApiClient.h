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

@end
