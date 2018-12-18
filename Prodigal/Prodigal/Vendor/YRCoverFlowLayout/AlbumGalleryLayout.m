//
//  AlbumGalleryLayout.m
//  Prodigal
//
//  Created by bob.sun on 28/02/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//


#import "AlbumGalleryLayout.h"

@implementation AlbumGalleryLayout

- (void)prepareLayout {
    [super prepareLayout];
    
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    NSArray *arrayAttrs = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *ret = [@[] mutableCopy];
    UICollectionViewLayoutAttributes * change;
    for (UICollectionViewLayoutAttributes *attr in arrayAttrs) {
        change = [attr copy];
        CGFloat cell_centerX = attr.center.x;
        CGFloat distance = ABS(cell_centerX - centerX);
        CGFloat factor = 0.003;
        CGFloat scale = 1 / (1 + distance * factor);
        
        
        change.size = CGSizeMake(self.itemSize.width * 1.2, self.itemSize.height * 1.2);
        change.transform = CGAffineTransformMakeScale(scale, scale);
        [ret addObject:change];
    }
    
    return ret;
    
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    CGFloat visibleX = proposedContentOffset.x;
    CGFloat visibleY = proposedContentOffset.y;
    CGFloat visibleW = self.collectionView.bounds.size.width;
    CGFloat visibleH = self.collectionView.bounds.size.height;
    CGRect visibleRect = CGRectMake(visibleX, visibleY, visibleW, visibleH);
    
    NSArray *arrayAttrs = [super layoutAttributesForElementsInRect:visibleRect];

    int min_idx = 0;
    UICollectionViewLayoutAttributes *min_attr = arrayAttrs[min_idx];
    
    for (int i = 1; i < arrayAttrs.count; i++) {
        
        UICollectionViewLayoutAttributes *attr = arrayAttrs[i];
        
        if (ABS(attr.center.x - centerX) < ABS(min_attr.center.x - centerX)) {
            min_idx = i;
            min_attr = attr;
        }
    }
    
    CGFloat offsetX = min_attr.center.x - centerX;
    
    
    return CGPointMake(proposedContentOffset.x + offsetX, proposedContentOffset.y);
    
}
@end
