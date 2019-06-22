//
//  ResizingTokenFieldViewModel.swift
//  ResizingTokenField
//
//  Created by Tadej Razborsek on 19/06/2019.
//  Copyright © 2019 Tadej Razborsek. All rights reserved.
//

import UIKit

class ResizingTokenFieldViewModel {
    var tokens: [ResizingTokenFieldToken] = []
    
    /// Convenience reference, used for calculating item sizes.
    private weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView?) {
        self.collectionView = collectionView
    }
    
    // MARK: - Font
    
    /// Font used by all labels.
    var font: UIFont = UIFont.systemFont(ofSize: Constants.Font.defaultSize)
    
    /// Height of items.
    var itemHeight: CGFloat = ceil(UIFont.systemFont(ofSize: Constants.Font.defaultSize).lineHeight)
    
    var textStyle: UIFont.TextStyle? {
        didSet { updateFont() }
    }
    var fontSize: CGFloat = Constants.Font.defaultSize {
        didSet { updateFont() }
    }
    
    func updateFont() {
        font = textStyle != nil ? UIFont.preferredFont(forTextStyle: textStyle!) : UIFont.systemFont(ofSize: fontSize)
        itemHeight = 4 + ceil(font.lineHeight) + 4   // Top + height + bottom
    }
    
    // MARK: - Text field cell
    
    /// The current size of the text field cell.
    var textFieldCellSize: CGSize {
        if let cachedSize = cachedTextFieldCellSize {
            return cachedSize
        }
        
        let calculatedSize = calculateTextFieldCellSize()
        cachedTextFieldCellSize = calculatedSize
        return calculatedSize
    }
    
    private var cachedTextFieldCellSize: CGSize?
    
    private func calculateTextFieldCellSize() -> CGSize {
        guard let collectionView = self.collectionView, let layout = collectionView.collectionViewLayout as? ResizingTokenFieldFlowLayout else {
            // Should never reach.
            return CGSize(width: Constants.TextFieldCell.minWidth, height: itemHeight)
        }
        
        var remainingWidth: CGFloat = 0
        let sectionInsets = layout.appropriateSectionInsetsForSectionAt(section: 0)
        if let cell = collectionView.cellForItem(at: textFieldCellIndexPath) {
            // Cell's frame should reach the end of current row.
            remainingWidth = collectionView.bounds.size.width - cell.frame.origin.x - sectionInsets.right
        }
        
        if remainingWidth < Constants.TextFieldCell.minWidth {
            // Text field cell should be in a new row, use all available width.
            return CGSize(width: collectionView.bounds.size.width - sectionInsets.left - sectionInsets.right, height: itemHeight)
        } else {
            // Text field cell fits in the same row.
            return CGSize(width: remainingWidth, height: itemHeight)
        }
    }
    
    func invalidateTextFieldCellSize() {
        cachedTextFieldCellSize = nil
    }
    
    func minimizeTextFieldCellSize() {
        cachedTextFieldCellSize = CGSize(width: Constants.TextFieldCell.minWidth, height: itemHeight)
    }
    
    // MARK: - Add/remove tokens
    
    /// Appends tokens to the end of the list.
    /// Returns index paths representing the new tokens.
    func append(tokens: [ResizingTokenFieldToken]) -> [IndexPath] {
        let start: Int = self.tokens.count
        self.tokens += tokens
        let end: Int = self.tokens.count
        
        var indexPaths: [IndexPath] = []
        for i: Int in start..<end {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        
        return indexPaths
    }
    
    // MARK: - Selecting tokens
    
    var lastTokenCellIndexPath: IndexPath? {
        guard tokens.count > 0 else { return nil }
        return IndexPath(item: tokens.count-1, section: 0)
    }
    
    // MARK: - Data source
    
    var numberOfItems: Int {
        return tokens.count + 1
    }
    
    func identifierForCell(atIndexPath indexPath: IndexPath) -> String {
        let isTextFieldCellIndexPath = indexPath.item == textFieldCellIndexPath.item
        if isTextFieldCellIndexPath {
            return TextFieldCell.identifier
        }
        
        return DefaultTokenCell.identifier
    }
    
    func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        let identifier = identifierForCell(atIndexPath: indexPath)
        switch identifier {
        case TextFieldCell.identifier:
            return textFieldCellSize
        case DefaultTokenCell.identifier:
            if let token = token(atIndexPath: indexPath) {
                return CGSize(width: DefaultTokenCell.width(forToken: token, font: font),
                              height: itemHeight)
            }
        default:
            break
        }
        
        // Should never reach
        return CGSize.zero
    }
    
    // MARK: - Text field cell
    
    var textFieldCellIndexPath: IndexPath {
        // The last cell
        return IndexPath(item: tokens.count, section: 0)
    }
    
    // MARK: - Tokens
    
    func token(atIndexPath indexPath: IndexPath) -> ResizingTokenFieldToken? {
        guard tokens.count > indexPath.item else { return nil }
        
        return tokens[indexPath.item]
    }
    
}
