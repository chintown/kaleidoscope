//
//  KKAssociativeReferences.h
//  comicReader
//
//  Created by Mike Chen on 4/18/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#ifndef comicReader_KKAssociativeReferences_h
#define comicReader_KKAssociativeReferences_h

@interface UIView (ObjectTagAdditions)
@property (nonatomic, retain) id objectTag;
@end

#import <objc/runtime.h>
static char const * const ObjectTagKey = "ObjectTag";

@implementation UIView (ObjectTagAdditions)
@dynamic objectTag;
- (id)objectTag {
    return objc_getAssociatedObject(self, ObjectTagKey);
}
- (void)setObjectTag:(id)objectTag {
    objc_setAssociatedObject(self, ObjectTagKey, objectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

#endif
