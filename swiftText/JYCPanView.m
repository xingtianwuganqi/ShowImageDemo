//
//  JYCPanView.m
//  panGR
//
//  Created by 贾远潮 on 2017/9/28.
//  Copyright © 2017年 贾远潮. All rights reserved.
//

#import "JYCPanView.h"

@interface JYCPanView()<UIGestureRecognizerDelegate>



@end

@implementation JYCPanView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addPanGR];
    }
    return self;
}

- (void)addPanGR
{
    UIPanGestureRecognizer * panGestureGecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    panGestureGecognizer.delegate = self;
    [panGestureGecognizer setMaximumNumberOfTouches:1];
    [panGestureGecognizer setMinimumNumberOfTouches:1];
    [self addGestureRecognizer:panGestureGecognizer];
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateChanged ||
        pan.state == UIGestureRecognizerStateEnded) {
        
        UIView *view = pan.view;
        
        CGPoint offset = [pan translationInView:view];
        
        CGRect viewRect = view.frame;
        if (self.panDerection == JYCPanDerectionHorizontal) {
            viewRect = [self changeRectXWithViewFrame:viewRect offset:offset];
        } else if (self.panDerection == JYCPanDerectionVertical){
            viewRect = [self changeRectYWithViewFrame:viewRect offset:offset];
        } else if (self.panDerection == (JYCPanDerectionHorizontal | JYCPanDerectionVertical)){
            viewRect = [self changeRectXWithViewFrame:viewRect offset:offset];
            viewRect = [self changeRectYWithViewFrame:viewRect offset:offset];
        }
        
        if (pan.state == UIGestureRecognizerStateEnded) {
            CGRect rect = view.frame;
            if (self.panDerection == JYCPanDerectionHorizontal) {
                rect.origin.x = [self setEndRectXWithWithViewFrame:viewRect offset:offset];
            } else if (self.panDerection == JYCPanDerectionVertical){
                rect.origin.y = [self setEndRectYWithWithViewFrame:viewRect offset:offset];
            } else if (self.panDerection == (JYCPanDerectionHorizontal | JYCPanDerectionVertical)){
                rect.origin.x = [self setEndRectXWithWithViewFrame:viewRect offset:offset];
                rect.origin.y = [self setEndRectYWithWithViewFrame:viewRect offset:offset];
            }
            if (self.customAnimationBlock) {
                self.customAnimationBlock(rect);
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    view.frame = rect;
                } completion:^(BOOL finished) {
                    if (self.panDerection == JYCPanDerectionHorizontal) {
                        [self slideHorizontalResultWithEndFrame:rect];
                    } else if (self.panDerection == JYCPanDerectionVertical){
                        [self slideVerticalResultWithEndFrame:rect];
                    } else if (self.panDerection == (JYCPanDerectionHorizontal | JYCPanDerectionVertical)){
                        [self slideHorizontalResultWithEndFrame:rect];
                        [self slideVerticalResultWithEndFrame:rect];
                    }
                }];
            }
        } else {
            view.frame = CGRectMake(viewRect.origin.x, viewRect.origin.y, view.bounds.size.width, view.bounds.size.height);
        }
        [pan setTranslation:CGPointMake(0, 0) inView:view];
    }
}

/* 解决手势冲突问题
 * 1、当设置水平拖动时，手势竖直拖动距离大于手势水平拖动距离时，此手势不响应
   2、当拖动到最小值时，再往左拖动，不响应
   3、当拖动到最大值时，再往右拖动，不响应
   4、竖直逻辑同水平
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint offset = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:view];
        if (self.panDerection == JYCPanDerectionHorizontal && (fabs(offset.y) >= fabs(offset.x))) {
            return NO;
        }
        if (self.panDerection == JYCPanDerectionHorizontal && ((view.frame.origin.x == self.minX && offset.x < 0) ||  (view.frame.origin.x == self.maxX && offset.x > 0)) ) {
            return NO;
        }
        if (self.panDerection == JYCPanDerectionVertical && (fabs(offset.x) >= fabs(offset.y))) {
            return NO;
        }
        
        if (self.panDerection == JYCPanDerectionVertical && ((view.frame.origin.y == self.minY && offset.y < 0) ||  (view.frame.origin.y == self.maxY && offset.y > 0)) ) {
            return NO;
        }
        return YES;
    }
    return YES;
}


- (CGRect)changeRectXWithViewFrame:(CGRect)viewFrame offset:(CGPoint)offset
{
    CGRect rect = viewFrame;
    CGPoint viewRect = viewFrame.origin;
    viewRect.x += offset.x;
    if (viewRect.x >= self.maxX) {
        viewRect.x = self.maxX;
    }
    if (viewRect.x <= self.minX) {
        viewRect.x = self.minX;
    }
    rect.origin = viewRect;
    return rect;
}

- (CGRect)changeRectYWithViewFrame:(CGRect)viewFrame offset:(CGPoint)offset
{
    CGRect rect = viewFrame;
    CGPoint viewRect = viewFrame.origin;
    viewRect.y += offset.y;
    if (viewRect.y >= self.maxY) {
        viewRect.y = self.maxY;
    }
    if (viewRect.y <= self.minY) {
        viewRect.y = self.minY;
    }
    rect.origin = viewRect;
    return rect;
}

- (CGFloat)setEndRectXWithWithViewFrame:(CGRect)viewFrame offset:(CGPoint)offset
{
    CGFloat currentX = viewFrame.origin.x;
    CGFloat centerX = (self.maxX + self.minX) / 2.0;
    if (currentX > centerX) {
        currentX = self.maxX;
    } else {
        currentX = self.minX;
    }
    return currentX;
}

- (CGFloat)setEndRectYWithWithViewFrame:(CGRect)viewFrame offset:(CGPoint)offset
{
    CGFloat currentY = viewFrame.origin.y;
    CGFloat centerY = (self.maxY + self.minY) / 2.0;
    if (currentY > centerY) {
        currentY = self.maxY;
    } else {
        currentY = self.minY;
    }
    return currentY;
}

- (void)slideHorizontalResultWithEndFrame:(CGRect)rect
{
    if (self.viewHasSlidHorizontalMax) {
        if (rect.origin.x == self.maxX) {
            self.viewHasSlidHorizontalMax(YES);
        } else {
            self.viewHasSlidHorizontalMax(NO);
        }
    }
}

- (void)slideVerticalResultWithEndFrame:(CGRect)rect
{
    if (self.viewHasSlideVerticalMax) {
        if (rect.origin.y == self.maxY) {
            self.viewHasSlideVerticalMax(YES);
        } else {
            self.viewHasSlideVerticalMax(NO);
        }
    }
}
@end
