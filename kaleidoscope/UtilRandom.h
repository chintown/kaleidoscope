//
//  UtilRandom.h
//  comicReader
//
//  Created by Mike Chen on 4/11/13.
//

#import <Foundation/Foundation.h>

@interface UtilRandom : NSObject

+(BOOL) randomYesrNo;
+(int) randomIntWithin:(int)max; // return  1 ~ max randomly

@end
