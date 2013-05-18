//
//  KKUtilRandom.m
//  comicReader
//
//  Created by Mike Chen on 4/11/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#import "UtilRandom.h"

@implementation KKUtilRandom

+(BOOL) randomYesrNo {
    return (arc4random() % 2) == 0;
}

+(int) randomIntWithin:(int)max {
    return (arc4random() % max) + 1;
}

@end
