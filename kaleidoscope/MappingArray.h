//
//  KKMappingArray.h
//  comicReader
//
//  Created by Mike Chen on 5/6/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#ifndef comicReader_KKMappingArray_h
#define comicReader_KKMappingArray_h

// http://forrst.com/posts/Array_mapping_in_Objective_C-UNN

@interface NSArray (Mapping)

- (NSArray *) mapWithBlock:(id (^)(NSUInteger idx, id obj))block;
//- (NSArray *) mapWithSelector:(SEL)selector;

@end

@implementation NSArray (Mapping)

- (NSArray *) mapWithBlock:(id (^)(NSUInteger idx, id obj))block
{
    NSUInteger count = [self count];

    NSMutableArray *newArr = [[NSMutableArray alloc] initWithCapacity:count];

    NSUInteger idx;
    for (idx = 0; idx < count; idx++) {
        id obj = [self objectAtIndex:idx];
        id newObj = block(idx, [obj copy]);

        [newArr insertObject:newObj atIndex:idx];
    }

    return newArr;
}
/*
- (NSArray *) mapWithSelector:(SEL)selector
{
    return [self mapWithBlock:^id(NSUInteger idx, id obj){
        if ([obj respondsToSelector:selector]) {
            return [obj performSelector:selector];
        } else {
            return obj;
        }
    }];
}
*/

@end

#endif
