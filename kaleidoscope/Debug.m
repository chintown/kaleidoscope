//
//  KKDebug.m
//  comicReader
//
//  Created by Mike Chen on 4/12/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#import "Debug.h"

@implementation KKDebug

+ (void)logMethod {
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    // Example: 1   UIKit \
    // 0x00540c89 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1163
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];

    /*
     NSLog(@"Stack = %@", [array objectAtIndex:0]);
     NSLog(@"Framework = %@", [array objectAtIndex:1]);
     NSLog(@"Memory address = %@", [array objectAtIndex:2]);
     NSLog(@"Class caller = %@", [array objectAtIndex:3]);
     NSLog(@"Function caller = %@", [array objectAtIndex:4]);
     NSLog(@"Line caller = %@", [array objectAtIndex:5]);
     */
    de([NSString stringWithFormat:@">> %@ <<", [array objectAtIndex:4]]);
}

@end
