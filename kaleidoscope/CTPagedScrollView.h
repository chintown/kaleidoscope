//
//  CTPagedScrollView.h
//  kaleidoscope
//
//  Created by Mike Chen on 3/28/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTPagedScrollView; // for using class in protocal

@protocol CTPagedScrollViewDataSource <NSObject>

- (NSUInteger) numReusablePages;
- (CGSize) pageCGSize;
- (UIView *)pageView:(CTPagedScrollView*)scrollView forIndex:(NSInteger) pageIndex;

- (BOOL) hasDataWithLowerIndex;
- (BOOL) hasDataWithHigherIndex;

@optional
- (CGFloat) wrapperWidth;
- (void) scollDidLandOnPageWithIndex: (int) pageIndex;
- (int) currentIndex;
@end

@interface CTPagedScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, getter = isPaging) BOOL paging;
@property (nonatomic, strong) IBOutlet id<CTPagedScrollViewDataSource> dataSource;

- (void) selfInit;
- (id) dequeueReusablePage;

@end
