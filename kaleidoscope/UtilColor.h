//
//  UtilColor.h
//  comicReader
//
//  Created by Mike Chen on 4/8/13.
//

#import <Foundation/Foundation.h>

@interface UtilColor : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString; // convert hex color (#DADADA) to UIColor
+ (UIImage *)gradientImageWithSize:(CGSize)size;

@end
