//
//  CTPagedScrollView.m
//  kaleidoscope
//
//  Created by Mike Chen on 3/28/13.
//  Copyright (c) 2013 Mike Chen. All rights reserved.
//
// https://github.com/ixnixnixn/IAInfiniteGridView

#import "CTPagedScrollView.h"

@interface CTPagedScrollView() // "extension" category

@property (nonatomic, strong) UIView *wrapView; // an additional child view as a wrapper for all the pagViews

@property (nonatomic) NSInteger currentIdx;
@property (nonatomic, strong) NSMutableArray *visiblePages; // aka "usedPage"
@property (nonatomic, strong) NSMutableArray *reusablePages; // maintained as a Queue

- (void) inspect;

- (UIView *) pageAtPoint: (CGPoint) point;
- (UIView *) pageAtArea: (CGRect) area;
- (CGFloat) getDistanceFromBoundsToCenterWrap;
- (void) updateVisibleBoundToCenterOfWrapper;
- (void) updateVisibleBoundToTopOfWrapper;
- (void) updateVisibleBoundToBottomOfWrapper;
- (void) updateVisibleBoundToXOfWrapper: (CGFloat) x;
- (void) swapPagesInBounds;
- (void) swapPagesFromWrapX: (CGFloat) lowX
                    toWrapX: (CGFloat) upX;
- (CGFloat) swapPageIntoBoundStartsFromWrapX: (CGFloat) x;
- (CGFloat) swapPageIntoBoundEndsToWrapX: (CGFloat) x;
- (void) swapPageOutofBound: (UIView *) page;

- (BOOL) isMovingForward;
- (BOOL) isMovingBackward;

@end

@implementation CTPagedScrollView {
    BOOL isInitOnce;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    //NSLog(@"===== init with coder @ Paged Scroll View =====");
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initInternals];
        [self initDisplay];
    }
    return self;
}
- (void) initInternals {
    isInitOnce = NO;
    self.currentIdx = 0;
    self.visiblePages = [[NSMutableArray alloc] init];
    self.reusablePages = [[NSMutableArray alloc] init];

    self.wrapView = [[UIView alloc] init];
    [self addSubview: self.wrapView];


    [self setPaging: YES];
    self.delegate = self; // self -> UIScrollViewDelegate
}
- (void) initDisplay {
    [self setShowsHorizontalScrollIndicator:NO];
}
- (void) selfInit {
    [self initWrapper];
}
- (void)initWrapper {
    NSAssert(self.dataSource != nil, @"data source is not  bind");
    //NSLog(@">>>>> data source is not  bind");

    // "content" is the playgorund that
    //      1) the children UIViews
    //      2) bound of scroll view
    // can move around.
    // should be larger than bound,
    // also larger than the total width of reusable pages
    float factor = 2;
    float playgroundW;

    if ([self.dataSource respondsToSelector:@selector(wrapperWidth)]) {
        playgroundW = [self.dataSource wrapperWidth];
    } else {
        playgroundW = factor
                        * [self.dataSource numReusablePages]
                        * [self.dataSource pageCGSize].width;
    }
    float playgroundH = [self.dataSource pageCGSize].height;

    // update   1) size              @ content of scroll view (aka playground
    //          2) size & coordinate @ wrapping view for all the children view
    self.contentSize    = CGSizeMake(       playgroundW, playgroundH);
    self.wrapView.frame = CGRectMake(0, 0,  playgroundW, playgroundH);
}
- (void) initOnce {
    if (!isInitOnce) {
        [self updateVisibleBoundToPositionOfCurrentIndex];
        isInitOnce = YES;
    }
}

// after xib loaded, this decides the size of internal elements
- (void)awakeFromNib {
    //NSLog(@"===== awakeFromNib @ Paged Scroll View =====");
    //[self initWrapper];
}

// this keeps updating layout during user interacts with scroll view
- (void)layoutSubviews {
    [super layoutSubviews];
    [self initOnce];

    // for a scroll view, bound rectangle (aka "viewport" or "sliding window")
    // moves around in the content rectagle (aka "playground" or "wrapper").
    // given a static size of playground,
    // if we want to have infinite/dynamic area for moving,
    // we need to periodically [[re-place]] the bound of scroll view
    // to the center of playground.
    // otherwise, it will hit the edge of playground, and stop.
    // note that, we need to update bound AND the pageViews which are visible to bound.
    //[self updateVisibleBoundToCenterOfWrapper]; // only happens when condition matched
    // bound rectangle


    // while the sliding window is moving to right, we need to
    // add few pages if the right edge of bounds exceeds the right edge of last page.
    // then, remove the heading pages if they were out of visible bound
    //
    // vice versa. if the sliding window is moving left. we need to
    // "supply the page" from the left hand side
    [self swapPagesInBounds]; // swaping is decided by wrap's contentOffset
}

# pragma mark Private task util
- (void) inspect {
    float wrapW = self.wrapView.frame.size.width;
    NSLog(@"    [S] wrapr: |%f %f <- %f -> %f %f|",
          0.,
          wrapW/2 - [self.dataSource pageCGSize].width/2,
          wrapW/2,
          wrapW/2 + [self.dataSource pageCGSize].width/2,
          wrapW);
    CGRect boundOnWrap = [self convertRect:self.bounds toView:self.wrapView];
    NSLog(@"    [S] bound: [%f %f] [%f %f]",
          self.contentOffset.x,
          self.contentOffset.x + boundOnWrap.size.width,
          boundOnWrap.origin.x,
          boundOnWrap.origin.x + boundOnWrap.size.width);

    [self.visiblePages enumerateObjectsUsingBlock:^(UIView *page, NSUInteger idx, BOOL *STOP) {
        //CGPoint center = page.center;
        //CGPoint centerOnWrap = [self.wrapView convertPoint:center toView:self.wrapView];
        //NSLog(@"page %d: [%f %f]", idx, centerOnWrap.x - page.bounds.size.width / 2, centerOnWrap.x + page.bounds.size.width / 2);
        NSLog(@"    [S] page %d: [%f %f]", idx, page.frame.origin.x, page.frame.origin.x + page.frame.size.width);
    }];

    return;
}
// senario: when user drag-n-stop-n-drop, we need to decide that
// which page is stopped by. then calibrate the landing location
// of the page smoothly
- (UIView *) pageAtPoint: (CGPoint) point {
    __block UIView *matchedPage = nil;
    [self.visiblePages enumerateObjectsUsingBlock:^
     (UIView *page, NSUInteger idx, BOOL *stop) {

         if (CGRectContainsPoint(page.frame, point)) {
             matchedPage = page;
             *stop = YES;
         }
     }];
    return matchedPage;
}
- (UIView *) pageAtArea: (CGRect) area {
    __block UIView *matchedPage = nil;
    [self.visiblePages enumerateObjectsUsingBlock:^
     (UIView *page, NSUInteger idx, BOOL *stop) {

         if (CGRectIntersectsRect(page.frame, area)) {
             matchedPage = page;
             *stop = YES;
         }
     }];
    return matchedPage;
}

- (CGFloat) getDistanceFromBoundsToCenterWrap {
    // on wrap coordinat system

    CGFloat wrapW = self.contentSize.width;
    CGFloat wrapCenterX = wrapW / 2;

    CGFloat boundsW = self.bounds.size.width;
    CGFloat boundsCenterXOnWrap = self.contentOffset.x + boundsW / 2;

    // keep direction. dont use fabs
    CGFloat dist = boundsCenterXOnWrap - wrapCenterX;
    //NSLog(@"dist to center %f", dist);
    return dist;
}
- (void) updateVisibleBoundToPositionOfCurrentIndex {
    int index = [self.dataSource currentIndex];
    NSLog(@"    [S] ............%d...........", index);
    float x = index * [self.dataSource pageCGSize].width;
    NSLog(@"    [S]             %f           ", x);
    [self updateVisibleBoundToXOfWrapper: x];
}
- (void) updateVisibleBoundToCenterOfWrapper {
    CGFloat boundsW = self.bounds.size.width;

    CGFloat wrapW = self.contentSize.width;
    CGFloat acceptedDistanceFromBoundsToCenter = wrapW / 4.0f;

    CGFloat distance = [self getDistanceFromBoundsToCenterWrap];
    //NSLog(@"%f <= %f", distance, acceptedDistanceFromBoundsToCenter);
    if (fabs(distance) <= acceptedDistanceFromBoundsToCenter
        ) {
        return;
    }
    NSLog(@"    [S] [[[ RE-CENTER ]]]");
    [self updateVisibleBoundToXOfWrapper: wrapW / 2 - boundsW / 2];
}
- (void) updateVisibleBoundToTopOfWrapper {
    [self updateVisibleBoundToXOfWrapper: 0];
}
- (void) updateVisibleBoundToBottomOfWrapper {
    [self updateVisibleBoundToXOfWrapper: self.wrapView.bounds.size.width - self.bounds.size.width];
}
- (void) updateVisibleBoundToXOfWrapper: (CGFloat) x {
    // 1. update bounds x, keep y.
    //      note that, offset should be assigned pair-wise

    CGFloat distance = self.contentOffset.x - x;
    self.contentOffset = CGPointMake(x, self.contentOffset.y);

    // 2. update all visible pages
    [self.visiblePages enumerateObjectsUsingBlock:^(UIView *page, NSUInteger idx, BOOL *STOP) {
        CGPoint currCenter = page.center;
        CGPoint newCenter = [self.wrapView convertPoint:currCenter toView:self.wrapView];
        newCenter.x = currCenter.x - distance;
        page.center = newCenter;
    }];
}
- (void) swapPagesInBounds {
    CGRect bounds = [self convertRect:self.bounds toView:self.wrapView];
    CGFloat leftBound = bounds.origin.x;
    CGFloat rightBound = leftBound + bounds.size.width;
    [self swapPagesFromWrapX:leftBound toWrapX:rightBound];
}
- (void) swapPagesFromWrapX: (CGFloat) lowX
                    toWrapX: (CGFloat) upX {
    if ([self.visiblePages count] == 0) {
        [self swapPageIntoBoundStartsFromWrapX:lowX];
    }

    UIView *firstPage, *lastPage;

    // senario: swip left to view more page from RIGHT hand side ---------------

    // ADD pages into bound if "there is adequate space left on ..."
    // right hand side |   [][]--->|
    lastPage = [self.visiblePages lastObject];
    CGFloat rightX = CGRectGetMaxX(lastPage.frame);
    while (rightX < upX) {
        rightX = [self swapPageIntoBoundStartsFromWrapX:rightX];
    }
    // REMOVE pages out of queue if "it's edge exceeds visible bound" by checking ...
    // head of visible page queue
    firstPage = [self.visiblePages objectAtIndex:0];
    while (CGRectGetMaxX(firstPage.frame) < lowX) {
        [self swapPageOutofBound: firstPage];
        if ([self.visiblePages count] == 0) { // currently, this wont happen
            NSLog(@"    [S] no more visible to swap out");
            break;
        }
        firstPage = [self.visiblePages objectAtIndex:0];
    }

    // senario: swip right to view more page from LEFT hand side ---------------

    // ADD pages into bound if "there is adequate space left on ..."
    // left hand side  |<--[][][][]|
    firstPage = [self.visiblePages objectAtIndex:0];
    CGFloat leftX = CGRectGetMinX(firstPage.frame);
    while (lowX < leftX) {
        leftX = [self swapPageIntoBoundEndsToWrapX:leftX];
    }

    // REMOVE pages out of queue if "it's edge exceeds visible bound" by checking ...
    // tail of visible page queue
    lastPage = [self.visiblePages lastObject];
    while (upX < lastPage.frame.origin.x) {
        [self swapPageOutofBound: lastPage];
        if ([self.visiblePages count] == 0) { // currently, this wont happen
            NSLog(@"    [S] no more visible to swap out");
            break;
        }
        lastPage = [self.visiblePages lastObject];
    }
}
// swapping-in has 4 steps:
// 0. decide what index of page is the target (index stored in page's tag property)
// 1. get page from data source (aka dequeue-or-new)
// 2. put page into visible queue (tail or head)
// 3. add page as subview into wrap view
// 4. decide x/y position on wrap's coordinate
- (CGFloat) swapPageIntoBoundStartsFromWrapX: (CGFloat) x {
    CGFloat pageWidth = [self.dataSource pageCGSize].width;
    CGFloat newBoundX = x + pageWidth;

    // 0.
    int refIdx = ([self.visiblePages count] != 0)
                    ? ((UIView *)[self.visiblePages lastObject]).tag
                    : -1; // FIXME trick
    int targetIdx = refIdx + 1;
    // 1.
    UIView *page = [self.dataSource pageView:self
                                    forIndex:targetIdx];


    if (page == nil) {
        NSLog(@"    [S] (SKIP) swap. dataSources provide nil page");
        return newBoundX;
    }


    page.tag = targetIdx; // page might be new (generated by data source); assign index
    // 2.
    [self.visiblePages addObject:   page];

    // 3.
    [self.wrapView addSubview:      page];

    // 4.

    CGRect frame = page.frame;
    frame.origin.x = x;
    frame.origin.y = 0;
    page.frame = frame;

    return newBoundX;
}
- (CGFloat) swapPageIntoBoundEndsToWrapX: (CGFloat) x {
    CGFloat pageWidth = [self.dataSource pageCGSize].width;
    CGFloat newBoundX = x - pageWidth;

    // 0.
    int refIdx = ([self.visiblePages count] != 0)
                    ? ((UIView *)[self.visiblePages objectAtIndex:0]).tag
                    : 1; // FIXME trick
    int targetIdx = refIdx - 1;
    // 1.
    UIView *page = [self.dataSource pageView:self
                                    forIndex:targetIdx];


    if (page == nil) {
        NSLog(@"    [S] (SKIP) swap. dataSources provide nil page");
        return newBoundX;
    }


    page.tag = targetIdx; // page might be new (generated by data source); assign index
    // 2.
    [self.visiblePages insertObject:page atIndex:0];

    // 3.
    [self.wrapView addSubview:      page];

    // 4.
    CGRect frame = page.frame;
    frame.origin.x = newBoundX;
    frame.origin.y = 0;
    page.frame = frame;

    return newBoundX;
}

// swapping-out has 3 steps:
// 1. remove it from visible (in-use) queue
// 2. add it back to reusablePages queue
// 3. remove it from wrap view
- (void) swapPageOutofBound: (UIView *) page {
    //int index = [self.visiblePages indexOfObject:page];

    [self.visiblePages removeObject:page];
    [self.reusablePages addObject:page];
    [page removeFromSuperview];
}

// make sure calling this before the velocity is up-to-date
- (BOOL) isMovingForward {
    CGFloat velocity = [self.panGestureRecognizer velocityInView:[self superview]].x;
    return velocity < 0;
}
- (BOOL) isMovingBackward {
    CGFloat velocity = [self.panGestureRecognizer velocityInView:[self superview]].x;
    return velocity > 0;
}
# pragma mark Public task util

- (id) dequeueReusablePage {
    id page = [self.reusablePages lastObject];
    [self.reusablePages removeObject:page];
    return page;

}

# pragma mark - Scroll View Delegate
// make landing smoothly on edge of page //
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (!self.isPaging) {
        return;
    }

    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:[self superview]];
    CGPoint currentX = scrollView.contentOffset;
    UIView *page = [self pageAtPoint: currentX];

    CGPoint destPoint = (velocity.x < 0)
                       ? CGPointMake(page.bounds.size.width, 0.0) // swip to left, move forward
                       : CGPointMake(0, 0.0); // swip to right, move backward

    destPoint = [page convertPoint:destPoint toView:self.wrapView];
    if (destPoint.x >= self.wrapView.frame.size.width) {
        destPoint.x = self.wrapView.frame.size.width - [self.dataSource pageCGSize].width;
    }

    // smoothly land at the edge of side of moving direction
    [scrollView setContentOffset:destPoint animated:YES];

    UIView *landPage = [self pageAtPoint: CGPointMake(destPoint.x+1, destPoint.y)];
    if (landPage != nil && [self.dataSource respondsToSelector:@selector(scollDidLandOnPageWithIndex:)]) {
       [self.dataSource scollDidLandOnPageWithIndex: landPage.tag];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.isPaging) {
        return;
    } else if (decelerate) {
        return; // drag-n-drop
    }
    // drag-n-STOP-n-drop

    CGPoint currentXOnWrap = scrollView.contentOffset;
    UIView *page = [self pageAtPoint:currentXOnWrap];
    CGPoint currentXOnPage = [scrollView convertPoint:currentXOnWrap toView:page];

    BOOL stopOnRightPartOfPage = ((page.bounds.size.width / 2) < currentXOnPage.x);
    CGPoint destPoint = (stopOnRightPartOfPage)
                       ? CGPointMake(page.bounds.size.width, 0.0) // swip to left, move forward
                       : CGPointMake(0, 0.0); // swip to right, move backward
    destPoint = [page convertPoint:destPoint toView:self.wrapView];
    // smoothly land at the edge of side of moving direction
    [UIView animateWithDuration:.15
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{scrollView.contentOffset = destPoint;}
                     completion:nil];

    UIView *landPage = [self pageAtPoint: CGPointMake(destPoint.x+1, destPoint.y)];
    if (landPage != nil && [self.dataSource respondsToSelector:@selector(scollDidLandOnPageWithIndex:)]) {
       [self.dataSource scollDidLandOnPageWithIndex: landPage.tag];
    }
}
@end
