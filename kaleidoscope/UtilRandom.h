//
//  KKUtilRandom.h
//  comicReader
//
//  Created by Mike Chen on 4/11/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUtilRandom : NSObject

+(BOOL) randomYesrNo;
+(int) randomIntWithin:(int)max; // return  1 ~ max randomly

@end
