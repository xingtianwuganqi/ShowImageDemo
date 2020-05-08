//
//  JYCPanView.h
//  panGR
//
//  Created by 贾远潮 on 2017/9/28.
//  Copyright © 2017年 贾远潮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JYCPanDerection) {
    JYCPanDerectionHorizontal = 1 << 0, // 水平
    JYCPanDerectionVertical   = 1 << 1, // 竖直
};

@interface JYCPanView : UIView

@property (nonatomic, assign) CGFloat maxX;

@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) CGFloat minX;

@property (nonatomic, assign) CGFloat minY;

@property (nonatomic, assign) JYCPanDerection panDerection;

@property (nonatomic, copy) void (^customAnimationBlock)(CGRect endRect);

@property (nonatomic, copy) void (^viewHasSlidHorizontalMax)(BOOL isMax);

@property (nonatomic, copy) void (^viewHasSlideVerticalMax)(BOOL isMax);

@end
