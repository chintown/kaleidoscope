//
//  KKUtilColor.h
//  comicReader
//
//  Created by Mike Chen on 4/8/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUtilColor : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString; // convert hex color (#DADADA) to UIColor
+ (UIImage *)gradientImageWithSize:(CGSize)size;

@end
