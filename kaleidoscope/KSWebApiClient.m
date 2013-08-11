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
+ (void)phpDictionaryFromUri:(NSString *)uri
                  withParams:(NSDictionary *)params
                withCallback:(void (^)(NSMutableDictionary *result))callback {
    [XHttpClient2 getPath:uri
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

+ (void)getFlickr:(void (^)(NSMutableArray *result))callback
        withQuery:(NSString *)query{
    NSString *uri = [NSString stringWithFormat:@"flickr/?query=%@", query];
    NSDictionary *params = nil;
    [KSWebApiClient getDictionaryFromUri:uri withParams:params withCallback:^(NSMutableDictionary *result) {
        callback([result valueForKey:@"result"]);
    }];
}

+ (void)getWordMap:(void (^)(NSString *result))callback
         withQuery:(NSString *)query {
    NSString *uri = [NSString stringWithFormat:@"map/?query=%@", query];
    NSDictionary *params = nil;
    [KSWebApiClient getDictionaryFromUri:uri withParams:params withCallback:^(NSMutableDictionary *result) {
        callback([result valueForKey:@"result"]);
    }];
}

+ (void)getEnglishDefinition:(void (^)(NSString *result))callback
                   withQuery:(NSString *)query {
    NSString *uri = [NSString stringWithFormat:@"definition/?query=%@", query];
    NSDictionary *params = nil;
    [KSWebApiClient getDictionaryFromUri:uri withParams:params withCallback:^(NSMutableDictionary *result) {
        callback([result valueForKey:@"result"]);
    }];
}

+ (void)getExam:(void (^)(NSString *result))callback
      withQuery:(NSString *)query {
    NSString *uri = [NSString stringWithFormat:@"exam/?query=%@", query];
    NSDictionary *params = nil;
    [KSWebApiClient getDictionaryFromUri:uri withParams:params withCallback:^(NSMutableDictionary *result) {
        NSString *html = [result valueForKey:@"result"];
        html = [html stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        callback(html);
    }];
}

+ (void)getThesaurus:(void (^)(NSString *result))callback
           withQuery:(NSString *)query {
    NSString *uri = [NSString stringWithFormat:@"thesaurus/?query=%@", query];
    NSDictionary *params = nil;
    [KSWebApiClient getDictionaryFromUri:uri withParams:params withCallback:^(NSMutableDictionary *result) {
        callback([result valueForKey:@"result"]);
    }];
}

+ (void)getHeadline:(void (^)(NSMutableArray *))callback {
    NSString *uri = [NSString stringWithFormat:@"headline/"];
    NSDictionary *params = nil;
    [KSWebApiClient getDictionaryFromUri:uri withParams:params withCallback:^(NSMutableDictionary *result) {
        callback([result valueForKey:@"result"]);
    }];
}


+ (void)getBucket:(void (^)(NSDictionary *result))callback {
    NSString *uri = [NSString stringWithFormat:@"?target=buckets"];
    NSDictionary *params = nil;
    [KSWebApiClient phpDictionaryFromUri:uri withParams:params withCallback:^(NSMutableDictionary *result) {
        callback([result valueForKey:@"result"]);
    }];
}

@end
