//
//  ResizingTokenFieldFlowLayout.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

protocol ResizingTokenFieldFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: ResizingTokenFieldFlowLayout, heightDidChange newHeight: CGFloat)
    func lastCellIndexPath(in collectionView: UICollectionView, layout: ResizingTokenFieldFlowLayout) -> IndexPath
}

/// A UICollectionViewFlowLayout subclass, which:
/// - tracks content height changes
/// - left aligns items, as discussed in:
///     - https://stackoverflow.com/questions/22539979/left-align-cells-in-uicollectionview/
///     - https://stackoverflow.com/questions/13017257/how-do-you-determine-spacing-between-cells-in-uicollectionview-flowlayout/
/// - stretches the last cell to the end of its row
class ResizingTokenFieldFlowLayout: UICollectionViewFlowLayout {
    
    private var delegate: ResizingTokenFieldFlowLayoutDelegate? {
        return collectionView?.delegate as? ResizingTokenFieldFlowLayoutDelegate
    }
    
    // MARK: - Content height
    
    private var oldContentHeight: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        let contentSize = super.collectionViewContentSize
        
        if oldContentHeight != contentSize.height {
            oldContentHeight = contentSize.height
            if let collectionView = collectionView {
                delegate?.collectionView(collectionView, layout: self, heightDidChange: contentSize.height)
            }
        }
        
        return contentSize
    }
    
    // MARK: - Layout
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes: [UICollectionViewLayoutAttributes]? = super.layoutAttributesForElements(in: rect)
        
        // Map attributes to return value of layoutAttributesForItem(at:), which left aligns them.
        return layoutAttributes?.compactMap({ $0.representedElementKind == nil ? layoutAttributesForItem(at: $0.indexPath) : $0 })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView else { return nil }
        guard let copiedAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
        
        // If the current frame, once stretched to the full row intersects the previous frame then they are on the same row.
        let sectionInsets = appropriateSectionInsetsForSectionAt(section: indexPath.section)
        if indexPath.item != 0,
            let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame,
            copiedAttributes.frame.intersects(CGRect(x: -.infinity, y: previousFrame.origin.y, width: .infinity, height: previousFrame.size.height)) {
            // Next item in the same row.
            copiedAttributes.frame.origin.x = previousFrame.origin.x + previousFrame.size.width + appropriateMinimumInteritemSpacingForSectionAt(section: indexPath.section)
        } else {
            // First item in a new row.
            copiedAttributes.frame.origin.x = sectionInsets.left
        }
        
        let isLastCell: Bool = indexPath == delegate?.lastCellIndexPath(in: collectionView, layout: self)
        if isLastCell {
            // Last cell should stretch to end of the row.
            let remainingWidth: CGFloat = collectionView.bounds.size.width - copiedAttributes.frame.origin.x - sectionInsets.right
            copiedAttributes.frame.size.width = remainingWidth
        }
        
        return copiedAttributes
    }
    
    private func appropriateSectionInsetsForSectionAt(section: Int) -> UIEdgeInsets {
        guard let collectionView = self.collectionView else { return sectionInset }
        return (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? sectionInset
    }
    
    private func appropriateMinimumInteritemSpacingForSectionAt(section: Int) -> CGFloat {
        guard let collectionView = self.collectionView else { return minimumInteritemSpacing }
        return (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
}
