//
//  JS_FlowLayout.m
//  自定义 流水布局
//
//  Created by 浩哲 夏 on 2016/11/5.
//  Copyright © 2016年 浩哲 夏. All rights reserved.
//

#import "JS_FlowLayout.h"

@implementation JS_FlowLayout


// 准备布局
// 什么时候调用:开始布局的时候调用
// 作用: 初始化布局操作
// 计算每个cell的布局，前提：cell尺寸一开始固定
//-(void)prepareLayout{
//    [super prepareLayout];
//    
//    
//};

//返回很多cell的尺寸
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        //获取距离中心点的距离
       CGFloat dotCenter =  fabs((attribute.center.x - self.collectionView.contentOffset.x)-self.collectionView.bounds.size.width *0.5);
        //缩放比例
        CGFloat scale = 1- dotCenter/(self.collectionView.bounds.size.width *0.5) *0.30;
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return attributes;
}

////是否允许在滚动的时候 刷新布局 修改BoundsChange 修改偏移量
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
////确定最终 偏移量
////滚动时手指松开的时候 调用 <当滚动有缓冲的时候,最终偏移量不等于手指离开时的偏移量>
//
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // collection宽度
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    CGFloat offsetX = proposedContentOffset.x;
    
    // 获取显示的cell布局
    // 获取当前显示区域
    CGRect visableRect = CGRectMake(offsetX, 0, collectionW, self.collectionView.bounds.size.height);
    
    // 获取当前显示区域的所有cell
    NSArray *visableAtt = [super layoutAttributesForElementsInRect:visableRect];
    
    // 记录最小中心点位置
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attrs in visableAtt) {
        
        // 计算离中心点的距离
        CGFloat delta = fabs((attrs.center.x - offsetX) - collectionW * 0.5) ;
        
        // 获取上一个
        if (delta < fabs(minDelta)) { // 比较不需要关心负数
            
            // 有比较小间距的cell
            // 赋值需要
            minDelta = (attrs.center.x - offsetX) - collectionW * 0.5;
            
        }
    }
    
    proposedContentOffset.x += minDelta;
    // -0，就不会移动
    // 恢复为0
    
    if (proposedContentOffset.x <= 0) {
        proposedContentOffset.x = 0;
    }
    
    return proposedContentOffset;
    
}
////计算滚动范围
//-(CGSize)collectionViewContentSize{
//    
//}
@end
