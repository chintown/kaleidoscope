//
//  KSWebApiClient.m
//  kaleidoscope
//
//  Created by Mike Chen on 5/18/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "KSHttpClient.h"
#import "KSWebApiClient.h"

@implementation KSWebApiClient

+ (void)getDictionaryFromUri:(NSString *)uri
                  withParams:(NSDictionary *)params
                withCallback:(void (^)(NSMutableDictionary *result))callback {
    [XHttpClient getPath:uri
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id JSON) // raw result
     {
         if (callback) {
             callback(JSON);
         }
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         de(error);
         callback(nil);
     }
     ];
}


# pragma mark - Publics

+ (void)getFlickr:(void (^)(NSMutableDictionary *result))callback
        withQuery:(NSString *)query{
    NSString *uri = [NSString stringWithFormat:@"flicker/?query=%@", query];
    NSDictionary *params = nil;
    [KSWebApiClient getDictionaryFromUri:uri withParams:params withCallback:callback];
}

@end
