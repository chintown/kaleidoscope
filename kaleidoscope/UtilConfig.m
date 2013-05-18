//
//  UtilConfig.m
//  comicReader
//
//  Created by Mike Chen on 4/16/13.
//

#import "UtilConfig.h"

@implementation UtilConfig

+ (id)getProjectPlistValueForKey:(NSString *)key {
    NSDictionary *ipl = [[NSBundle mainBundle] infoDictionary];
    //de(ipl); check it, it's not as you expect.
    return [ipl valueForKey:key];
}
+ (NSString *)getProjectPlistStringForKey:(NSString *)key {
    return (NSString *)[UtilConfig getProjectPlistValueForKey:key];
}
+ (NSArray *)getProjectPlistArrayforKey:(NSString *)key {
    return (NSArray *)[UtilConfig getProjectPlistValueForKey:key];
}
+ (NSDictionary *)getProjectPlistDictionaryForKey:(NSString *)key {
    return (NSDictionary *)[UtilConfig getProjectPlistValueForKey:key];
}
@end
