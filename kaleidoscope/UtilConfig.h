//
//  UtilConfig.h
//  comicReader
//
//  Created by Mike Chen on 4/16/13.
//

#import <Foundation/Foundation.h>

@interface UtilConfig : NSObject

+ (id)getProjectPlistValueForKey:(NSString *)key;
+ (id)getProjectPlistStringForKey:(NSString *)key;
+ (id)getProjectPlistArrayforKey:(NSString *)key;
+ (id)getProjectPlistDictionaryForKey:(NSString *)key;

@end
