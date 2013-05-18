//
//  KKUtilConfig.h
//  comicReader
//
//  Created by Mike Chen on 4/16/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUtilConfig : NSObject

+ (id)getProjectPlistValueForKey:(NSString *)key;
+ (id)getProjectPlistStringForKey:(NSString *)key;
+ (id)getProjectPlistArrayforKey:(NSString *)key;
+ (id)getProjectPlistDictionaryForKey:(NSString *)key;

@end
