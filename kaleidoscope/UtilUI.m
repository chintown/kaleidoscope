//
//  KKUIStyle.m
//  comicReader
//
//  Created by Mike Chen on 4/14/13.
//  Copyright (c) 2013 kkBox. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KKUtilUI.h"

@implementation KKUtilUI

+ (void)addBorderOnView:(UIView *)view withColor:(UIColor *)color {
    [KKUtilUI addBorderOnView:view withColor:color withWidth:1.];
}
+ (void)addBorderOnView:(UIView *)view withColor:(UIColor *)color withWidth:(CGFloat)width {
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = width;
}

+ (void)inspectFrameOfViews:(NSArray *)views {
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *STOP) {
        [KKUtilUI inspectFrameOfView:view];
    }];
}
+ (void)inspectFrameOfView:(UIView *)view {
    NSString *head = [NSString stringWithFormat:@"%@", [view class]];
    de(@" ");
    de(head);
    deRect(view.frame);
    de(@"--------------------------------------------------------------------");
}

// http://jeffreysambells.com/2011/09/22/how-to-determine-ios-device-orientation-when-your-app-starts-up
+ (BOOL)isScreenPortrait {
    UIInterfaceOrientation iOrientation = [UIApplication sharedApplication].statusBarOrientation;
	UIDeviceOrientation dOrientation = [UIDevice currentDevice].orientation;

	bool landscape;

    /*if (TARGET_IPHONE_SIMULATOR) {
        NSString *initOrientation = [KKUtilConfig getProjectPlistStringForKey:@"UIInterfaceOrientation"];
        // e.g. UIInterfaceOrientationLandscapeRight
        landscape = ([[initOrientation lowercaseString] rangeOfString:@"landscape"].location != NSNotFound);
    } else*/
    if (dOrientation == UIDeviceOrientationUnknown || dOrientation == UIDeviceOrientationFaceUp || dOrientation == UIDeviceOrientationFaceDown) {
		// If the device is laying down, use the UIInterfaceOrientation based on the status bar.
		landscape = UIInterfaceOrientationIsLandscape(iOrientation);
	} else {
		// If the device is not laying down, use UIDeviceOrientation.
		landscape = UIDeviceOrientationIsLandscape(dOrientation);

		// There's a bug in iOS!!!! http://openradar.appspot.com/7216046
		// So values needs to be reversed for landscape!
		if (dOrientation == UIDeviceOrientationLandscapeLeft) {
            iOrientation = UIInterfaceOrientationLandscapeRight;
        } else if (dOrientation == UIDeviceOrientationLandscapeRight) {
            iOrientation = UIInterfaceOrientationLandscapeLeft;
        } else if (dOrientation == UIDeviceOrientationPortrait) {
            iOrientation = UIInterfaceOrientationPortrait;
        } else if (dOrientation == UIDeviceOrientationPortraitUpsideDown) {
            iOrientation = UIInterfaceOrientationPortraitUpsideDown;
        }
	}
    //NSLog(@"                        isPortrait:%@", (!landscape) ? @"Y" : @"N");
    return !landscape;
}

+ (void)DEPRECATED_updateOrientationDependentView:(UIView *)view onWidth:(CGFloat)width {
    if ([KKUtilUI isScreenPortrait]) {
        [KKUtilUI updateView:view onWidth:width];
    } else {
        [KKUtilUI updateView:view onHeight:width];
    }
}
+ (void)DEPRECATED_updateOrientationDependentView:(UIView *)view onHeight:(CGFloat)height {
    if ([KKUtilUI isScreenPortrait]) {
        [KKUtilUI updateView:view onHeight:height];
    } else {
        [KKUtilUI updateView:view onWidth:height];
    }
}

+ (void)updateOrientationDependentView:(UIView *)view onWidth:(CGFloat)width {
    CGRect bounds = view.bounds;
    bounds.size.width = width;
    view.bounds = bounds;

}
+ (void)updateOrientationDependentView:(UIView *)view onHeight:(CGFloat)height {
    CGRect bounds = view.bounds;
    bounds.size.height = height;
    view.bounds = bounds;
}

+ (void)updateView:(UIView *)view onWidth:(CGFloat)width {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}
+ (void)updateView:(UIView *)view onHeight:(CGFloat)height {
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

+ (void)updateView:(UIView *)view onPositionX:(CGFloat)x {
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}
+ (void)updateView:(UIView *)view onPositionY:(CGFloat)y {
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

+ (void)centerViewHorizontallyToParent:(UIView *)view {
    [KKUtilUI centerViewHorizontally:view toView:view.superview];
}
+ (void)centerViewVerticallyToParent:(UIView *)view {
    [KKUtilUI centerViewVertically:view toView:view.superview];    
}
+ (void)centerViewHorizontally:(UIView *)subject toView:(UIView *)target {
    CGSize size = target.frame.size;
    CGPoint center = subject.center;
    CGPoint newCenter;
    newCenter = CGPointMake(size.width/2,
                            center.y);
    //if ([KKUtilUI isScreenPortrait])
    [subject setCenter:newCenter];
}
+ (void)centerViewVertically:(UIView *)subject toView:(UIView *)target {
    CGSize size = target.frame.size;
    CGPoint center = subject.center;
    CGPoint newCenter;
    newCenter = CGPointMake(center.x,
                            size.height/2);
    //if ([KKUtilUI isScreenPortrait]) {
    [subject setCenter:newCenter];
}

+ (void)placeView:(UIView *)subject atBottomOfView:(UIView *)target withPadding:(CGRect)padding {
    if (target == nil) {
        return;
    }
    //NSAssert(target != nil, @"can not place view with NIL referece! (KKUtilUI)");
    CGPoint siblingPos = target.frame.origin;
    CGSize siblingSize = target.frame.size;

    // trick: use CGRect to store four paddings
    CGFloat paddingTop;
    CGFloat paddingLeft;
    CGFloat paddingBot;
    CGFloat paddingRight;
    if (CGRectIsNull(padding)) {
        paddingTop = paddingLeft = paddingBot = paddingRight = 0.0;
    } else {
        paddingTop   = padding.origin.x;
        paddingLeft  = padding.origin.y;
        paddingBot   = padding.size.width;
        paddingRight = padding.size.height;
    }

    CGRect frame = CGRectMake(siblingPos.x + paddingLeft,
                              siblingPos.y + siblingSize.height + paddingTop,
                              subject.frame.size.width - paddingLeft - paddingRight,
                              subject.frame.size.height - paddingBot);
//    de(@"sibling:");de(target);
//    de(@"move to bottom:");deRect(frame);
    subject.frame = frame;
}

+ (CGFloat)getMaxBottomBoundFromSubviewsOf:(UIView *)view {
    return [KKUtilUI getMaxBottomBoundFromSubviewsOf:view withoutClass:nil];
}
+ (CGFloat)getMaxBottomBoundFromSubviewsOf:(UIView *)view withoutClass:(Class)filterClass {
    __block NSMutableArray *subviewBottomBounds = [[NSMutableArray alloc] init];
    [view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *STOP) {
        if (filterClass == nil || [view class] != filterClass) {
            int buttomBound = view.frame.origin.y + view.frame.size.height;
            NSNumber* bound = [NSNumber numberWithInt:buttomBound];
            [subviewBottomBounds addObject:bound];
            //NSLog(@"view %@ bound %d", view, buttomBound);
        }
    }];
    CGFloat maxBottomBound = [[subviewBottomBounds valueForKeyPath:@"@max.floatValue"] intValue];
    //NSLog(@"max buttom %f", maxBottomBound);
    return maxBottomBound;
}

+ (void)reflowSubviewVeritcally:(UIView *)view {
    __block int lastBottomBounds = 0;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *STOP) {
        [KKUtilUI updateView:subview onPositionY:lastBottomBounds];

        lastBottomBounds = lastBottomBounds + subview.frame.size.height;
        //NSLog(@"bound %d. view %@", lastBottomBounds, subview);
    }];
}

+ (void)reflowViewsVeritcally:(NSArray *)views {
    [KKUtilUI reflowViewsVeritcally:views withMargin:CGRectMake(0,0,0,0)];
}
+ (void)reflowViewsVeritcally:(NSArray *)views withMargin:(CGRect)margin {
    __block UIView *lastSibling;
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *STOP) {
        [KKUtilUI placeView:view atBottomOfView:lastSibling withPadding:(CGRect)margin];
        lastSibling = view;
    }];
}
+ (void)reflowSiblingViewsVeritcally:(NSArray *)views {
    __block NSMutableArray *siblingYPositions = [[NSMutableArray alloc] init];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *STOP) {
        NSNumber *yPosition = [NSNumber numberWithFloat:view.frame.origin.y];
        [siblingYPositions addObject:yPosition];
    }];
    float minYPosition = [[siblingYPositions valueForKeyPath:@"@min.self"] floatValue];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *STOP) {
        [KKUtilUI updateView:view onPositionY:minYPosition];
    }];
}

+ (void)drawAsistantGridOn:(UIView *)view
              withGridSize:(CGFloat)sizeGrid
                    inArea:(CGSize)size {
    CGFloat sizeDot = 5;
    int numH = floor(size.width / sizeGrid);
    int numV = floor(size.height / sizeGrid);
    for (int x = 0; x < numH; x++) {
        for (int y = 0; y < numV; y++) {
            CGRect frame = CGRectMake(x*sizeGrid, y*sizeGrid, sizeDot, sizeDot);
            UIView *dot = [[UIView alloc] initWithFrame:frame];
            [dot setBackgroundColor:[KKUtilColor colorFromHexString:@"#36648B"]];
            [dot.layer setCornerRadius:4.0f];
            [view addSubview:dot];
        }
    }
}
@end
