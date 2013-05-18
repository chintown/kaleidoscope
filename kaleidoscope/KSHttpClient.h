//
//  KSHttpClient.h
//  kaleidoscope
//
//  Created by Mike Chen on 5/18/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

/*
 this Singleton gives the ability to access API uri under a given url path
 and play with the response in JSON
 */

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

#define XHttpClient [KSHttpClient sharedClient]

@interface KSHttpClient : AFHTTPClient

+ (KSHttpClient *)sharedClient;

@end