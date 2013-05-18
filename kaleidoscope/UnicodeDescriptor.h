//
//  UnicodeDescriptor.h
//  comicReader
//
//  Created by Mike Chen on 4/30/13.
//

#ifndef comicReader_UnicodeDescriptor_h
#define comicReader_UnicodeDescriptor_h

// http://www.ptt.cc/bbs/MacDev/M.1321790683.A.059.html
@implementation NSArray(Unicode)
- (NSString*)description
{
    __block NSMutableString* desc = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [desc appendFormat:@"%@,\n",obj];
    }];
    [desc appendString:@")"];
    return desc;
}
@end

@implementation NSMutableArray(Unicode)
- (NSString*)description
{
    __block NSMutableString* desc = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [desc appendFormat:@"%@,\n",obj];
    }];
    [desc appendString:@")"];
    return desc;
}
@end

@implementation NSDictionary(Unicode)
- (NSString*)descriptionWithLocale:(id)locale
{
    __block NSMutableString* desc = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [desc appendFormat:@"%@ = %@,\n",key,obj];
    }];
    [desc appendString:@"}"];
    return desc;
}
@end

@implementation NSMutableDictionary(Unicode)
- (NSString*)descriptionWithLocale:(id)locale
{
    __block NSMutableString* desc = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [desc appendFormat:@"%@ = %@,\n",key,obj];
    }];
    [desc appendString:@"}"];
    return desc;
}
@end

#endif
