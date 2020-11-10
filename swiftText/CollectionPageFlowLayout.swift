//
//  CollectionPageFlowLayout.swift
//  swiftText
//
//  Created by jingjun on 2020/11/10.
//  Copyright © 2020 景军. All rights reserved.
//

import UIKit

public class CollectionPageFlowLayout: UICollectionViewFlowLayout {
    
    public var lastOffset: CGPoint /**<记录上次滑动停止时contentOffset值*/
    
    public override init() {
        self.lastOffset = .zero
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepare() {
        super.prepare()

        /**
         * decelerationRate系统给出了2个值：
         * 1. UIScrollViewDecelerationRateFast（速率快）
         * 2. UIScrollViewDecelerationRateNormal（速率慢）
         * 此处设置滚动加速度率为fast，这样在移动cell后就会出现明显的吸附效果
         *
         *self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
         */
        // 设置lastOffset初始值
        self.lastOffset = self.collectionView?.contentOffset ?? .zero
        self.collectionView?.decelerationRate = .fast
    }
    
}

extension CollectionPageFlowLayout {
    
    /**
     * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
     */

    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var proposedContentOffset = proposedContentOffset
        let pageSpace = self.stepSpace()
        let offsetMax: CGFloat = self.collectionView?.contentSize.width ?? ScreenW - (pageSpace + self.sectionInset.right + self.minimumLineSpacing)
        let offsetMin: CGFloat = 0
        /*修改之前记录的位置，如果小于最小contentsize或者大于最大contentsize则重置值*/
        if self.lastOffset.x < offsetMin {
            lastOffset.x = offsetMin
        }else if self.lastOffset.x > offsetMax {
            lastOffset.x = offsetMax
        }
        
        let offsetForCurrentPointX: CGFloat = abs(proposedContentOffset.x - self.lastOffset.x) //目标位移点距离当前点的距离绝对值
        let velocityX: CGFloat = velocity.x
        let direction:Bool = (proposedContentOffset.x - self.lastOffset.x) > 0 //判断当前滑动方向,手指向左滑动：YES；手指向右滑动：NO
        
        if offsetForCurrentPointX > (pageSpace / 8) && self.lastOffset.x >= offsetMin && lastOffset.x <= offsetMax {
            var pageFactor: CGFloat = 0 //分页因子，用于计算滑过的cell个数
            if velocityX != 0
            {
                // 滑动
                pageFactor = abs(velocityX) //速率越快，cell滑动的数量越多
            }else{
                /**
                 * 拖动
                 * 没有速率，则计算：位移差/默认步距=分页因子
                 */
                pageFactor = abs(offsetForCurrentPointX / pageSpace)
            }
            /*设置pageFactor上限为2, 防止滑动速率过大，导致翻页过多*/
            pageFactor = pageFactor<1 ? 1 : 1
            let pageOffsetX = pageSpace * pageFactor
            proposedContentOffset = CGPoint(x: self.lastOffset.x + (direction ? pageOffsetX : -pageOffsetX), y: proposedContentOffset.y)
        }else{
            proposedContentOffset = CGPoint(x: self.lastOffset.x,y: self.lastOffset.y)
        }
        //记录当前最新位置
        self.lastOffset.x = proposedContentOffset.x
        return proposedContentOffset
    }
    
    /**
     *计算每滑动一页的距离：步距
     */
    func stepSpace() -> CGFloat {
        return self.itemSize.width + self.minimumLineSpacing
    }
}
