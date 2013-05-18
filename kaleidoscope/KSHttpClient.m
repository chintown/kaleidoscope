//
//  KSHttpClient.m
//  kaleidoscope
//
//  Created by Mike Chen on 5/18/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "KSHttpClient.h"

@implementation KSHttpClient

static NSString * const rootWebApi = @"http://www.chintown.org:9000/";

+ (KSHttpClient *)sharedClient {
    static KSHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[KSHttpClient alloc] initWithBaseURL:[NSURL URLWithString:rootWebApi]];
    });

    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setParameterEncoding:AFJSONParameterEncoding];
    return self;
}

@end
