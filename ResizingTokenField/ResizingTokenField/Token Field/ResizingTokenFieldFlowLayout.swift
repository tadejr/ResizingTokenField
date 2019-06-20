//
//  ResizingTokenFieldFlowLayout.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

/// A UICollectionViewFlowLayout subclass, which.
/// - tracks content height changes (onContentHeightChanged)
/// - left aligns items; from https://stackoverflow.com/questions/13017257/how-do-you-determine-spacing-between-cells-in-uicollectionview-flowlayout/
class ResizingTokenFieldFlowLayout: UICollectionViewFlowLayout {
    
    // Tracking content height changes
    var onContentHeightChanged: ((_ oldHeight: CGFloat, _ newHeight: CGFloat) -> Void)?
    private var oldContentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        let contentSize = super.collectionViewContentSize
        
        let oldHeight = oldContentHeight
        let newHeight = contentSize.height
        oldContentHeight = newHeight
        if oldHeight != newHeight {
            onContentHeightChanged?(oldHeight, newHeight)
        }
        
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes: [UICollectionViewLayoutAttributes]? = super.layoutAttributesForElements(in: rect)
        
        // Map attributes to return value of layoutAttributesForItem(at:), which left aligns them.
        return layoutAttributes?.compactMap({ $0.representedElementKind == nil ? layoutAttributesForItem(at: $0.indexPath) : $0 })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let copiedAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
        guard let collectionView = self.collectionView else { return nil }
        
        // If the current frame, once stretched to the full row intersects the previous frame then they are on the same row.
        if indexPath.item != 0,
            let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame,
            copiedAttributes.frame.intersects(CGRect(x: -.infinity, y: previousFrame.origin.y, width: .infinity, height: previousFrame.size.height)) {
            // Next item in the same row.
            let interimSpacing: CGFloat = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: indexPath.section) ?? minimumInteritemSpacing
            copiedAttributes.frame.origin.x = previousFrame.origin.x + previousFrame.size.width + interimSpacing
        } else {
            // First item in a new row.
            let insets: UIEdgeInsets = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, insetForSectionAt: indexPath.section) ?? sectionInset
            copiedAttributes.frame.origin.x = insets.left
        }
        
        return copiedAttributes
    }
    
}
