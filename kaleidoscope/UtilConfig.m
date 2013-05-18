//
//  KKUtilConfig.m
//  comicReader
//
//  Created by Mike Chen on 4/16/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#import "KKUtilConfig.h"

@implementation KKUtilConfig

+ (id)getProjectPlistValueForKey:(NSString *)key {
    NSDictionary *ipl = [[NSBundle mainBundle] infoDictionary];
    //de(ipl); check it, it's not as you expect.
    return [ipl valueForKey:key];
}
+ (NSString *)getProjectPlistStringForKey:(NSString *)key {
    return (NSString *)[KKUtilConfig getProjectPlistValueForKey:key];
}
+ (NSArray *)getProjectPlistArrayforKey:(NSString *)key {
    return (NSArray *)[KKUtilConfig getProjectPlistValueForKey:key];
}
+ (NSDictionary *)getProjectPlistDictionaryForKey:(NSString *)key {
    return (NSDictionary *)[KKUtilConfig getProjectPlistValueForKey:key];
}
@end
