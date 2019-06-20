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
    var font: UIFont = UIFont.systemFont(ofSize: Constants.Font.defaultSize)
    
    /// Height of items.
    var itemHeight: CGFloat = UIFont.systemFont(ofSize: Constants.Font.defaultSize).lineHeight
    
    var textStyle: UIFont.TextStyle? {
        didSet { updateFont() }
    }
    var fontSize: CGFloat = Constants.Font.defaultSize {
        didSet { updateFont() }
    }
    
    func updateFont() {
        font = textStyle != nil ? UIFont.preferredFont(forTextStyle: textStyle!) : UIFont.systemFont(ofSize: fontSize)
        itemHeight = 4 + font.lineHeight + 4   // Top + height + bottom
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
            return CGSize(width: 200, height: itemHeight)
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
