//
//  UIStyle.h
//  comicReader
//
//  Created by Mike Chen on 4/14/13.
//

#import <Foundation/Foundation.h>

@interface UtilUI : NSObject

+ (void)addBorderOnView:(UIView *)view withColor:(UIColor *)color;
+ (void)addBorderOnView:(UIView *)view withColor:(UIColor *)color withWidth:(CGFloat)width;

+ (void)inspectFrameOfViews:(NSArray *)views;
+ (void)inspectFrameOfView:(UIView *)view;

+ (BOOL)isScreenPortrait;

+ (void)updateView:(UIView *)view onWidth:(CGFloat)width;
+ (void)updateView:(UIView *)view onHeight:(CGFloat)height;

+ (void)updateView:(UIView *)view onPositionX:(CGFloat)x;
+ (void)updateView:(UIView *)view onPositionY:(CGFloat)y;

+ (void)updateOrientationDependentView:(UIView *)view onWidth:(CGFloat)width;
+ (void)updateOrientationDependentView:(UIView *)view onHeight:(CGFloat)height;

+ (void)centerViewHorizontallyToParent:(UIView *)subView;
+ (void)centerViewVerticallyToParent:(UIView *)subView;
+ (void)centerViewHorizontally:(UIView *)subject toView:(UIView *)target;
+ (void)centerViewVertically:(UIView *)subject toView:(UIView *)target;

+ (void)placeView:(UIView *)subject atBottomOfView:(UIView *)target withPadding:(CGRect)paddings;

+ (CGFloat)getMaxBottomBoundFromSubviewsOf:(UIView *)view;
+ (CGFloat)getMaxBottomBoundFromSubviewsOf:(UIView *)view withoutClass:(Class)filterClass;

+ (void)reflowSubviewVeritcally:(UIView *)view;

+ (void)reflowViewsVeritcally:(NSArray *)views;
+ (void)reflowViewsVeritcally:(NSArray *)views withMargin:(CGRect)margin;
+ (void)reflowSiblingViewsVeritcally:(NSArray *)views;

+ (void)drawAsistantGridOn:(UIView *)view
              withGridSize:(CGFloat)sizeGrid
                    inArea:(CGSize)size;
@end
