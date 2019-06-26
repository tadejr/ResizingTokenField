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
    
    // MARK: - Font
    
    /// Font used by all labels.
    var font: UIFont = Constants.Font.defaultFont {
        didSet { defaultItemHeight = 4 + ceil(font.lineHeight) + 4 }  // Top + height + bottom
    }
    
    /// Height of items.
    var defaultItemHeight: CGFloat = ceil(Constants.Font.defaultFont.lineHeight) + 8
    var customItemHeight: CGFloat?
    var itemHeight: CGFloat { return customItemHeight ?? defaultItemHeight }
    
    // MARK: - Label cell
    
    var isShowingLabelCell: Bool = Constants.LabelCell.isShownByDefault
    var labelCellText: String?
    
    var labelCellIndexPath: IndexPath {
        return IndexPath(item: 0, section: 0)
    }
    
    var labelCellSize: CGSize {
        return CGSize(width: LabelCell.width(forText: labelCellText, font: font),
                      height: itemHeight)
    }
    
    // MARK: - Text field cell
    
    var textFieldCellIndexPath: IndexPath {
        // The last cell
        return IndexPath(item: numberOfItems - 1, section: 0)
    }
    
    // The smallest allowed size of the text field cell.
    var textFieldCellMinWidth: CGFloat = Constants.TextFieldCell.defaultMinWidth
    var textFieldCellMinSize: CGSize {
        return CGSize(width: textFieldCellMinWidth, height: itemHeight)
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
            indexPaths.append(indexPathForToken(atIndex: i))
        }
        
        return indexPaths
    }
    
    /// Finds and removes tokens from the list.
    /// Returns index paths representing removed tokens.
    func remove(tokens: [ResizingTokenFieldToken]) -> [IndexPath] {
        var indexesToRemove: IndexSet = IndexSet()
        for token in tokens {
            // Find first occurence of this token.
            for i in 0..<self.tokens.count {
                if self.tokens[i].isEqual(to: token) {
                    indexesToRemove.insert(i)
                    break
                }
            }
        }
        
        return remove(tokensAtIndexes: indexesToRemove)
    }
    
    /// Removes tokens from the list.
    /// Returns index paths representing removed tokens.
    func remove(tokensAtIndexes indexes: IndexSet) -> [IndexPath] {
        var removedIndexPaths: [IndexPath] = []
        var removedCount: Int = 0
        for indexToRemove in indexes.sorted() {
            removedIndexPaths.append(indexPathForToken(atIndex: indexToRemove))
            let index: Int = indexToRemove - removedCount
            guard index < self.tokens.count else { continue }
            self.tokens.remove(at: index)
            removedCount += 1
        }
        
        return removedIndexPaths
    }
    
    // MARK: - Selecting tokens
    
    var lastTokenCellIndexPath: IndexPath? {
        guard tokens.count > 0 else { return nil }
        return IndexPath(item: numberOfItems - 2, section: 0)
    }
    
    func token(atIndexPath indexPath: IndexPath) -> ResizingTokenFieldToken? {
        let tokenIndex = indexForToken(atIndexPath: indexPath)
        guard tokenIndex >= 0, tokens.count > tokenIndex else { return nil }
        return tokens[tokenIndex]
    }
    
    private func indexForToken(atIndexPath indexPath: IndexPath) -> Int {
        return isShowingLabelCell ? indexPath.item - 1 : indexPath.item
    }
    
    private func indexPathForToken(atIndex index: Int) -> IndexPath {
        return IndexPath(item: isShowingLabelCell ? index + 1 : index,
                         section: 0)
    }
    
    // MARK: - Data source
    
    var numberOfItems: Int {
        var count = tokens.count + 1    // Tokens + text field cell
        if isShowingLabelCell { count += 1 } // Label cell
        return count
    }
    
    func identifierForCell(atIndexPath indexPath: IndexPath) -> String {
        switch indexPath.item {
        case (isShowingLabelCell ? labelCellIndexPath.item : nil):
            return Constants.Identifier.labelCell
        case textFieldCellIndexPath.item:
            return Constants.Identifier.textFieldCell
        default:
            return Constants.Identifier.tokenCell
        }
    }
    
    func defaultTokenCellSize(forToken token: ResizingTokenFieldToken) -> CGSize {
        return CGSize(width: DefaultTokenCell.width(forToken: token, font: font),
                      height: itemHeight)
    }
    
}
