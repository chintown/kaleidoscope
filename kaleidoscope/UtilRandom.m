//
//  UtilRandom.m
//  comicReader
//
//  Created by Mike Chen on 4/11/13.
//

#import "UtilRandom.h"

@implementation UtilRandom

+(BOOL) randomYesrNo {
    return (arc4random() % 2) == 0;
}

+(int) randomIntWithin:(int)max {
    return (arc4random() % max) + 1;
}

@end
