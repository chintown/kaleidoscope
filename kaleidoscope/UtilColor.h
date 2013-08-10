//
//  UtilColor.h
//  comicReader
//
//  Created by Mike Chen on 4/8/13.
//

#import <Foundation/Foundation.h>

@interface UtilColor : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString; // convert hex color (#DADADA) to UIColor
+ (NSMutableAttributedString *)highlightString:(NSString *)needle
                                        InText:(NSString *)stack
                                     WithColor:(UIColor *)color
                            withHighlightColor:(UIColor *)hcolor;
+ (NSMutableAttributedString *)highlightString:(NSString *)needle
                                        InText:(NSString *)stack
                                     WithColor:(UIColor *)color
                           withBackgroundColor:(UIColor *)bcolor;
+ (UIImage *)gradientImageWithSize:(CGSize)size;

@end
