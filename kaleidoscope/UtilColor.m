//
//  UtilColor.m
//  comicReader
//
//  Created by Mike Chen on 4/8/13.
//

#import "UtilColor.h"

@implementation UtilColor

// http://stackoverflow.com/questions/3805177/how-to-convert-hex-rgb-color-codes-to-uicolor
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                                 withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)]
                       ];
    }
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (NSMutableAttributedString *)highlightString:(NSString *)needle
                                        InText:(NSString *)stack
                                     WithColor:(UIColor *)color
                            withHighlightColor:(UIColor *)hcolor
                                  withFontName:(NSString *)fontName
                                  withFontSize:(float)fontSize;
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:stack];
    [result addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, stack.length)];
    [result setAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]} range:NSMakeRange(0, stack.length)];

    [result addAttribute:NSForegroundColorAttributeName value:hcolor range:[stack rangeOfString:needle]];
    return result;
}
+ (NSMutableAttributedString *)highlightString:(NSString *)needle
                                        InText:(NSString *)stack
                                     WithColor:(UIColor *)color
                            withBackgroundColor:(UIColor *)bcolor
                                  withFontName:(NSString *)fontName
                                  withFontSize:(float)fontSize;
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:stack];
    [result addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, stack.length)];
    [result setAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]} range:NSMakeRange(0, stack.length)];

    [result addAttribute:NSBackgroundColorAttributeName value:bcolor range:[stack rangeOfString:needle]];
    return result;
}

// http://stackoverflow.com/questions/1266179/how-do-i-add-a-gradient-to-the-text-of-a-uilabel-but-not-the-background
+ (UIImage *)gradientImageWithSize:(CGSize)size {
    CGFloat width = size.width;         // max 1024 due to Core Graphics limitations
    CGFloat height = size.height;       // max 1024 due to Core Graphics limitations

    // create a new bitmap image context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));

    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();

    // push context to make it current (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);

    //draw gradient
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 1.0, 1.0, 1.0,  // Start color
        1.0, 1.0, 0.0, 1.0 }; // End color
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGPoint topCenter = CGPointMake(0, 0);
    CGPoint bottomCenter = CGPointMake(0, size.height);
    CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0);

    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);

    // pop context
    UIGraphicsPopContext();

    // get a UIImage from the image context
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();

    // clean up drawing environment
    UIGraphicsEndImageContext();

    return  gradientImage;
}

@end
